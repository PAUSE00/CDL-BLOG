package com.blog.servlet;

import com.blog.dao.MembreDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/valider-compte")
public class ValidationCompteServlet extends HttpServlet {

    private MembreDAO membreDAO = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/");
            return;
        }
        try {
            boolean ok = membreDAO.validerCompte(token);
            req.setAttribute("valide", ok);
            req.getRequestDispatcher("/WEB-INF/jsp/validation-resultat.jsp").forward(req, res);
        } catch (Exception e) {
            req.setAttribute("valide", false);
            req.getRequestDispatcher("/WEB-INF/jsp/validation-resultat.jsp").forward(req, res);
        }
    }
}
