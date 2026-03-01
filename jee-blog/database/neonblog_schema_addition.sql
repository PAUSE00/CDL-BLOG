
-- ============================================================
-- Tables ajoutées pour NeonBlog (Social Edition)
-- ============================================================

-- Table: messages
CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    expediteur_id INT NOT NULL,
    destinataire_id INT NOT NULL,
    contenu TEXT NOT NULL,
    lu BOOLEAN DEFAULT FALSE,
    date_envoi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expediteur_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (destinataire_id) REFERENCES membres(id) ON DELETE CASCADE
);

-- Table: notifications
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    membre_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,  -- 'like', 'comment', 'follow'
    source_membre_id INT NOT NULL,
    article_id INT,
    lu BOOLEAN DEFAULT FALSE,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (source_membre_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

-- Table: likes_article
CREATE TABLE IF NOT EXISTS likes_article (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    membre_id INT NOT NULL,
    date_like DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(article_id, membre_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE
);

-- Table: follows
CREATE TABLE IF NOT EXISTS follows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    date_follow DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES membres(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES membres(id) ON DELETE CASCADE
);

-- Table: collections (articles sauvegardes)
CREATE TABLE IF NOT EXISTS collections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    membre_id INT NOT NULL,
    date_sauvegarde DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(article_id, membre_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (membre_id) REFERENCES membres(id) ON DELETE CASCADE
);
