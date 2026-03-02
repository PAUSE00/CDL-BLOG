package com.blog.dao;

import com.blog.model.Article;
import com.blog.model.Membre;
import com.blog.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class CollectionDAO {

    private static final Logger logger = LoggerFactory.getLogger(CollectionDAO.class);

    /** Ajouter un article a la collection */
    public boolean sauvegarder(int articleId, int membreId) throws SQLException {
        String sql = "INSERT IGNORE INTO collections (article_id, membre_id) VALUES (?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ps.setInt(2, membreId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Retirer un article de la collection */
    public boolean retirer(int articleId, int membreId) throws SQLException {
        String sql = "DELETE FROM collections WHERE article_id=? AND membre_id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ps.setInt(2, membreId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Verifier si l'article est sauvegarde par le membre */
    public boolean estSauvegarde(int articleId, int membreId) throws SQLException {
        String sql = "SELECT 1 FROM collections WHERE article_id=? AND membre_id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ps.setInt(2, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Recuperer les IDs des articles sauvegardes par un membre */
    public Set<Integer> getSavedArticleIds(int membreId) throws SQLException {
        String sql = "SELECT article_id FROM collections WHERE membre_id = ?";
        Set<Integer> ids = new HashSet<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("article_id"));
                }
            }
        }
        return ids;
    }

    /** Lister les articles sauvegardes d'un membre */
    public List<Article> listerParMembre(int membreId) throws SQLException {
        String sql = "SELECT a.*, m.nom, m.prenom, m.avatar, "
                + "(SELECT COUNT(*) FROM likes_article l WHERE l.article_id = a.id) as likes_count, "
                + "(SELECT COUNT(*) FROM commentaires c WHERE c.article_id = a.id) as commentaires_count "
                + "FROM articles a "
                + "JOIN membres m ON a.membre_id = m.id "
                + "JOIN collections cl ON a.id = cl.article_id "
                + "WHERE cl.membre_id = ? ORDER BY cl.date_sauvegarde DESC";
        List<Article> liste = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    liste.add(mapperArticle(rs));
                }
            }
        }
        return liste;
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
        a.setEstSauvegarde(true); // It's in the collection, so it's saved
        return a;
    }
}
