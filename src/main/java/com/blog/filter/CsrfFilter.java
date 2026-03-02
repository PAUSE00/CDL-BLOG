package com.blog.filter;

import com.blog.util.CsrfUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Filtre CSRF - valide les tokens sur toutes les requêtes POST.
 * Génère automatiquement un token en session pour les requêtes GET.
 */
public class CsrfFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(CsrfFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Ensure a CSRF token exists in session for all requests
        String token = CsrfUtil.getToken(req);
        req.setAttribute("csrfToken", token);
        req.setAttribute("csrfField", CsrfUtil.getHiddenField(req));

        // Validate CSRF token on POST requests
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            if (!CsrfUtil.isValid(req)) {
                logger.warn("CSRF token invalide pour {} depuis {}", req.getRequestURI(), req.getRemoteAddr());
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token invalide");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void destroy() {
    }
}
