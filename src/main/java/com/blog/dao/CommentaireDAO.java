package com.blog.dao;

import com.blog.model.Commentaire;
import com.blog.model.Membre;
import com.blog.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentaireDAO {

    /** Ajouter un commentaire */
    public boolean ajouter(Commentaire c) throws SQLException {
        String sql = "INSERT INTO commentaires (contenu, article_id, membre_id) VALUES (?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getContenu());
            ps.setInt(2, c.getArticleId());
            ps.setInt(3, c.getMembreId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Lister les commentaires d'un article */
    public List<Commentaire> listerParArticle(int articleId) throws SQLException {
        String sql = "SELECT c.*, m.nom, m.prenom, m.avatar FROM commentaires c "
                + "JOIN membres m ON c.membre_id = m.id "
                + "WHERE c.article_id = ? ORDER BY c.date_commentaire ASC";
        List<Commentaire> liste = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Commentaire c = new Commentaire();
                    c.setId(rs.getInt("id"));
                    c.setContenu(rs.getString("contenu"));
                    c.setDateCommentaire(rs.getTimestamp("date_commentaire"));
                    c.setArticleId(rs.getInt("article_id"));
                    c.setMembreId(rs.getInt("membre_id"));
                    Membre auteur = new Membre();
                    auteur.setId(rs.getInt("membre_id"));
                    auteur.setNom(rs.getString("nom"));
                    auteur.setPrenom(rs.getString("prenom"));
                    auteur.setAvatar(rs.getString("avatar"));
                    c.setAuteur(auteur);
                    liste.add(c);
                }
            }
        }
        return liste;
    }

    /** Supprimer un commentaire */
    public boolean supprimer(int id, int membreId) throws SQLException {
        String sql = "DELETE FROM commentaires WHERE id=? AND membre_id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, membreId);
            return ps.executeUpdate() > 0;
        }
    }
}
