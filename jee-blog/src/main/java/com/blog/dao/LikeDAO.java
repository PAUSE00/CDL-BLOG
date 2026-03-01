package com.blog.dao;

import com.blog.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class LikeDAO {

    private static final Logger logger = LoggerFactory.getLogger(LikeDAO.class);

    public boolean aDejaLike(int articleId, int membreId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM likes_article WHERE article_id = ? AND membre_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ps.setInt(2, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Toggle like on an article. Uses a single connection to avoid race conditions.
     * Returns true if like was added, false if removed.
     */
    public boolean toggleLike(int articleId, int membreId) throws SQLException {
        try (Connection con = DatabaseConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Check if already liked
                boolean alreadyLiked;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT COUNT(*) FROM likes_article WHERE article_id = ? AND membre_id = ?")) {
                    ps.setInt(1, articleId);
                    ps.setInt(2, membreId);
                    try (ResultSet rs = ps.executeQuery()) {
                        alreadyLiked = rs.next() && rs.getInt(1) > 0;
                    }
                }

                if (alreadyLiked) {
                    // Remove Like
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM likes_article WHERE article_id = ? AND membre_id = ?")) {
                        ps.setInt(1, articleId);
                        ps.setInt(2, membreId);
                        ps.executeUpdate();
                    }
                    con.commit();
                    return false; // Not liked anymore
                } else {
                    // Add Like
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO likes_article (article_id, membre_id) VALUES (?, ?)")) {
                        ps.setInt(1, articleId);
                        ps.setInt(2, membreId);
                        ps.executeUpdate();
                    }
                    con.commit();
                    return true; // Liked
                }
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public int getNombreLikes(int articleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM likes_article WHERE article_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }
}
