package com.blog.servlet;

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
import java.sql.SQLException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Membre membre = (Membre) session.getAttribute("membre");

        if (membre == null) {
            resp.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            List<Notification> notifs = notificationDAO.getParMembre(membre.getId());
            req.setAttribute("notifications", notifs);

            // Marquer comme lues si on visite la page
            notificationDAO.marquerToutesLues(membre.getId());

            req.getRequestDispatcher("/WEB-INF/jsp/notifications.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
