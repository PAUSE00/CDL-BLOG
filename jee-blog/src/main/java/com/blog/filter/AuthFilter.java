package com.blog.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Filtre d'authentification - protège les pages membres.
 * Configuration uniquement via web.xml (pas d'annotation @WebFilter).
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean connecte = (session != null && session.getAttribute("membre") != null);

        if (!connecte) {
            String redirectUri = req.getRequestURI();
            String query = req.getQueryString();
            if (query != null) {
                redirectUri += "?" + query;
            }
            res.sendRedirect(req.getContextPath() + "/connexion?redirect=" + redirectUri);
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void init(FilterConfig fc) {
    }

    @Override
    public void destroy() {
    }
}
