<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Messages"/>
<%@ include file="header.jsp" %>

<!-- MESSAGES TAB -->
<div id="tab-content-messages" class="h-[calc(100vh-64px)] lg:h-screen flex flex-col lg:flex-row max-w-7xl mx-auto w-full">
    
    <!-- Liste des conversations -->
    <div class="w-full lg:w-1/3 border-r border-white/10 flex flex-col h-full bg-dark-900">
        <div class="glass border-b border-white/10 p-4 sticky top-0 z-30 flex items-center justify-between">
            <h2 class="font-bold text-lg text-white">Messages</h2>
            <!-- Recherche ou Nouveau message modal déclencheur (Optionnel) -->
        </div>

        <div class="flex-1 overflow-y-auto no-scrollbar" id="conversationsList">
            <c:if test="${empty conversations}">
                <div class="p-8 text-center text-gray-500">
                    <i class="fas fa-inbox text-4xl mb-4"></i>
                    <p>Aucune conversation</p>
                </div>
            </c:if>

            <c:forEach var="convUser" items="${conversations}">
                <a href="${pageContext.request.contextPath}/messages?userId=${convUser.id}" 
                   class="flex items-center gap-4 p-4 hover:bg-white/5 transition-colors cursor-pointer border-b border-white/5 no-underline">
                    <div class="relative">
                        <c:if test="${empty convUser.avatar}">
                            <div class="w-14 h-14 rounded-full neon-ring p-0.5 flex items-center justify-center bg-dark-700 text-white uppercase font-bold text-lg">
                                ${convUser.prenom.charAt(0)}${convUser.nom.charAt(0)}
                            </div>
                        </c:if>
                        <c:if test="${not empty convUser.avatar}">
                            <img src="${convUser.avatar}" class="w-14 h-14 rounded-full border-2 border-neon-green p-0.5 object-cover">
                        </c:if>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="font-medium text-white truncate">${convUser.prenom} ${convUser.nom}</p>
                        <!-- Si on ajoutait le dernier message, ça irait ici -->
                        <p class="text-sm text-gray-400 truncate">Cliquez pour voir les messages</p>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- Vue de la conversation active -->
    <div class="hidden lg:flex flex-col flex-1 h-full bg-dark-800 <c:if test='${not empty currentConversation or not empty correspondant}'>!flex</c:if>">
        <c:if test="${empty correspondant}">
            <div class="flex-1 flex flex-col items-center justify-center text-gray-500 p-8">
                <div class="w-24 h-24 rounded-full border-2 border-white/10 flex items-center justify-center mb-6">
                    <i class="far fa-paper-plane text-4xl"></i>
                </div>
                <h3 class="text-2xl font-medium text-white mb-2">Vos messages</h3>
                <p>Envoyez des messages privés à vos amis.</p>
            </div>
        </c:if>

        <c:if test="${not empty correspondant}">
            <!-- Header du Chat -->
            <div class="glass border-b border-white/10 p-4 sticky top-0 flex items-center gap-4 shadow-lg z-10">
                <a href="${pageContext.request.contextPath}/messages" class="lg:hidden text-white hover:text-cyan-400">
                    <i class="fas fa-arrow-left text-xl"></i>
                </a>
                
                <c:if test="${empty correspondant.avatar}">
                    <div class="w-10 h-10 rounded-full flex items-center justify-center bg-dark-700 text-white uppercase font-bold neon-ring">
                        ${correspondant.prenom.charAt(0)}${correspondant.nom.charAt(0)}
                    </div>
                </c:if>
                <c:if test="${not empty correspondant.avatar}">
                    <img src="${correspondant.avatar}" class="w-10 h-10 rounded-full neon-ring object-cover">
                </c:if>
                
                <div>
                    <a href="${pageContext.request.contextPath}/profil?id=${correspondant.id}" class="font-bold text-white hover:underline text-lg">
                        ${correspondant.prenom} ${correspondant.nom}
                    </a>
                </div>
            </div>

            <!-- Messages -->
            <div class="flex-1 p-4 overflow-y-auto flex flex-col gap-4 no-scrollbar" id="chatArea">
                <c:if test="${empty currentConversation}">
                    <p class="text-center text-gray-500 my-8">Envoyez le premier message à ${correspondant.prenom} !</p>
                </c:if>
                
                <c:forEach var="msg" items="${currentConversation}">
                    <c:choose>
                        <c:when test="${msg.expediteurId == sessionScope.membre.id}">
                            <!-- Message envoyé (utilisateur courant) -->
                            <div class="message-bubble message-sent text-white animate-fade-in text-sm">
                                ${msg.contenu}
                                <div class="text-[10px] text-white/50 text-right mt-1"><fmt:formatDate value="${msg.dateEnvoi}" pattern="HH:mm"/></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Message reçu -->
                            <div class="flex items-end gap-2 mb-2">
                                <c:if test="${empty msg.expediteur.avatar}">
                                    <div class="w-8 h-8 rounded-full bg-dark-700 flex flex-shrink-0 items-center justify-center text-[10px] text-white">
                                        ${msg.expediteur.prenom.charAt(0)}
                                    </div>
                                </c:if>
                                <c:if test="${not empty msg.expediteur.avatar}">
                                    <img src="${msg.expediteur.avatar}" class="w-8 h-8 rounded-full flex-shrink-0 object-cover">
                                </c:if>
                                <div class="message-bubble message-received text-white flex-1 animate-fade-in text-sm">
                                    ${msg.contenu}
                                    <div class="text-[10px] text-gray-400 mt-1"><fmt:formatDate value="${msg.dateEnvoi}" pattern="HH:mm"/></div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

            <!-- Input area -->
            <div class="p-4 border-t border-white/10 glass mt-auto pb-10 lg:pb-4">
                <form action="${pageContext.request.contextPath}/messages" method="post" class="flex items-center gap-4">
                    ${csrfField}
                    <input type="hidden" name="destinataireId" value="${correspondant.id}">
                    <button type="button" class="text-neon-cyan hover:scale-110 transition-transform">
                        <i class="far fa-smile text-2xl"></i>
                    </button>
                    <input type="text" name="contenu" id="chatInput" placeholder="Votre message..." required
                        class="flex-1 bg-dark-900 border border-white/10 rounded-full px-6 py-3 text-white focus:outline-none focus:border-neon-cyan input-glow autocomplete-off">
                    <button type="submit" class="text-neon-purple hover:scale-110 transition-transform">
                        <i class="fas fa-paper-plane text-2xl"></i>
                    </button>
                    <!-- Make sure to autoscroll down -->
                </form>
            </div>
        </c:if>
    </div>
</div>

<script>
    // Faire défiler vers le bas les messages au chargement
    var chatArea = document.getElementById("chatArea");
    if (chatArea) {
        chatArea.scrollTop = chatArea.scrollHeight;
    }
</script>

<%@ include file="footer.jsp" %>
