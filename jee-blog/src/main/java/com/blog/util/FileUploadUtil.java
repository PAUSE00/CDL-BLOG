package com.blog.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class FileUploadUtil {

    private static final Logger logger = LoggerFactory.getLogger(FileUploadUtil.class);

    // Store outside webapp so it doesn't get deleted on redeploy
    public static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "jee-blog-uploads";

    // Whitelist of allowed image extensions
    private static final Set<String> ALLOWED_EXTENSIONS = new HashSet<>(
            Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg"));

    // Whitelist of allowed MIME types
    private static final Set<String> ALLOWED_MIME_TYPES = new HashSet<>(
            Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp", "image/svg+xml"));

    static {
        // Ensure upload directory exists
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
    }

    /**
     * Saves an uploaded file to the local filesystem and returns the relative URL
     * to access it. Only image files are accepted.
     */
    public static String saveUploadedFile(Part part, String contextPath) throws Exception {
        if (part == null || part.getSize() == 0 || part.getSubmittedFileName() == null
                || part.getSubmittedFileName().trim().isEmpty()) {
            return null; // No file uploaded
        }

        String originalFileName = part.getSubmittedFileName().trim();
        String fileExtension = "";
        int i = originalFileName.lastIndexOf('.');
        if (i > 0) {
            fileExtension = originalFileName.substring(i).toLowerCase();
        }

        // Validate file extension
        if (!ALLOWED_EXTENSIONS.contains(fileExtension)) {
            logger.warn("Tentative d'upload de fichier non autorisé: {}", originalFileName);
            throw new SecurityException("Type de fichier non autorisé. Extensions acceptées : "
                    + String.join(", ", ALLOWED_EXTENSIONS));
        }

        // Validate MIME type
        String contentType = part.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            logger.warn("Type MIME non autorisé: {} pour le fichier {}", contentType, originalFileName);
            throw new SecurityException("Type MIME non autorisé : " + contentType);
        }

        // Generate unique filename to prevent overwriting
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

        Path filePath = Paths.get(UPLOAD_DIR, uniqueFileName);

        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        logger.info("Fichier uploadé avec succès: {}", uniqueFileName);

        // Return the path that the FileServeServlet will use to serve it
        return contextPath + "/uploads/" + uniqueFileName;
    }
}
