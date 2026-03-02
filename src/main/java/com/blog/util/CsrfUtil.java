package com.blog.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utilitaire CSRF - génère et valide les tokens contre les attaques Cross-Site
 * Request Forgery.
 */
public class CsrfUtil {

    private static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final SecureRandom secureRandom = new SecureRandom();

    /**
     * Obtenir ou créer un token CSRF pour la session courante.
     */
    public static String getToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        String token = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        if (token == null) {
            token = generateToken();
            session.setAttribute(CSRF_TOKEN_ATTR, token);
        }
        return token;
    }

    /**
     * Valider le token CSRF soumis dans la requête POST.
     */
    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);
        String requestToken = request.getParameter("_csrf");
        if (requestToken == null) {
            // Also check header for AJAX requests
            requestToken = request.getHeader("X-CSRF-Token");
        }
        return sessionToken != null && sessionToken.equals(requestToken);
    }

    /**
     * Générer un champ hidden HTML contenant le token CSRF.
     */
    public static String getHiddenField(HttpServletRequest request) {
        return "<input type=\"hidden\" name=\"_csrf\" value=\"" + getToken(request) + "\">";
    }

    private static String generateToken() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
