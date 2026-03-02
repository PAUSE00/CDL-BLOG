-- ==========================================
-- SCRIPT D'INSERTION DE DONNÉES DE DÉMO
-- ==========================================
-- Mot de passe pour tous les utilisateurs : admin123
-- (Hash BCrypt généré : $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy)

USE jee_blog;
SET NAMES utf8mb4;

-- Désactiver temporairement les vérifications de clés étrangères pour simplifier l'insertion de démo
SET FOREIGN_KEY_CHECKS = 0;

-- Vider les tables au cas où
TRUNCATE TABLE follows;
TRUNCATE TABLE messages;
TRUNCATE TABLE notifications;
TRUNCATE TABLE collections;
TRUNCATE TABLE likes_article;
TRUNCATE TABLE commentaires;
TRUNCATE TABLE articles;
DELETE FROM membres WHERE email LIKE '%@demo.com';

SET FOREIGN_KEY_CHECKS = 1;

-- 1. INSERTION DE MEMBRES
INSERT INTO membres (nom, prenom, email, mot_de_passe, valide, bio, avatar) VALUES
('Dupont', 'Alice', 'alice@demo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true, 'Développeuse Fullstack passionnée par le web et le café.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice'),
('Martin', 'Bob', 'bob@demo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true, 'Amoureux de Java et l''architecture logicielle.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob'),
('Bernard', 'Charlie', 'charlie@demo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true, 'Designeur UI/UX la journée, gamer la nuit.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Charlie'),
('Petit', 'Diana', 'diana@demo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true, 'Ingénieure réseaux et sécurité.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Diana'),
('Lefebvre', 'Thomas', 'thomas@demo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', true, 'Étudiant en informatique, toujours curieux de découvrir de nouvelles technos.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Thomas');

-- Récupérer les identifiants générés (ceux-ci vont varier selon la base, donc ce qui suit utilise des IDs approximatifs si l'auto-incrément est propre)
-- Pour garantir que les insertions fonctionnent sans chercher les IDs, utilisons des variables.

SET @alice = (SELECT id FROM membres WHERE email = 'alice@demo.com');
SET @bob = (SELECT id FROM membres WHERE email = 'bob@demo.com');
SET @charlie = (SELECT id FROM membres WHERE email = 'charlie@demo.com');
SET @diana = (SELECT id FROM membres WHERE email = 'diana@demo.com');
SET @thomas = (SELECT id FROM membres WHERE email = 'thomas@demo.com');

-- 2. INSERTION D'ARTICLES
INSERT INTO articles (membre_id, titre, contenu, module, vues) VALUES
(@alice, 'Les nouveautés de Java 21', 'Java 21 regorge de nouvelles fonctionnalités impressionnantes ! Les virtual threads (Loom) sont enfin là, ainsi que les record patterns et le pattern matching pour le switch...\n\n```java\nString formatted = switch (obj) {\n    case Integer i -> String.format("int %d", i);\n    case Long l    -> String.format("long %d", l);\n    case Double d  -> String.format("double %f", d);\n    case String s  -> String.format("String %s", s);\n    default        -> obj.toString();\n};\n```\n\nAvez-vous déjà testé ?', 'Java', 125);

SET @articleJava = LAST_INSERT_ID();

INSERT INTO articles (membre_id, titre, contenu, module, image, vues) VALUES
(@bob, 'Comprendre Spring Boot 3 et Spring Security 6', 'Dans ce post, on décortique les nouveautés de Spring Boot 3. Le passage à Jakarta EE 10 a cassé pas mal de choses, mais l''intégration de GraalVM pour les images natives est un **game changer** pour les temps de démarrage en production.\n\nSpring Security 6 redessine aussi complètement la façon de configurer le filtre `SecurityFilterChain`. Adieu les méthodes dépréciées de `WebSecurityConfigurerAdapter` !', 'Développement Web', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=2070&auto=format&fit=crop', 89);

SET @articleSpring = LAST_INSERT_ID();

INSERT INTO articles (membre_id, titre, contenu, module, vues) VALUES
(@charlie, 'Pourquoi j''adore le mode sombre (Dark Mode)', 'Le mode sombre n''est pas seulement une tendance stylistique (Neon UI etc.), c''est crucial pour le confort oculaire des utilisateurs, surtout la nuit.\n\nDans vos projets, intégrez-vous le dark mode nativement avec CSS `prefers-color-scheme` ou via JS ?\n\n```css\n@media (prefers-color-scheme: dark) {\n  body {\n    background-color: #121212;\n    color: #ffffff;\n  }\n}\n```', 'Développement Web', 342);

SET @articleCss = LAST_INSERT_ID();

INSERT INTO articles (membre_id, titre, contenu, module, image, vues) VALUES
(@diana, 'Cybersécurité : les attaques les plus courantes en 2024', 'L''hameçonnage (Phishing) reste de loin le vecteur d''attaque n°1. Mais les failles sur les API mal sécurisées et l''exploitation de mauvaises configurations cloud gagnent énormément de terrain.\n\nN''oubliez jamais le principe du moindre privilège !', 'Réseaux', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=2070&auto=format&fit=crop', 56);

SET @articleReseaux = LAST_INSERT_ID();

INSERT INTO articles (membre_id, titre, contenu, module, vues) VALUES
(@thomas, 'Mon premier message ici ! 👋', 'Salut tout le monde, je suis nouveau sur cette plateforme. J''espère apprendre beaucoup avec vous. Pour le moment je découvre Servlet & JSP, c''est un peu old school mais ça aide vraiment à comprendre les bases du web en Java avce le cycle de requête/réponse.', 'Général', 12);

SET @articleNew = LAST_INSERT_ID();

-- 3. INSERTION DE COMMENTAIRES
INSERT INTO commentaires (article_id, membre_id, contenu) VALUES
(@articleJava, @bob, 'Entièrement d''accord ! Les virtual threads vont vraiment simplifier la concomitance en Java, finis les pools de threads réactifs ultra-complexes avec WebFlux pour des cas simples.'),
(@articleJava, @charlie, 'Merci pour les extraits de code !'),
(@articleSpring, @alice, 'Le passage de javax.* à jakarta.* a été une vraie galère sur mon projet d''entreprise, on a dû réécrire tellement d''imports...'),
(@articleCss, @diana, 'Perso j''utilise du JS + Tailwind pour le toggle DarkMode. `class="dark"` sur le tag html et c''est plié.'),
(@articleNew, @alice, 'Bienvenue Thomas ! N''hésite pas à poser tes questions sur JSP.'),
(@articleNew, @bob, 'Salut Thomas, bon courage pour les cours JEE :)');

-- 4. INSERTION DE LIKES (likes_article)
INSERT INTO likes_article (membre_id, article_id) VALUES
(@alice, @articleSpring),
(@alice, @articleCss),
(@bob, @articleJava),
(@charlie, @articleJava),
(@diana, @articleJava),
(@thomas, @articleJava),
(@charlie, @articleNew),
(@alice, @articleNew),
(@thomas, @articleCss);

-- Mise à jour factice du compteur de likes des articles (Normalement un TRIGGER pourrait le faire, ou count direct)
-- On simule juste quelques compteurs cohérents si le backend le demande.
-- Les likes sont comptés dynamiquement par le DAO (COUNT(*)), donc pas la peine de stocker une colonne likes figée normalement.

-- 5. INSERTION DE COLLECTIONS (Articles sauvegardés)
INSERT INTO collections (membre_id, article_id) VALUES
(@alice, @articleSpring),
(@alice, @articleReseaux),
(@bob, @articleCss),
(@thomas, @articleJava),
(@thomas, @articleSpring);

-- 6. INSERTION DE FOLLOWERS
INSERT INTO follows (follower_id, following_id) VALUES
(@alice, @bob),
(@bob, @alice),
(@charlie, @alice),
(@diana, @alice),
(@thomas, @alice),
(@alice, @diana),
(@thomas, @bob);

-- 7. INSERTION DE MESSAGES PRIVÉS
-- Alice discute avec Bob
INSERT INTO messages (expediteur_id, destinataire_id, contenu, lu, date_envoi) VALUES
(@alice, @bob, 'Salut Bob, tu aurais le temps de jeter un oeil à mon code Java ?', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(@bob, @alice, 'Salut Alice ! Oui pas de soucis, envoie-moi le lien du git.', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(@alice, @bob, 'Merci ! Tiens : github.com/alice/mon-projet . C''est surtout le DAO qui pose souci.', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(@bob, @alice, 'D''acc je regarde ça ce soir.', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(@alice, @bob, 'C''est vraiment sympa, redis-moi si tu vois le bug.', 0, DATE_SUB(NOW(), INTERVAL 1 HOUR));

-- Thomas écrit à Diana
INSERT INTO messages (expediteur_id, destinataire_id, contenu, lu, date_envoi) VALUES
(@thomas, @diana, 'Bonjour Diana, j''ai vu ton article sur la cybersécurité. As-tu des ressources pour débutants ?', 0, DATE_SUB(NOW(), INTERVAL 5 MINUTE));

-- 8. INSERTION DE NOTIFICATIONS
INSERT INTO notifications (membre_id, source_membre_id, article_id, type, lu, date_creation) VALUES
(@alice, @bob, @articleJava, 'LIKE', 0, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(@alice, @charlie, @articleJava, 'COMMENTAIRE', 0, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(@bob, @alice, @articleSpring, 'LIKE', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(@thomas, @alice, @articleNew, 'COMMENTAIRE', 0, DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
(@alice, @thomas, NULL, 'FOLLOW', 0, DATE_SUB(NOW(), INTERVAL 10 MINUTE));

COMMIT;

-- FIN DU SCRIPT
