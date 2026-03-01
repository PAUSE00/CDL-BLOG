package com.blog.servlet;

import com.blog.dao.MembreDAO;
import com.blog.dao.FollowDAO;
import com.blog.model.Membre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/membres")
public class MembreServlet extends HttpServlet {

    private MembreDAO membreDAO = new MembreDAO();
    private FollowDAO followDAO = new FollowDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            List<Membre> membres = membreDAO.listerTous();

            Membre currentUser = (Membre) req.getSession().getAttribute("membre");
            if (currentUser != null) {
                // Get list of IDs the current user is following
                List<Membre> following = followDAO.getFollowing(currentUser.getId());
                Set<Integer> followingIds = following.stream()
                        .map(Membre::getId)
                        .collect(Collectors.toSet());

                for (Membre m : membres) {
                    if (followingIds.contains(m.getId())) {
                        m.setEstSuivi(true);
                    }
                }

                // Remove current user from the list if present
                membres.removeIf(m -> m.getId() == currentUser.getId());
            }

            req.setAttribute("membres", membres);
            req.setAttribute("pageTitle", "Découvrir des membres");
            req.getRequestDispatcher("/WEB-INF/jsp/membres.jsp").forward(req, res);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
