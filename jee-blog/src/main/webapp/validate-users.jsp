<%@ page import="java.sql.*" %>
<%@ page import="com.blog.util.DatabaseConnection" %>
<%
    try (Connection con = DatabaseConnection.getConnection();
         Statement st = con.createStatement()) {
        int updated = st.executeUpdate("UPDATE membres SET valide=1");
        out.println("Done, updated " + updated + " members to valid.");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
