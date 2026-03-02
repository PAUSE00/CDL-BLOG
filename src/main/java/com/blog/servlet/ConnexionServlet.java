package com.blog.servlet;

import com.blog.dao.MembreDAO;
import com.blog.model.Membre;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/connexion")
public class ConnexionServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ConnexionServlet.class);
    private MembreDAO membreDAO = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("membre") != null) {
            res.sendRedirect(req.getContextPath() + "/articles");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/connexion.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String mdp = req.getParameter("mot_de_passe");

        // Null-safe parameter handling
        if (email == null || email.trim().isEmpty() || mdp == null || mdp.isEmpty()) {
            req.setAttribute("erreur", "Email et mot de passe sont obligatoires.");
            req.getRequestDispatcher("/WEB-INF/jsp/connexion.jsp").forward(req, res);
            return;
        }

        email = email.trim().toLowerCase();

        try {
            Membre membre = membreDAO.authentifier(email, mdp);
            if (membre != null) {
                HttpSession session = req.getSession();
                session.setAttribute("membre", membre);
                session.setMaxInactiveInterval(30 * 60); // 30 min

                // Open redirect protection: validate redirect URL
                String redirect = req.getParameter("redirect");
                if (redirect != null && !redirect.isEmpty() && isValidRedirect(redirect, req)) {
                    res.sendRedirect(redirect);
                } else {
                    res.sendRedirect(req.getContextPath() + "/articles");
                }
            } else {
                logger.info("Tentative de connexion échouée pour: {}", email);
                req.setAttribute("erreur", "Email ou mot de passe incorrect, ou compte non validé.");
                req.getRequestDispatcher("/WEB-INF/jsp/connexion.jsp").forward(req, res);
            }
        } catch (Exception e) {
            logger.error("Erreur lors de l'authentification", e);
            req.setAttribute("erreur", "Erreur serveur. Veuillez réessayer.");
            req.getRequestDispatcher("/WEB-INF/jsp/connexion.jsp").forward(req, res);
        }
    }

    /**
     * Validates that a redirect URL is safe (relative to the app, not an external
     * site).
     */
    private boolean isValidRedirect(String url, HttpServletRequest req) {
        // Must start with / but not // (protocol-relative URL)
        if (!url.startsWith("/") || url.startsWith("//")) {
            return false;
        }
        // Must start with context path
        String contextPath = req.getContextPath();
        if (!contextPath.isEmpty() && !url.startsWith(contextPath)) {
            return false;
        }
        // No protocol injection
        if (url.contains("://")) {
            return false;
        }
        return true;
    }
}
