package com.blog.servlet;

import com.blog.dao.ArticleDAO;
import com.blog.dao.LikeDAO;
import com.blog.dao.NotificationDAO;
import com.blog.model.Article;
import com.blog.model.Membre;
import com.blog.model.Notification;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/like")
public class LikeServlet extends HttpServlet {
    private LikeDAO likeDAO = new LikeDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();
    private ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Membre membre = (Membre) session.getAttribute("membre");

        if (membre == null) {
            resp.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            int articleId = Integer.parseInt(req.getParameter("articleId"));
            String from = req.getParameter("from"); // pour la redirection

            boolean added = likeDAO.toggleLike(articleId, membre.getId());

            if (added) {
                // Créer une notification si on like
                Article a = articleDAO.trouverParId(articleId);

                if (a != null && a.getMembreId() != membre.getId()) {
                    Notification n = new Notification();
                    n.setMembreId(a.getMembreId()); // Owner of the article
                    n.setSourceMembreId(membre.getId()); // Who liked it
                    n.setType("like");
                    n.setArticleId(articleId);
                    notificationDAO.creer(n);
                }
            }

            if ("detail".equals(from)) {
                resp.sendRedirect(req.getContextPath() + "/article?id=" + articleId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
