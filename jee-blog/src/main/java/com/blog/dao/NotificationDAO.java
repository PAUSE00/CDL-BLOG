package com.blog.dao;

import com.blog.model.Article;
import com.blog.model.Membre;
import com.blog.model.Notification;
import com.blog.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public boolean creer(Notification n) throws SQLException {
        String sql;
        if (n.getArticleId() != null) {
            sql = "INSERT INTO notifications (membre_id, type, source_membre_id, article_id) VALUES (?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO notifications (membre_id, type, source_membre_id) VALUES (?, ?, ?)";
        }

        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, n.getMembreId());
            ps.setString(2, n.getType());
            ps.setInt(3, n.getSourceMembreId());
            if (n.getArticleId() != null) {
                ps.setInt(4, n.getArticleId());
            }
            return ps.executeUpdate() > 0;
        }
    }

    public List<Notification> getParMembre(int membreId) throws SQLException {
        List<Notification> notifs = new ArrayList<>();
        String sql = "SELECT n.*, source.prenom as source_prenom, source.nom as source_nom, source.avatar as source_avatar, "
                +
                "a.titre as article_titre " +
                "FROM notifications n " +
                "JOIN membres source ON n.source_membre_id = source.id " +
                "LEFT JOIN articles a ON n.article_id = a.id " +
                "WHERE n.membre_id = ? " +
                "ORDER BY n.date_creation DESC";

        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifs.add(mapperNotification(rs));
                }
            }
        }
        return notifs;
    }

    public int getNombreNonLues(int membreId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE membre_id = ? AND lu = false";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean marquerToutesLues(int membreId) throws SQLException {
        String sql = "UPDATE notifications SET lu = true WHERE membre_id = ? AND lu = false";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            return ps.executeUpdate() > 0;
        }
    }

    private Notification mapperNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setMembreId(rs.getInt("membre_id"));
        n.setType(rs.getString("type"));
        n.setSourceMembreId(rs.getInt("source_membre_id"));

        int articleId = rs.getInt("article_id");
        if (!rs.wasNull()) {
            n.setArticleId(articleId);
            Article a = new Article();
            a.setId(articleId);
            a.setTitre(rs.getString("article_titre"));
            n.setArticle(a);
        }

        n.setLu(rs.getBoolean("lu"));
        n.setDateCreation(rs.getTimestamp("date_creation"));

        Membre source = new Membre();
        source.setId(rs.getInt("source_membre_id"));
        source.setPrenom(rs.getString("source_prenom"));
        source.setNom(rs.getString("source_nom"));
        source.setAvatar(rs.getString("source_avatar"));
        n.setSourceMembre(source);

        return n;
    }
}
