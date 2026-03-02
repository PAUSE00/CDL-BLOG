package com.blog.servlet;

import com.blog.dao.CommentaireDAO;
import com.blog.model.Commentaire;
import com.blog.model.Membre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = { "/commentaires/ajouter", "/commentaires/supprimer" })
public class CommentaireServlet extends HttpServlet {

    private CommentaireDAO commentaireDAO = new CommentaireDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        Membre membre = (Membre) req.getSession().getAttribute("membre");

        try {
            if ("/commentaires/ajouter".equals(path)) {
                int articleId = Integer.parseInt(req.getParameter("article_id"));
                String contenu = req.getParameter("contenu").trim();
                if (!contenu.isEmpty()) {
                    Commentaire c = new Commentaire();
                    c.setContenu(contenu);
                    c.setArticleId(articleId);
                    c.setMembreId(membre.getId());
                    commentaireDAO.ajouter(c);
                }
                String referer = req.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    res.sendRedirect(referer);
                } else {
                    res.sendRedirect(req.getContextPath() + "/articles/voir?id=" + articleId + "#commentaires");
                }
            } else if ("/commentaires/supprimer".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                int articleId = Integer.parseInt(req.getParameter("article_id"));
                commentaireDAO.supprimer(id, membre.getId());
                String referer = req.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    res.sendRedirect(referer);
                } else {
                    res.sendRedirect(req.getContextPath() + "/articles/voir?id=" + articleId + "#commentaires");
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
