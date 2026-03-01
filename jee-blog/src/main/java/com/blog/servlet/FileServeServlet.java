package com.blog.servlet;

import com.blog.util.FileUploadUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/uploads/*")
public class FileServeServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(FileServeServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String filename = pathInfo.substring(1);

        // Path traversal protection: reject any path with ".." or that tries to escape
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            logger.warn("Tentative de path traversal détectée: {} depuis {}", filename, req.getRemoteAddr());
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit");
            return;
        }

        File file = new File(FileUploadUtil.UPLOAD_DIR, filename);

        // Additional safety: verify canonical path is within upload directory
        String canonicalPath = file.getCanonicalPath();
        String uploadDirCanonical = new File(FileUploadUtil.UPLOAD_DIR).getCanonicalPath();
        if (!canonicalPath.startsWith(uploadDirCanonical)) {
            logger.warn("Tentative d'accès en dehors du répertoire d'upload: {} depuis {}", canonicalPath,
                    req.getRemoteAddr());
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit");
            return;
        }

        if (!file.exists()) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Get the MIME type of the image
        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        res.setContentType(mimeType);
        res.setHeader("Content-Length", String.valueOf(file.length()));
        res.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        // Cache static content for 1 day
        res.setHeader("Cache-Control", "public, max-age=86400");

        // Copy input stream to output stream
        try (FileInputStream in = new FileInputStream(file);
                OutputStream out = res.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
