package com.blog.model;

import java.sql.Timestamp;

public class Follow {
    private int id;
    private int followerId;
    private int followingId;
    private Timestamp dateFollow;

    public Follow() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFollowerId() {
        return followerId;
    }

    public void setFollowerId(int followerId) {
        this.followerId = followerId;
    }

    public int getFollowingId() {
        return followingId;
    }

    public void setFollowingId(int followingId) {
        this.followingId = followingId;
    }

    public Timestamp getDateFollow() {
        return dateFollow;
    }

    public void setDateFollow(Timestamp dateFollow) {
        this.dateFollow = dateFollow;
    }
}
