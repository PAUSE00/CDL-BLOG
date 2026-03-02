-- ============================================
-- JEE Blog - Database Schema (MySQL)
-- Version consolidée - BCrypt compatible
-- ============================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- CREATE DATABASE IF NOT EXISTS jee_blog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE railway;

-- ============================================
-- Table des membres
-- ============================================
CREATE TABLE IF NOT EXISTS membres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    token_validation VARCHAR(255) DEFAULT NULL,
    valide BOOLEAN DEFAULT FALSE,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    avatar VARCHAR(500) DEFAULT NULL,
    bio TEXT DEFAULT NULL,
    INDEX idx_email (email),
    INDEX idx_valide (valide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des articles
-- ============================================
CREATE TABLE IF NOT EXISTS articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    contenu TEXT NOT NULL,
    image VARCHAR(500) DEFAULT NULL,
    date_publication TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    membre_id INT NOT NULL,
    vues INT DEFAULT 0,
    module VARCHAR(100) DEFAULT 'Général',
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_membre_id (membre_id),
    INDEX idx_date_publication (date_publication),
    INDEX idx_module (module)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des commentaires
-- ============================================
CREATE TABLE IF NOT EXISTS commentaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT NOT NULL,
    date_commentaire TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    article_id INT NOT NULL,
    membre_id INT NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_article_id (article_id),
    INDEX idx_commentaire_membre (membre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des messages privés
-- ============================================
CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    expediteur_id INT NOT NULL,
    destinataire_id INT NOT NULL,
    contenu TEXT NOT NULL,
    lu BOOLEAN DEFAULT FALSE,
    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expediteur_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (destinataire_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_expediteur (expediteur_id),
    INDEX idx_destinataire (destinataire_id),
    INDEX idx_date_envoi (date_envoi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des notifications
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    membre_id INT NOT NULL,
    type VARCHAR(50) NOT NULL COMMENT 'like, comment, follow',
    source_membre_id INT NOT NULL,
    article_id INT DEFAULT NULL,
    lu BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (source_membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE SET NULL,
    INDEX idx_notif_membre (membre_id),
    INDEX idx_notif_lu (lu),
    INDEX idx_notif_source (source_membre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des likes
-- ============================================
CREATE TABLE IF NOT EXISTS likes_article (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    membre_id INT NOT NULL,
    date_like TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_like (article_id, membre_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_like_article (article_id),
    INDEX idx_like_membre (membre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des follows (abonnements)
-- ============================================
CREATE TABLE IF NOT EXISTS follows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    date_follow TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_follow (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_follower (follower_id),
    INDEX idx_following (following_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table des collections (articles sauvegardés)
-- ============================================
CREATE TABLE IF NOT EXISTS collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    membre_id INT NOT NULL,
    date_sauvegarde TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_collection (article_id, membre_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    INDEX idx_collection_article (article_id),
    INDEX idx_collection_membre (membre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Données de test (utilisant BCrypt)
-- ============================================
-- Le hash ci-dessous correspond au mot de passe "admin123" en BCrypt
INSERT IGNORE INTO membres (nom, prenom, email, mot_de_passe, valide)
VALUES ('Admin', 'Blog', 'admin@blog.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true);
-- Note: Pour régénérer le hash, utilisez BCrypt.hashpw("admin123", BCrypt.gensalt())
