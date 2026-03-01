<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>

<div class="flex items-center justify-center min-h-[calc(100vh-64px)] lg:min-h-screen px-4 pb-20">
    <div class="glass border border-white/10 rounded-3xl p-10 max-w-lg w-full text-center animate-scale-in relative overflow-hidden">
        <!-- Decoration -->
        <div class="absolute -top-10 -right-10 w-40 h-40 bg-neon-cyan/20 rounded-full blur-3xl"></div>
        <div class="absolute -bottom-10 -left-10 w-40 h-40 bg-neon-purple/20 rounded-full blur-3xl"></div>
        
        <div class="relative z-10">
            <div class="flex items-center justify-center mb-6">
                <span class="text-8xl font-black text-transparent bg-clip-text bg-gradient-to-r from-neon-cyan to-neon-purple drop-shadow-[0_0_15px_rgba(0,243,255,0.5)] animate-pulse-neon">403</span>
            </div>
            
            <div class="w-16 h-16 mx-auto rounded-full bg-dark-700 flex items-center justify-center border border-white/10 mb-6 neon-ring">
                <i class="fas fa-lock text-2xl text-white"></i>
            </div>
            
            <h1 class="text-3xl font-bold font-display text-white mb-4">Accès interdit</h1>
            <p class="text-gray-400 mb-8 leading-relaxed max-w-xs mx-auto">Vous n'avez pas les permissions nécessaires pour accéder à cette ressource.</p>
            
            <a href="${pageContext.request.contextPath}/" class="inline-flex items-center justify-center gap-2 px-8 py-3.5 btn-neon text-white rounded-xl font-bold transition-transform hover:-translate-y-1">
                <i class="fas fa-home"></i> Retour à l'accueil
            </a>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
