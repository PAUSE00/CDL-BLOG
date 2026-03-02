package com.blog.dao;

import com.blog.model.Membre;
import com.blog.util.DatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowDAO {

    private static final Logger logger = LoggerFactory.getLogger(FollowDAO.class);

    public boolean isFollowing(int followerId, int followingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM follows WHERE follower_id = ? AND following_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Toggle follow. Uses a single connection with transaction to avoid race
     * conditions.
     * Returns true if follow was added, false if removed.
     */
    public boolean toggleFollow(int followerId, int followingId) throws SQLException {
        try (Connection con = DatabaseConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                boolean alreadyFollowing;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT COUNT(*) FROM follows WHERE follower_id = ? AND following_id = ?")) {
                    ps.setInt(1, followerId);
                    ps.setInt(2, followingId);
                    try (ResultSet rs = ps.executeQuery()) {
                        alreadyFollowing = rs.next() && rs.getInt(1) > 0;
                    }
                }

                if (alreadyFollowing) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM follows WHERE follower_id = ? AND following_id = ?")) {
                        ps.setInt(1, followerId);
                        ps.setInt(2, followingId);
                        ps.executeUpdate();
                    }
                    con.commit();
                    return false;
                } else {
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO follows (follower_id, following_id) VALUES (?, ?)")) {
                        ps.setInt(1, followerId);
                        ps.setInt(2, followingId);
                        ps.executeUpdate();
                    }
                    con.commit();
                    return true;
                }
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public int countFollowers(int membreId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM follows WHERE following_id = ?";
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

    public int countFollowing(int membreId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM follows WHERE follower_id = ?";
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

    public List<Membre> getFollowers(int membreId) throws SQLException {
        return getList(
                "SELECT m.* FROM membres m JOIN follows f ON m.id = f.follower_id WHERE f.following_id = ? ORDER BY f.date_follow DESC",
                membreId);
    }

    public List<Membre> getFollowing(int membreId) throws SQLException {
        return getList(
                "SELECT m.* FROM membres m JOIN follows f ON m.id = f.following_id WHERE f.follower_id = ? ORDER BY f.date_follow DESC",
                membreId);
    }

    private List<Membre> getList(String sql, int membreId) throws SQLException {
        List<Membre> list = new ArrayList<>();
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Membre m = new Membre();
                    m.setId(rs.getInt("id"));
                    m.setNom(rs.getString("nom"));
                    m.setPrenom(rs.getString("prenom"));
                    m.setAvatar(rs.getString("avatar"));
                    list.add(m);
                }
            }
        }
        return list;
    }
}
