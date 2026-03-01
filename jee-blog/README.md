# TP JEE-Blog — Guide de Déploiement Complet

## 🏗️ Structure du Projet

```
jee-blog/
├── database/
│   └── blog_schema.sql          ← Script MySQL
├── src/main/
│   ├── java/com/blog/
│   │   ├── dao/                 ← Accès base de données
│   │   │   ├── MembreDAO.java
│   │   │   ├── ArticleDAO.java
│   │   │   └── CommentaireDAO.java
│   │   ├── filter/              ← Filtres Servlet
│   │   │   ├── AuthFilter.java  ← Authentification
│   │   │   └── LangueFilter.java ← Internationalisation
│   │   ├── model/               ← Beans Java
│   │   │   ├── Membre.java
│   │   │   ├── Article.java
│   │   │   └── Commentaire.java
│   │   ├── servlet/             ← Servlets
│   │   │   ├── ArticleServlet.java
│   │   │   ├── InscriptionServlet.java
│   │   │   ├── ConnexionServlet.java
│   │   │   ├── DeconnexionServlet.java
│   │   │   ├── ValidationCompteServlet.java
│   │   │   ├── CommentaireServlet.java
│   │   │   └── ProfilServlet.java
│   │   └── util/
│   │       ├── DatabaseConnection.java
│   │       └── EmailService.java
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   ├── i18n/
│       │   │   ├── messages_fr.properties  ← Traductions FR
│       │   │   └── messages_en.properties  ← Traductions EN
│       │   └── jsp/             ← Pages JSP avec JSTL
│       ├── css/style.css
│       └── js/main.js
└── pom.xml
```

## ⚙️ Prérequis

- **JDK 11+**
- **Apache Tomcat 9.x** (ou 10.x)
- **MySQL 8.x**
- **Maven 3.x** (ou Eclipse avec M2E)

---

## 🚀 Installation Étape par Étape

### 1. Base de données MySQL

```sql
-- Dans MySQL Workbench ou terminal :
mysql -u root -p < database/blog_schema.sql
```

### 2. Configuration DB

Modifiez `DatabaseConnection.java` si nécessaire :
```java
private static final String URL      = "jdbc:mysql://localhost:3306/jee_blog?...";
private static final String USER     = "root";
private static final String PASSWORD = "votre_mdp";
```

### 3. Configuration Email (pour validation inscription)

Modifiez `EmailService.java` :
```java
private static final String FROM_EMAIL    = "votre.email@gmail.com";
private static final String FROM_PASSWORD = "mot_de_passe_application_gmail";
```

> ⚠️ **Gmail** : Activez "Mots de passe d'application" dans les paramètres de sécurité Google.
> En mode développement, le lien de validation s'affiche directement dans la page (pas besoin d'email).

### 4. Build avec Maven

```bash
cd jee-blog
mvn clean package
```

### 5. Déploiement sur Tomcat

```bash
cp target/jee-blog.war $TOMCAT_HOME/webapps/
```

Ou via Eclipse : **Run As → Run on Server**

### 6. Accès

```
http://localhost:8080/jee-blog/
```

---

## 🌐 Fonctionnalités

| # | Fonctionnalité | Description |
|---|---------------|-------------|
| 1 | **Espace membres** | Inscription, connexion, déconnexion, session |
| 2 | **Gestion articles** | CRUD complet (créer, lire, modifier, supprimer) |
| 3 | **Gestion commentaires** | Ajouter, supprimer des commentaires par article |
| 4 | **Gestion profils** | Modifier infos personnelles, changer mot de passe |
| 5 | **Validation email** | Token UUID envoyé par email à l'inscription |
| 6 | **Internationalisation** | Français / Anglais via JSTL fmt + properties |
| 7 | **Sécurité** | BCrypt pour les mots de passe, AuthFilter |
| 8 | **Pagination** | Navigation par pages sur l'accueil |

---

## 🌍 Hébergeurs Gratuits Recommandés

| Hébergeur | Lien | Notes |
|-----------|------|-------|
| **Railway** | railway.app | Tomcat + MySQL, très simple |
| **Render** | render.com | Java/Maven natif |
| **Koyeb** | koyeb.com | Déploiement Docker |
| **InfinityFree** | infinityfree.net | PHP surtout, mais supporte Java via WAR |

> **Recommandé pour le TP :** Railway.app — déploiement direct depuis GitHub avec Tomcat.

---

## 🔧 Technologies Utilisées

- **JEE** : Servlets 4.0, JSP 2.3, JSTL 1.2
- **Base de données** : MySQL 8 + JDBC
- **Sécurité** : BCrypt (jBCrypt), UUID tokens
- **Email** : JavaMail API
- **Build** : Maven 3
- **Serveur** : Apache Tomcat 9
