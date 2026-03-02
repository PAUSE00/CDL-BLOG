# Etap 1: Build avec Maven et Java 11
FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances (cache docker)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source et construire le WAR
COPY src ./src
RUN mvn clean package -DskipTests

# Etap 2: Exécution avec Tomcat 9
FROM tomcat:9.0-jre11

# Supprimer l'application ROOT par défaut de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copier notre WAR construit depuis l'étape précédente et le renommer en ROOT.war
# Cela permet à l'application d'être accessible directement via l'URL racine (/)
COPY --from=build /app/target/jee-blog-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Exposer le port par défaut de Tomcat
EXPOSE 8080

# Démarrer Tomcat
CMD ["catalina.sh", "run"]
