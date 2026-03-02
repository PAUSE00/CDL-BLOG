package com.blog.dao;

import com.blog.model.Membre;
import com.blog.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.UUID;

public class MembreDAO {

    /** Inscrire un nouveau membre (non validé) */
    public boolean inscrire(Membre m) throws SQLException {
        String sql = "INSERT INTO membres (nom, prenom, email, mot_de_passe, token_validation, valide) VALUES (?,?,?,?,?,false)";
        String token = UUID.randomUUID().toString();
        String hashMdp = BCrypt.hashpw(m.getMotDePasse(), BCrypt.gensalt());

        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getNom());
            ps.setString(2, m.getPrenom());
            ps.setString(3, m.getEmail());
            ps.setString(4, hashMdp);
            ps.setString(5, token);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                m.setTokenValidation(token);
                return true;
            }
        }
        return false;
    }

    /** Valider le compte via token email */
    public boolean validerCompte(String token) throws SQLException {
        String sql = "UPDATE membres SET valide = true, token_validation = NULL WHERE token_validation = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        }
    }

    /** Authentification */
    public Membre authentifier(String email, String motDePasse) throws SQLException {
        String sql = "SELECT * FROM membres WHERE email = ? AND valide = true";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashStocke = rs.getString("mot_de_passe");
                    if (BCrypt.checkpw(motDePasse, hashStocke)) {
                        return mapperMembre(rs);
                    }
                }
            }
        }
        return null;
    }

    /** Trouver un membre par ID */
    public Membre trouverParId(int id) throws SQLException {
        String sql = "SELECT * FROM membres WHERE id = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapperMembre(rs);
            }
        }
        return null;
    }

    /** Vérifier si email existe déjà */
    public boolean emailExiste(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM membres WHERE email = ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /** Mettre à jour le profil */
    public boolean mettreAJourProfil(Membre m) throws SQLException {
        String sql = "UPDATE membres SET nom=?, prenom=?, bio=?, avatar=? WHERE id=?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, m.getNom());
            ps.setString(2, m.getPrenom());
            ps.setString(3, m.getBio());
            ps.setString(4, m.getAvatar());
            ps.setInt(5, m.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /** Changer le mot de passe */
    public boolean changerMotDePasse(int id, String nouveauMdp) throws SQLException {
        String sql = "UPDATE membres SET mot_de_passe = ? WHERE id = ?";
        String hash = BCrypt.hashpw(nouveauMdp, BCrypt.gensalt());
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hash);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    /** Lister tous les membres */
    public java.util.List<Membre> listerTous() throws SQLException {
        java.util.List<Membre> membres = new java.util.ArrayList<>();
        String sql = "SELECT * FROM membres WHERE valide = true";
        try (Connection con = DatabaseConnection.getConnection();
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                membres.add(mapperMembre(rs));
            }
        }
        return membres;
    }

    /** Rechercher un membre par son nom/prénom */
    public java.util.List<Membre> rechercherParNom(String query) throws SQLException {
        java.util.List<Membre> membres = new java.util.ArrayList<>();
        String sql = "SELECT * FROM membres WHERE valide = true AND (nom LIKE ? OR prenom LIKE ?)";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    membres.add(mapperMembre(rs));
                }
            }
        }
        return membres;
    }

    /** Lister des suggestions de membres (non suivis par membreId) */
    public java.util.List<Membre> listerSuggestions(int membreId, int limite) throws SQLException {
        java.util.List<Membre> membres = new java.util.ArrayList<>();
        String sql = "SELECT * FROM membres WHERE id != ? AND valide = true " +
                "AND id NOT IN (SELECT following_id FROM follows WHERE follower_id = ?) " +
                "ORDER BY RAND() LIMIT ?";
        try (Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            ps.setInt(2, membreId);
            ps.setInt(3, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    membres.add(mapperMembre(rs));
                }
            }
        }
        return membres;
    }

    private Membre mapperMembre(ResultSet rs) throws SQLException {
        Membre m = new Membre();
        m.setId(rs.getInt("id"));
        m.setNom(rs.getString("nom"));
        m.setPrenom(rs.getString("prenom"));
        m.setEmail(rs.getString("email"));
        m.setMotDePasse(rs.getString("mot_de_passe"));
        m.setValide(rs.getBoolean("valide"));
        m.setDateInscription(rs.getTimestamp("date_inscription"));
        m.setAvatar(rs.getString("avatar"));
        m.setBio(rs.getString("bio"));
        return m;
    }
}
