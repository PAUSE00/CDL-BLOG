package com.blog.servlet;

import com.blog.dao.MembreDAO;
import com.blog.dao.MessageDAO;
import com.blog.model.Membre;
import com.blog.model.Message;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {
    private MessageDAO messageDAO = new MessageDAO();
    private MembreDAO membreDAO = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Membre membre = (Membre) session.getAttribute("membre");

        if (membre == null) {
            resp.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            // Liste des conversations existantes
            List<Membre> conversations = messageDAO.getConversations(membre.getId());
            req.setAttribute("conversations", conversations);

            // Gérer l'ouverture d'une conversation spécifique si l'ID est fourni
            String userIdStr = req.getParameter("userId");
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int correspondantId = Integer.parseInt(userIdStr);
                Membre correspondant = membreDAO.trouverParId(correspondantId);

                if (correspondant != null) {
                    List<Message> history = messageDAO.getConversation(membre.getId(), correspondantId);
                    req.setAttribute("currentConversation", history);
                    req.setAttribute("correspondant", correspondant);

                    // Marquer comme lu
                    messageDAO.marquerCommeVu(correspondantId, membre.getId());
                }
            }

            req.getRequestDispatcher("/WEB-INF/jsp/messages.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Membre membre = (Membre) session.getAttribute("membre");

        if (membre == null) {
            resp.sendRedirect(req.getContextPath() + "/connexion");
            return;
        }

        try {
            int destinataireId = Integer.parseInt(req.getParameter("destinataireId"));
            String contenu = req.getParameter("contenu");

            if (contenu != null && !contenu.trim().isEmpty()) {
                Message msg = new Message();
                msg.setExpediteurId(membre.getId());
                msg.setDestinataireId(destinataireId);
                msg.setContenu(contenu);

                messageDAO.envoyer(msg);
            }

            resp.sendRedirect(req.getContextPath() + "/messages?userId=" + destinataireId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
