<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Notifications"/>
<%@ include file="header.jsp" %>

<!-- NOTIFICATIONS -->
<div id="tab-content-notifications" class="max-w-2xl mx-auto pt-6 px-4">
    <div class="glass border-b border-white/10 p-4 sticky top-0 z-30 flex items-center justify-between rounded-t-2xl">
        <h2 class="font-bold text-2xl text-white">Notifications</h2>
        <c:if test="${not empty notifications}">
            <span class="text-neon-cyan text-sm font-medium"><i class="fas fa-check-double mr-1"></i> Lu</span>
        </c:if>
    </div>
    
    <div id="notificationsList" class="divide-y divide-white/5 bg-dark-800/50 rounded-b-2xl border-x border-b border-white/10 mb-10">
        
        <c:if test="${empty notifications}">
            <div class="p-12 text-center text-gray-500">
                <i class="far fa-bell text-5xl mb-4 text-cyan-500/30"></i>
                <p class="text-lg">Aucune notification pour le moment</p>
            </div>
        </c:if>

        <c:forEach var="notif" items="${notifications}">
            <div class="flex flex-wrap items-center gap-4 p-4 hover:bg-white/5 transition-colors cursor-pointer ${notif.lu ? 'opacity-70' : ''}">
                <div class="relative flex-shrink-0">
                    <c:if test="${empty notif.sourceMembre.avatar}">
                        <div class="w-12 h-12 rounded-full ${notif.lu ? 'bg-dark-700' : 'neon-ring p-0.5 bg-dark-700'} flex items-center justify-center text-white font-bold uppercase">
                            ${notif.sourceMembre.prenom.charAt(0)}${notif.sourceMembre.nom.charAt(0)}
                        </div>
                    </c:if>
                    <c:if test="${not empty notif.sourceMembre.avatar}">
                        <img src="${notif.sourceMembre.avatar}" class="w-12 h-12 rounded-full ${notif.lu ? '' : 'neon-ring p-0.5'} object-cover">
                    </c:if>
                    
                    <!-- Icon Type badge over avatar -->
                    <div class="absolute -bottom-1 -right-1 w-5 h-5 rounded-full flex items-center justify-center text-[10px] text-white border-2 border-dark-900 shadow-md">
                        <c:choose>
                            <c:when test="${notif.type == 'like'}">
                                <div class="bg-red-500 w-full h-full rounded-full flex items-center justify-center"><i class="fas fa-heart"></i></div>
                            </c:when>
                            <c:when test="${notif.type == 'comment'}">
                                <div class="bg-blue-500 w-full h-full rounded-full flex items-center justify-center"><i class="fas fa-comment"></i></div>
                            </c:when>
                            <c:when test="${notif.type == 'follow'}">
                                <div class="bg-neon-cyan w-full h-full rounded-full flex items-center justify-center text-dark-900"><i class="fas fa-user-plus"></i></div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
                
                <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-300">
                        <a href="${pageContext.request.contextPath}/profil?id=${notif.sourceMembre.id}" class="font-bold text-white hover:underline">${notif.sourceMembre.prenom} ${notif.sourceMembre.nom}</a>
                        <c:choose>
                            <c:when test="${notif.type == 'like'}">
                                a aimé votre publication.
                            </c:when>
                            <c:when test="${notif.type == 'comment'}">
                                a répondu à votre publication.
                            </c:when>
                            <c:when test="${notif.type == 'follow'}">
                                a commencé à vous suivre.
                            </c:when>
                        </c:choose>
                        
                        <c:if test="${not empty notif.articleId}">
                            <a href="${pageContext.request.contextPath}/articles/voir?id=${notif.articleId}" class="text-neon-cyan hover:underline ml-1">Voir</a>
                        </c:if>
                    </p>
                    <p class="text-xs text-gray-500 mt-1"><fmt:formatDate value="${notif.dateCreation}" pattern="dd MMM à HH:mm"/></p>
                </div>
                
                <c:if test="${notif.type == 'follow'}">
                    <div class="flex-shrink-0">
                        <a href="${pageContext.request.contextPath}/profil?id=${notif.sourceMembre.id}" class="px-3 py-1.5 rounded-lg bg-neon-cyan hover:bg-cyan-400 text-dark-900 text-xs font-bold transition-colors shadow-lg shadow-cyan-500/20">
                            Profil
                        </a>
                    </div>
                </c:if>
                <c:if test="${not empty notif.article}">
                    <div class="flex-shrink-0">
                         <a href="${pageContext.request.contextPath}/articles/voir?id=${notif.article.id}" class="w-12 h-12 rounded border border-white/20 bg-dark-700 flex items-center justify-center text-white/50 text-xs hover:border-cyan-400 transition-colors">
                            <c:if test="${not empty notif.article.image}">
                                <img src="${notif.article.image}" class="w-full h-full object-cover rounded">
                            </c:if>
                            <c:if test="${empty notif.article.image}">
                                <i class="fas fa-file-alt text-lg"></i>
                            </c:if>
                         </a>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="footer.jsp" %>
