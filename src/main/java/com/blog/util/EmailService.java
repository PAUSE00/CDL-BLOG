package com.blog.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;

/**
 * Service d'envoi d'emails (validation inscription).
 * Les credentials sont externalisés dans email.properties.
 */
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    private static String fromEmail;
    private static String fromPassword;
    private static String smtpHost;
    private static int smtpPort;
    private static String appUrl;

    static {
        try {
            Properties props = new Properties();
            InputStream is = EmailService.class.getClassLoader().getResourceAsStream("email.properties");
            if (is != null) {
                props.load(is);
                is.close();
            } else {
                logger.warn("email.properties introuvable, utilisation des valeurs par défaut");
            }

            fromEmail = props.getProperty("email.from", "votre.email@gmail.com");
            fromPassword = props.getProperty("email.password", "votre_mot_de_passe_app");
            smtpHost = props.getProperty("email.smtp.host", "smtp.gmail.com");
            smtpPort = Integer.parseInt(props.getProperty("email.smtp.port", "587"));
            appUrl = props.getProperty("email.app.url", "http://localhost:8080/jee-blog");
        } catch (Exception e) {
            logger.error("Erreur lors du chargement de la configuration email", e);
        }
    }

    /**
     * Envoie un email de validation d'inscription
     */
    public static void envoyerEmailValidation(String destinataire, String token) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, fromPassword);
            }
        });

        String lienValidation = appUrl + "/valider-compte?token=" + token;

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinataire));
        message.setSubject("Validation de votre compte Blog JEE");

        String corps = "<html><body style='font-family:Arial;'>"
                + "<div style='max-width:600px;margin:auto;padding:20px;border:1px solid #ddd;border-radius:8px;'>"
                + "<h2 style='color:#2c7a4b;'>Bienvenue sur Blog JEE !</h2>"
                + "<p>Merci de vous être inscrit. Cliquez sur le bouton ci-dessous pour valider votre compte :</p>"
                + "<a href='" + lienValidation + "' "
                + "style='display:inline-block;padding:12px 24px;background:#2c7a4b;color:white;text-decoration:none;border-radius:5px;margin:20px 0;'>"
                + "Valider mon compte</a>"
                + "<p style='color:#888;font-size:12px;'>Ce lien expire dans 24 heures.<br>"
                + "Si vous n'avez pas créé de compte, ignorez cet email.</p>"
                + "</div></body></html>";

        message.setContent(corps, "text/html; charset=UTF-8");
        Transport.send(message);
        logger.info("Email de validation envoyé à {}", destinataire);
    }
}
