package com.blog.servlet;

import com.blog.dao.CollectionDAO;
import com.blog.model.Article;
import com.blog.model.Membre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = { "/collection", "/collection/sauvegarder", "/collection/retirer" })
public class CollectionServlet extends HttpServlet {

    private CollectionDAO collectionDAO = new CollectionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Membre membre = (Membre) req.getSession().getAttribute("membre");
        if (membre == null) {
            res.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            List<Article> articles = collectionDAO.listerParMembre(membre.getId());
            req.setAttribute("articles", articles);
            req.getRequestDispatcher("/WEB-INF/jsp/collection.jsp").forward(req, res);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Membre membre = (Membre) req.getSession().getAttribute("membre");
        if (membre == null) {
            res.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        String path = req.getServletPath();
        try {
            int articleId = Integer.parseInt(req.getParameter("articleId"));
            if ("/collection/sauvegarder".equals(path)) {
                collectionDAO.sauvegarder(articleId, membre.getId());
            } else if ("/collection/retirer".equals(path)) {
                collectionDAO.retirer(articleId, membre.getId());
            }

            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                res.sendRedirect(referer);
            } else {
                res.sendRedirect(req.getContextPath() + "/");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
