package com.blog.model;

import java.sql.Timestamp;

public class Message {
    private int id;
    private int expediteurId;
    private int destinataireId;
    private String contenu;
    private boolean lu;
    private Timestamp dateEnvoi;

    // Relations (Jointures)
    private Membre expediteur;
    private Membre destinataire;

    public Message() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getExpediteurId() {
        return expediteurId;
    }

    public void setExpediteurId(int expediteurId) {
        this.expediteurId = expediteurId;
    }

    public int getDestinataireId() {
        return destinataireId;
    }

    public void setDestinataireId(int destinataireId) {
        this.destinataireId = destinataireId;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public boolean isLu() {
        return lu;
    }

    public void setLu(boolean lu) {
        this.lu = lu;
    }

    public Timestamp getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(Timestamp dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    public Membre getExpediteur() {
        return expediteur;
    }

    public void setExpediteur(Membre expediteur) {
        this.expediteur = expediteur;
    }

    public Membre getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(Membre destinataire) {
        this.destinataire = destinataire;
    }
}
