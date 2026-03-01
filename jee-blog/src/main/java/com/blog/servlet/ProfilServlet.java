package com.blog.servlet;

import com.blog.dao.ArticleDAO;
import com.blog.dao.FollowDAO;
import com.blog.dao.MembreDAO;
import com.blog.model.Article;
import com.blog.model.Membre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import com.blog.util.FileUploadUtil;

@WebServlet(urlPatterns = { "/profil", "/profil/modifier", "/profil/changer-mdp", "/profil/avatar" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ProfilServlet extends HttpServlet {

    private MembreDAO membreDAO = new MembreDAO();
    private ArticleDAO articleDAO = new ArticleDAO();
    private FollowDAO followDAO = new FollowDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Membre authUser = (Membre) req.getSession().getAttribute("membre");

        try {
            int profileId = authUser != null ? authUser.getId() : -1;

            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                profileId = Integer.parseInt(idParam);
            }

            if (profileId == -1) {
                res.sendRedirect(req.getContextPath() + "/connexion");
                return;
            }

            Membre profileUser = membreDAO.trouverParId(profileId);
            if (profileUser == null) {
                res.sendError(404);
                return;
            }

            // Mettre le profil consulté (peut être soi-même)
            req.setAttribute("profileUser", profileUser);

            // Lister ses articles
            List<Article> articles = articleDAO.listerParMembre(profileId);
            req.setAttribute("mesArticles", articles);

            // Follow stats
            req.setAttribute("followersCount", followDAO.countFollowers(profileId));
            req.setAttribute("followingCount", followDAO.countFollowing(profileId));

            // Is Auth User following Profile User?
            if (authUser != null && authUser.getId() != profileId) {
                req.setAttribute("isFollowing", followDAO.isFollowing(authUser.getId(), profileId));
            }

            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, res);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        Membre membre = (Membre) req.getSession().getAttribute("membre");

        try {
            if ("/profil/modifier".equals(path)) {
                membre.setNom(req.getParameter("nom").trim());
                membre.setPrenom(req.getParameter("prenom").trim());
                membre.setBio(req.getParameter("bio"));
                membreDAO.mettreAJourProfil(membre);
                req.getSession().setAttribute("membre", membre);
                req.setAttribute("succes", true);
            } else if ("/profil/changer-mdp".equals(path)) {
                String nouveauMdp = req.getParameter("nouveau_mdp");
                String confirm = req.getParameter("confirm_mdp");
                if (nouveauMdp.equals(confirm) && nouveauMdp.length() >= 6) {
                    membreDAO.changerMotDePasse(membre.getId(), nouveauMdp);
                    req.setAttribute("succesMdp", true);
                } else {
                    req.setAttribute("erreurMdp", "Mots de passe invalides.");
                }
            } else if ("/profil/avatar".equals(path)) {
                Part filePart = req.getPart("avatar");
                String avatarUrl = FileUploadUtil.saveUploadedFile(filePart, req.getContextPath());
                if (avatarUrl != null) {
                    membre.setAvatar(avatarUrl);
                    membreDAO.mettreAJourProfil(membre);
                    req.getSession().setAttribute("membre", membre);
                }
            }
            res.sendRedirect(req.getContextPath() + "/profil");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
