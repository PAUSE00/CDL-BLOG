package com.blog.dao;

import com.blog.model.Membre;
import com.blog.model.Message;
import com.blog.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean envoyer(Message m) throws SQLException {
        String sql = "INSERT INTO messages (expediteur_id, destinataire_id, contenu) VALUES (?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getExpediteurId());
            ps.setInt(2, m.getDestinataireId());
            ps.setString(3, m.getContenu());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Message> getConversation(int userId1, int userId2) throws SQLException {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.*, exp.prenom as exp_prenom, exp.nom as exp_nom, exp.avatar as exp_avatar, " +
                "dest.prenom as dest_prenom, dest.nom as dest_nom, dest.avatar as dest_avatar " +
                "FROM messages m " +
                "JOIN membres exp ON m.expediteur_id = exp.id " +
                "JOIN membres dest ON m.destinataire_id = dest.id " +
                "WHERE (m.expediteur_id = ? AND m.destinataire_id = ?) OR (m.expediteur_id = ? AND m.destinataire_id = ?) "
                +
                "ORDER BY m.date_envoi ASC";

        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId1);
            ps.setInt(2, userId2);
            ps.setInt(3, userId2);
            ps.setInt(4, userId1);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapperMessage(rs));
                }
            }
        }
        return messages;
    }

    public List<Membre> getConversations(int userId) throws SQLException {
        // Renvoie la liste des utilisateurs avec qui ce user a une conversation
        List<Membre> users = new ArrayList<>();
        String sql = "SELECT DISTINCT users.id, users.nom, users.prenom, users.avatar " +
                "FROM membres users " +
                "JOIN messages m ON (users.id = m.expediteur_id OR users.id = m.destinataire_id) " +
                "WHERE (m.expediteur_id = ? OR m.destinataire_id = ?) AND users.id != ?";

        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Membre m = new Membre();
                    m.setId(rs.getInt("id"));
                    m.setNom(rs.getString("nom"));
                    m.setPrenom(rs.getString("prenom"));
                    m.setAvatar(rs.getString("avatar"));
                    users.add(m);
                }
            }
        }
        return users;
    }

    public int getNombreNonLus(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM messages WHERE destinataire_id = ? AND lu = false";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean marquerCommeVu(int conversationPartnerId, int userId) throws SQLException {
        String sql = "UPDATE messages SET lu = true WHERE expediteur_id = ? AND destinataire_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, conversationPartnerId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    private Message mapperMessage(ResultSet rs) throws SQLException {
        Message msg = new Message();
        msg.setId(rs.getInt("id"));
        msg.setExpediteurId(rs.getInt("expediteur_id"));
        msg.setDestinataireId(rs.getInt("destinataire_id"));
        msg.setContenu(rs.getString("contenu"));
        msg.setLu(rs.getBoolean("lu"));
        msg.setDateEnvoi(rs.getTimestamp("date_envoi"));

        Membre exp = new Membre();
        exp.setId(rs.getInt("expediteur_id"));
        exp.setPrenom(rs.getString("exp_prenom"));
        exp.setNom(rs.getString("exp_nom"));
        exp.setAvatar(rs.getString("exp_avatar"));
        msg.setExpediteur(exp);

        Membre dest = new Membre();
        dest.setId(rs.getInt("destinataire_id"));
        dest.setPrenom(rs.getString("dest_prenom"));
        dest.setNom(rs.getString("dest_nom"));
        dest.setAvatar(rs.getString("dest_avatar"));
        msg.setDestinataire(dest);

        return msg;
    }
}
