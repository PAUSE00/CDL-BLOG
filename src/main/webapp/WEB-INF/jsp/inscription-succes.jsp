<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Inscription Réussie"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<div class="flex items-center justify-center min-h-[calc(100vh-64px)] lg:min-h-screen px-4 pb-20">
    <div class="glass border border-white/10 rounded-3xl p-10 max-w-lg w-full text-center animate-scale-in relative overflow-hidden">
        <!-- Decoration -->
        <div class="absolute -top-10 -right-10 w-40 h-40 bg-neon-green/20 rounded-full blur-3xl"></div>
        <div class="absolute -bottom-10 -left-10 w-40 h-40 bg-neon-cyan/20 rounded-full blur-3xl"></div>
        
        <div class="relative z-10">
            <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-neon-green/20 to-neon-cyan/20 flex items-center justify-center border border-neon-green/30 mb-8 shadow-[0_0_20px_rgba(0,255,157,0.3)] animate-pulse-neon neon-ring">
                <i class="fas fa-envelope-open-text text-4xl text-white"></i>
            </div>
            
            <h1 class="text-3xl font-bold font-display text-white mb-4">Inscription réussie !</h1>
            
            <div class="bg-dark-800/50 rounded-2xl p-6 mb-8 border border-white/10">
                <p class="text-gray-300 mb-4 leading-relaxed text-sm">
                    Votre compte a été créé avec succès. Pour l'activer et commencer à publier, veuillez vérifier votre boîte de réception.
                </p>
                <p class="text-xs text-neon-cyan font-medium">
                    <i class="fas fa-info-circle mr-1"></i> Un email contenant un lien d'activation vous a été envoyé.
                </p>
            </div>
            
            <a href="${pageContext.request.contextPath}/connexion" class="inline-flex items-center justify-center gap-2 px-8 py-3.5 btn-neon text-white rounded-xl font-bold transition-transform hover:-translate-y-1 w-full group">
                <fmt:message key="inscription.seConnecter" bundle="${msg}"/> <i class="fas fa-arrow-right transition-transform group-hover:translate-x-1"></i>
            </a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
