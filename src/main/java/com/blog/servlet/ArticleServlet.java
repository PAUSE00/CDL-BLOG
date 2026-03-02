package com.blog.servlet;

import com.blog.dao.ArticleDAO;
import com.blog.dao.CommentaireDAO;
import com.blog.dao.CollectionDAO;
import com.blog.dao.MembreDAO;
import com.blog.model.Article;
import com.blog.model.Commentaire;
import com.blog.model.Membre;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import com.blog.util.FileUploadUtil;

@WebServlet(urlPatterns = { "/articles", "/articles/voir", "/articles/nouveau",
        "/articles/modifier", "/articles/supprimer" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ArticleServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ArticleServlet.class);

    private ArticleDAO articleDAO = new ArticleDAO();
    private CommentaireDAO commentaireDAO = new CommentaireDAO();
    private CollectionDAO collectionDAO = new CollectionDAO();
    private MembreDAO membreDAO = new MembreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/articles/nouveau":
                req.getRequestDispatcher("/WEB-INF/jsp/article-form.jsp").forward(req, res);
                break;
            case "/articles/modifier":
                afficherFormModifier(req, res);
                break;
            case "/articles/voir":
                afficherArticle(req, res);
                break;
            default:
                listerArticles(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/articles/nouveau":
                creerArticle(req, res);
                break;
            case "/articles/modifier":
                modifierArticle(req, res);
                break;
            case "/articles/supprimer":
                supprimerArticle(req, res);
                break;
        }
    }

    private void listerArticles(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int page = 1;
            String p = req.getParameter("page");
            if (p != null) {
                try {
                    page = Integer.parseInt(p);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Support search query
            String query = req.getParameter("q");
            int parPage = 6;
            List<Article> articles;
            int total;

            if (query != null && !query.trim().isEmpty()) {
                query = query.trim();
                articles = articleDAO.rechercher(query, page, parPage);
                total = articleDAO.compterRecherche(query);
                req.setAttribute("searchQuery", query);
            } else {
                articles = articleDAO.listerTous(page, parPage);
                total = articleDAO.compterTous();
            }

            int totalPages = (int) Math.ceil((double) total / parPage);

            // Marquer les articles sauvegardés par le membre
            Membre membre = (Membre) req.getSession().getAttribute("membre");
            if (membre != null) {
                Set<Integer> savedIds = collectionDAO.getSavedArticleIds(membre.getId());
                for (Article a : articles) {
                    if (savedIds.contains(a.getId())) {
                        a.setEstSauvegarde(true);
                    }
                }

                // Suggestions de membres pour la sidebar
                List<Membre> suggestions = membreDAO.listerSuggestions(membre.getId(), 5);
                req.setAttribute("suggestionsMembre", suggestions);
            }

            req.setAttribute("articles", articles);
            req.setAttribute("pageCourante", page);
            req.setAttribute("totalPages", totalPages);
            req.getRequestDispatcher("/WEB-INF/jsp/accueil.jsp").forward(req, res);
        } catch (Exception e) {
            logger.error("Erreur lors du listage des articles", e);
            throw new ServletException(e);
        }
    }

    private void afficherArticle(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                res.sendError(400, "ID d'article requis");
                return;
            }

            int id = Integer.parseInt(idStr);
            Article article = articleDAO.trouverParId(id);
            if (article == null) {
                res.sendError(404);
                return;
            }

            // Increment views only for non-authors viewing the article
            Membre membre = (Membre) req.getSession().getAttribute("membre");
            if (membre == null || membre.getId() != article.getMembreId()) {
                articleDAO.incrementerVues(id);
                article.setVues(article.getVues() + 1); // Update local model
            }

            List<Commentaire> commentaires = commentaireDAO.listerParArticle(id);

            // Marquer si sauvegardé
            if (membre != null) {
                article.setEstSauvegarde(collectionDAO.estSauvegarde(id, membre.getId()));
            }

            req.setAttribute("article", article);
            req.setAttribute("commentaires", commentaires);
            req.getRequestDispatcher("/WEB-INF/jsp/article-detail.jsp").forward(req, res);
        } catch (NumberFormatException e) {
            res.sendError(400, "ID d'article invalide");
        } catch (Exception e) {
            logger.error("Erreur lors de l'affichage de l'article", e);
            throw new ServletException(e);
        }
    }

    private void afficherFormModifier(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Membre membre = (Membre) req.getSession().getAttribute("membre");
            Article article = articleDAO.trouverParId(id);
            if (article == null || article.getMembreId() != membre.getId()) {
                res.sendError(403);
                return;
            }
            req.setAttribute("article", article);
            req.getRequestDispatcher("/WEB-INF/jsp/article-form.jsp").forward(req, res);
        } catch (Exception e) {
            logger.error("Erreur lors de l'affichage du formulaire de modification", e);
            throw new ServletException(e);
        }
    }

    private void creerArticle(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Membre membre = (Membre) req.getSession().getAttribute("membre");

            String titre = getParameterOrPart(req, "titre");
            String contenu = getParameterOrPart(req, "contenu");
            String module = getParameterOrPart(req, "module");

            if (titre == null || titre.trim().isEmpty() || contenu == null || contenu.trim().isEmpty()) {
                req.setAttribute("erreur", "Titre et contenu obligatoires.");
                req.getRequestDispatcher("/WEB-INF/jsp/article-form.jsp").forward(req, res);
                return;
            }

            Article a = new Article();
            a.setTitre(titre.trim());
            a.setContenu(contenu.trim());
            a.setMembreId(membre.getId());
            a.setModule(module != null && !module.trim().isEmpty() ? module.trim() : "Général");

            // Handle optional image upload
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    String imageUrl = FileUploadUtil.saveUploadedFile(imagePart, req.getContextPath());
                    a.setImage(imageUrl);
                } catch (SecurityException e) {
                    req.setAttribute("erreur", e.getMessage());
                    req.getRequestDispatcher("/WEB-INF/jsp/article-form.jsp").forward(req, res);
                    return;
                }
            }

            articleDAO.creer(a);
            logger.info("Article créé: {} par membre {}", a.getId(), membre.getId());
            res.sendRedirect(req.getContextPath() + "/articles/voir?id=" + a.getId());
        } catch (Exception e) {
            logger.error("Erreur lors de la création de l'article", e);
            throw new ServletException(e);
        }
    }

    private void modifierArticle(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Membre membre = (Membre) req.getSession().getAttribute("membre");
            int id = Integer.parseInt(getParameterOrPart(req, "id"));
            Article a = articleDAO.trouverParId(id);

            if (a == null || a.getMembreId() != membre.getId()) {
                res.sendError(403);
                return;
            }

            a.setTitre(getParameterOrPart(req, "titre").trim());
            a.setContenu(getParameterOrPart(req, "contenu").trim());

            String module = getParameterOrPart(req, "module");
            a.setModule(module != null && !module.trim().isEmpty() ? module.trim() : "Général");

            // Handle optional image update
            Part imagePart = req.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    String imageUrl = FileUploadUtil.saveUploadedFile(imagePart, req.getContextPath());
                    a.setImage(imageUrl);
                } catch (SecurityException e) {
                    req.setAttribute("erreur", e.getMessage());
                    req.setAttribute("article", a);
                    req.getRequestDispatcher("/WEB-INF/jsp/article-form.jsp").forward(req, res);
                    return;
                }
            }

            a.setMembreId(membre.getId());
            articleDAO.modifier(a);
            logger.info("Article modifié: {} par membre {}", id, membre.getId());
            res.sendRedirect(req.getContextPath() + "/articles/voir?id=" + id);
        } catch (Exception e) {
            logger.error("Erreur lors de la modification de l'article", e);
            throw new ServletException(e);
        }
    }

    // Helper method to handle multipart form fields manually if needed
    private String getParameterOrPart(HttpServletRequest req, String name) throws ServletException, IOException {
        String value = req.getParameter(name);
        if (value == null && req.getContentType() != null
                && req.getContentType().toLowerCase().startsWith("multipart/")) {
            Part part = req.getPart(name);
            if (part != null) {
                try (java.util.Scanner scanner = new java.util.Scanner(part.getInputStream(), "UTF-8")
                        .useDelimiter("\\A")) {
                    value = scanner.hasNext() ? scanner.next() : "";
                }
            }
        }
        return value;
    }

    private void supprimerArticle(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            Membre membre = (Membre) req.getSession().getAttribute("membre");
            String idStr = req.getParameter("id");
            if (idStr == null) {
                res.sendError(400);
                return;
            }
            int id = Integer.parseInt(idStr);
            articleDAO.supprimer(id, membre.getId());
            logger.info("Article supprimé: {} par membre {}", id, membre.getId());
            res.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            logger.error("Erreur lors de la suppression de l'article", e);
            throw new ServletException(e);
        }
    }
}
