package com.blog.servlet;

import com.blog.dao.FollowDAO;
import com.blog.dao.NotificationDAO;
import com.blog.model.Membre;
import com.blog.model.Notification;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/follow")
public class FollowServlet extends HttpServlet {
    private FollowDAO followDAO = new FollowDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Membre membre = (Membre) session.getAttribute("membre");

        if (membre == null) {
            resp.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            int followingId = Integer.parseInt(req.getParameter("followingId"));
            // String from = req.getParameter("from");

            // Ne peut pas se suivre soi-même
            if (followingId == membre.getId()) {
                resp.sendRedirect(req.getContextPath() + "/profil?id=" + followingId);
                return;
            }

            boolean added = followDAO.toggleFollow(membre.getId(), followingId);

            if (added) {
                // Notifier l'utilisateur suivi
                Notification n = new Notification();
                n.setMembreId(followingId);
                n.setSourceMembreId(membre.getId());
                n.setType("follow");
                notificationDAO.creer(n);
            }

            resp.sendRedirect(req.getContextPath() + "/profil?id=" + followingId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
