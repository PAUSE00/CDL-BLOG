package com.blog.model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int membreId;
    private String type; // 'like', 'comment', 'follow'
    private int sourceMembreId;
    private Integer articleId; // Peut être null pour un follow
    private boolean lu;
    private Timestamp dateCreation;

    // Relations
    private Membre sourceMembre;
    private Article article;

    public Notification() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMembreId() {
        return membreId;
    }

    public void setMembreId(int membreId) {
        this.membreId = membreId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getSourceMembreId() {
        return sourceMembreId;
    }

    public void setSourceMembreId(int sourceMembreId) {
        this.sourceMembreId = sourceMembreId;
    }

    public Integer getArticleId() {
        return articleId;
    }

    public void setArticleId(Integer articleId) {
        this.articleId = articleId;
    }

    public boolean isLu() {
        return lu;
    }

    public void setLu(boolean lu) {
        this.lu = lu;
    }

    public Timestamp getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Timestamp dateCreation) {
        this.dateCreation = dateCreation;
    }

    public Membre getSourceMembre() {
        return sourceMembre;
    }

    public void setSourceMembre(Membre sourceMembre) {
        this.sourceMembre = sourceMembre;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }
}
