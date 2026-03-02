package com.blog.model;

import java.sql.Timestamp;

public class Commentaire {
    private int id;
    private String contenu;
    private Timestamp dateCommentaire;
    private int articleId;
    private int membreId;
    private Membre auteur; // jointure

    public Commentaire() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public Timestamp getDateCommentaire() { return dateCommentaire; }
    public void setDateCommentaire(Timestamp dateCommentaire) { this.dateCommentaire = dateCommentaire; }

    public int getArticleId() { return articleId; }
    public void setArticleId(int articleId) { this.articleId = articleId; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public Membre getAuteur() { return auteur; }
    public void setAuteur(Membre auteur) { this.auteur = auteur; }
}
