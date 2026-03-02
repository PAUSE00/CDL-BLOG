package com.blog.servlet;

import com.blog.dao.MembreDAO;
import com.blog.model.Membre;
import com.blog.util.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(InscriptionServlet.class);
    private MembreDAO membreDAO = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Null-safe parameter handling
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String mdp = req.getParameter("mot_de_passe");
        String mdpConfirm = req.getParameter("mdp_confirm");

        // Null checks before trim
        nom = (nom != null) ? nom.trim() : "";
        prenom = (prenom != null) ? prenom.trim() : "";
        email = (email != null) ? email.trim().toLowerCase() : "";
        mdp = (mdp != null) ? mdp : "";
        mdpConfirm = (mdpConfirm != null) ? mdpConfirm : "";

        // Validations
        if (nom.isEmpty() || prenom.isEmpty() || email.isEmpty() || mdp.isEmpty()) {
            req.setAttribute("erreur", "Tous les champs sont obligatoires.");
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
            return;
        }

        // Basic email format validation
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("erreur", "Format d'email invalide.");
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
            return;
        }

        if (!mdp.equals(mdpConfirm)) {
            req.setAttribute("erreur", "Les mots de passe ne correspondent pas.");
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
            return;
        }
        if (mdp.length() < 6) {
            req.setAttribute("erreur", "Le mot de passe doit contenir au moins 6 caractères.");
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
            return;
        }

        try {
            if (membreDAO.emailExiste(email)) {
                req.setAttribute("erreur", "Cet email est déjà utilisé.");
                req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
                return;
            }

            Membre m = new Membre();
            m.setNom(nom);
            m.setPrenom(prenom);
            m.setEmail(email);
            m.setMotDePasse(mdp);

            if (membreDAO.inscrire(m)) {
                logger.info("Nouveau membre inscrit et activé: {}", email);
                req.setAttribute("succesInscription", email);
                req.getRequestDispatcher("/WEB-INF/jsp/inscription-succes.jsp").forward(req, res);
            } else {
                req.setAttribute("erreur", "Erreur lors de l'inscription. Réessayez.");
                req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
            }
        } catch (Exception e) {
            logger.error("Erreur lors de l'inscription", e);
            req.setAttribute("erreur", "Erreur serveur. Veuillez réessayer.");
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, res);
        }
    }
}
