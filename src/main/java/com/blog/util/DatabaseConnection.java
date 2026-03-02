package com.blog.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utilitaire de connexion à la base de données MySQL avec pool HikariCP.
 * Les credentials sont externalisés dans db.properties.
 */
public class DatabaseConnection {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseConnection.class);
    private static final HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                is.close();
            } else {
                logger.warn("db.properties introuvable, utilisation des valeurs par défaut");
            }

            HikariConfig config = new HikariConfig();

            // Configuration Cloud (Railway) ou locale (db.properties)
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String database = System.getenv("MYSQLDATABASE");

            if (host != null && port != null && database != null) {
                config.setJdbcUrl("jdbc:mysql://" + host + ":" + port + "/" + database
                        + "?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8");
            } else {
                config.setJdbcUrl(props.getProperty("db.url",
                        "jdbc:mysql://localhost:3306/jee_blog?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8"));
            }

            String envUser = System.getenv("MYSQLUSER");
            config.setUsername(envUser != null ? envUser : props.getProperty("db.user", "root"));

            String envPassword = System.getenv("MYSQLPASSWORD");
            config.setPassword(envPassword != null ? envPassword : props.getProperty("db.password", ""));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.size", "10")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minIdle", "2")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout", "30000")));
            config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout", "600000")));
            config.setMaxLifetime(Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000")));
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            dataSource = new HikariDataSource(config);
            logger.info("Pool de connexions HikariCP initialisé avec succès");
        } catch (Exception e) {
            logger.error("Erreur lors de l'initialisation du pool de connexions", e);
            throw new RuntimeException("Impossible d'initialiser le pool de connexions", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * Fermer le pool de connexions proprement à l'arrêt de l'application.
     */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("Pool de connexions HikariCP fermé");
        }
    }
}
