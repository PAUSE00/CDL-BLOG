package com.blog.dao;

import com.blog.model.Article;
import com.blog.model.Membre;
import com.blog.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {

    private static final Logger logger = LoggerFactory.getLogger(ArticleDAO.class);

    /** Créer un article */
    public boolean creer(Article a) throws SQLException {
        String sql = "INSERT INTO articles (titre, contenu, image, membre_id, module) VALUES (?,?,?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, a.getTitre());
            ps.setString(2, a.getContenu());
            ps.setString(3, a.getImage());
            ps.setInt(4, a.getMembreId());
            ps.setString(5, a.getModule() != null ? a.getModule() : "Général");
            if (ps.executeUpdate() > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next())
                    a.setId(keys.getInt(1));
                return true;
            }
        }
        return false;
    }

    /** Lister tous les articles avec auteur (pagination) */
    public List<Article> listerTous(int page, int parPage) throws SQLException {
        int offset = (page - 1) * parPage;
        String sql = "SELECT a.*, m.nom, m.prenom, m.avatar, "
                + "(SELECT COUNT(*) FROM likes_article l WHERE l.article_id = a.id) as likes_count, "
                + "(SELECT COUNT(*) FROM commentaires c WHERE c.article_id = a.id) as commentaires_count "
                + "FROM articles a "
                + "JOIN membres m ON a.membre_id = m.id "
                + "ORDER BY a.date_publication DESC LIMIT ? OFFSET ?";
        List<Article> liste = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, parPage);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    liste.add(mapperArticle(rs));
            }
        }
        return liste;
    }

    /** Compter le total des articles */
    public int compterTous() throws SQLException {
        String sql = "SELECT COUNT(*) FROM articles";
        try (Connection con = DatabaseConnection.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Trouver un article par ID (sans incrémenter les vues) */
    public Article trouverParId(int id) throws SQLException {
        String sql = "SELECT a.*, m.nom, m.prenom, m.avatar, "
                + "(SELECT COUNT(*) FROM likes_article l WHERE l.article_id = a.id) as likes_count, "
                + "(SELECT COUNT(*) FROM commentaires c WHERE c.article_id = a.id) as commentaires_count "
                + "FROM articles a "
                + "JOIN membres m ON a.membre_id = m.id WHERE a.id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapperArticle(rs);
            }
        }
        return null;
    }

    /**
     * Incrémenter les vues d'un article. Appelé séparément par le servlet
     * pour éviter de gonfler les vues lors de la modification ou de la consultation
     * par l'auteur.
     */
    public void incrementerVues(int articleId) throws SQLException {
        String sql = "UPDATE articles SET vues = vues + 1 WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ps.executeUpdate();
        }
    }

    /** Articles d'un membre */
    public List<Article> listerParMembre(int membreId) throws SQLException {
        String sql = "SELECT a.*, m.nom, m.prenom, m.avatar, "
                + "(SELECT COUNT(*) FROM likes_article l WHERE l.article_id = a.id) as likes_count, "
                + "(SELECT COUNT(*) FROM commentaires c WHERE c.article_id = a.id) as commentaires_count "
                + "FROM articles a "
                + "JOIN membres m ON a.membre_id = m.id "
                + "WHERE a.membre_id = ? ORDER BY a.date_publication DESC";
        List<Article> liste = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    liste.add(mapperArticle(rs));
            }
        }
        return liste;
    }

    /** Rechercher des articles par titre ou contenu */
    public List<Article> rechercher(String query, int page, int parPage) throws SQLException {
        int offset = (page - 1) * parPage;
        String sql = "SELECT a.*, m.nom, m.prenom, m.avatar, "
                + "(SELECT COUNT(*) FROM likes_article l WHERE l.article_id = a.id) as likes_count, "
                + "(SELECT COUNT(*) FROM commentaires c WHERE c.article_id = a.id) as commentaires_count "
                + "FROM articles a "
                + "JOIN membres m ON a.membre_id = m.id "
                + "WHERE a.titre LIKE ? OR a.contenu LIKE ? OR a.module LIKE ? "
                + "ORDER BY a.date_publication DESC LIMIT ? OFFSET ?";
        List<Article> liste = new ArrayList<>();
        String searchTerm = "%" + query + "%";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ps.setInt(4, parPage);
            ps.setInt(5, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    liste.add(mapperArticle(rs));
            }
        }
        return liste;
    }

    /** Compter les résultats de recherche */
    public int compterRecherche(String query) throws SQLException {
        String sql = "SELECT COUNT(*) FROM articles WHERE titre LIKE ? OR contenu LIKE ? OR module LIKE ?";
        String searchTerm = "%" + query + "%";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Modifier un article */
    public boolean modifier(Article a) throws SQLException {
        String sql = "UPDATE articles SET titre=?, contenu=?, image=?, module=? WHERE id=? AND membre_id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, a.getTitre());
            ps.setString(2, a.getContenu());
            ps.setString(3, a.getImage());
            ps.setString(4, a.getModule() != null ? a.getModule() : "Général");
            ps.setInt(5, a.getId());
            ps.setInt(6, a.getMembreId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Supprimer un article */
    public boolean supprimer(int id, int membreId) throws SQLException {
        String sql = "DELETE FROM articles WHERE id=? AND membre_id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, membreId);
            return ps.executeUpdate() > 0;
        }
    }

    private Article mapperArticle(ResultSet rs) throws SQLException {
        Article a = new Article();
        a.setId(rs.getInt("id"));
        a.setTitre(rs.getString("titre"));
        a.setContenu(rs.getString("contenu"));
        a.setImage(rs.getString("image"));
        a.setDatePublication(rs.getTimestamp("date_publication"));
        a.setMembreId(rs.getInt("membre_id"));
        a.setVues(rs.getInt("vues"));
        a.setModule(rs.getString("module"));
        a.setLikes(rs.getInt("likes_count"));
        a.setCommentairesCount(rs.getInt("commentaires_count"));

        Membre auteur = new Membre();
        auteur.setId(rs.getInt("membre_id"));
        auteur.setNom(rs.getString("nom"));
        auteur.setPrenom(rs.getString("prenom"));
        auteur.setAvatar(rs.getString("avatar"));
        a.setAuteur(auteur);
        return a;
    }
}
