package com.blog.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Locale;

/**
 * Filtre d'internationalisation - gère la langue choisie
 */
@WebFilter("/*")
public class LangueFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        // Changer la langue si paramètre présent
        String lang = req.getParameter("lang");
        if (lang != null && (lang.equals("fr") || lang.equals("en"))) {
            session.setAttribute("langue", lang);
        }

        // Initialiser la langue par défaut
        if (session.getAttribute("langue") == null) {
            session.setAttribute("langue", "fr");
        }

        // Configurer la locale pour JSTL fmt
        String langue = (String) session.getAttribute("langue");
        Locale locale = langue.equals("en") ? Locale.ENGLISH : Locale.FRENCH;
        req.setAttribute("javax.servlet.jsp.jstl.fmt.locale.session", locale);

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
