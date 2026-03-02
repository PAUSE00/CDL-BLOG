package com.blog.model;

import java.sql.Timestamp;

public class LikeArticle {
    private int id;
    private int articleId;
    private int membreId;
    private Timestamp dateLike;

    public LikeArticle() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getArticleId() {
        return articleId;
    }

    public void setArticleId(int articleId) {
        this.articleId = articleId;
    }

    public int getMembreId() {
        return membreId;
    }

    public void setMembreId(int membreId) {
        this.membreId = membreId;
    }

    public Timestamp getDateLike() {
        return dateLike;
    }

    public void setDateLike(Timestamp dateLike) {
        this.dateLike = dateLike;
    }
}
