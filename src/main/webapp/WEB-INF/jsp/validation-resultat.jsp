<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<main class="relative z-10 pt-28 pb-12 px-4 sm:px-6 lg:px-8 max-w-lg mx-auto min-h-[80vh] flex items-center">
    
    <c:choose>
        <c:when test="${not empty succes}">
            <div class="w-full glass-card rounded-3xl p-10 text-center shadow-2xl relative overflow-hidden group">
                <!-- Decoration -->
                <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-blue-400 to-cyan-500"></div>
                <div class="absolute -top-10 -right-10 w-40 h-40 bg-blue-500/20 rounded-full blur-3xl"></div>
                
                <div class="relative z-10">
                    <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-blue-400/20 to-cyan-500/20 flex items-center justify-center border border-blue-500/30 mb-8 shadow-lg shadow-blue-500/20 animate-fade-in">
                        <i class="fas fa-check-circle text-5xl text-blue-400"></i>
                    </div>
                    
                    <h1 class="text-3xl font-bold text-white mb-4">Félicitations !</h1>
                    <p class="text-gray-300 mb-8 leading-relaxed">${succes}</p>
                    
                    <a href="${pageContext.request.contextPath}/connexion" class="inline-flex items-center justify-center gap-2 px-8 py-3.5 bg-gradient-to-r from-blue-600 to-cyan-600 hover:from-blue-500 hover:to-cyan-500 text-white rounded-xl font-medium transition-all shadow-lg hover:shadow-[0_0_20px_rgba(6,182,212,0.4)] w-full">
                        Se connecter
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="w-full glass-card rounded-3xl p-10 text-center shadow-2xl relative overflow-hidden group border-red-500/30">
                <!-- Decoration -->
                <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-red-500 to-rose-600"></div>
                
                <div class="relative z-10">
                    <div class="w-24 h-24 mx-auto rounded-full bg-gradient-to-br from-red-500/20 to-rose-600/20 flex items-center justify-center border border-red-500/30 mb-8 shadow-lg shadow-red-500/20">
                        <i class="fas fa-times-circle text-5xl text-red-500"></i>
                    </div>
                    
                    <h1 class="text-2xl font-bold text-white mb-4">Échec de validation</h1>
                    <p class="text-gray-300 mb-8 leading-relaxed">${erreur}</p>
                    
                    <a href="${pageContext.request.contextPath}/" class="inline-flex items-center justify-center gap-2 px-8 py-3.5 bg-slate-700 hover:bg-slate-600 border border-gray-600 hover:border-gray-500 text-white rounded-xl font-medium transition-colors w-full">
                        Retour à l'accueil
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
    
</main>

<%@ include file="footer.jsp" %>
