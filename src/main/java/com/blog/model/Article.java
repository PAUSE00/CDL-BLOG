package com.blog.model;

import java.sql.Timestamp;

public class Article {
    private int id;
    private String titre;
    private String contenu;
    private String image;
    private Timestamp datePublication;
    private Timestamp dateModification;
    private int membreId;
    private int vues;
    private int likes; // Count of likes
    private int commentairesCount; // Count of comments
    private String module; // Ajout pour gérer les catégories/modules
    private Membre auteur; // jointure
    private boolean estSauvegarde; // Affiche si sauvegardé par le membre courant

    public Article() {
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Timestamp getDatePublication() {
        return datePublication;
    }

    public void setDatePublication(Timestamp datePublication) {
        this.datePublication = datePublication;
    }

    public Timestamp getDateModification() {
        return dateModification;
    }

    public void setDateModification(Timestamp dateModification) {
        this.dateModification = dateModification;
    }

    public int getMembreId() {
        return membreId;
    }

    public void setMembreId(int membreId) {
        this.membreId = membreId;
    }

    public int getVues() {
        return vues;
    }

    public void setVues(int vues) {
        this.vues = vues;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public int getCommentairesCount() {
        return commentairesCount;
    }

    public void setCommentairesCount(int commentairesCount) {
        this.commentairesCount = commentairesCount;
    }

    public Membre getAuteur() {
        return auteur;
    }

    public void setAuteur(Membre auteur) {
        this.auteur = auteur;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    /** Retourne un extrait du contenu (150 caractères) */
    public String getExtrait() {
        if (contenu == null)
            return "";
        return contenu.length() > 150 ? contenu.substring(0, 150) + "..." : contenu;
    }

    public boolean isEstSauvegarde() {
        return estSauvegarde;
    }

    public void setEstSauvegarde(boolean estSauvegarde) {
        this.estSauvegarde = estSauvegarde;
    }
}
