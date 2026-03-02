<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Ma Collection"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<!-- COLLECTION PAGE -->
<div id="tab-content-collection" class="max-w-2xl mx-auto pt-4 px-4">

    <div class="flex items-center gap-3 mb-6">
        <i class="fas fa-bookmark text-2xl text-neon-cyan"></i>
        <h1 class="text-2xl font-bold text-white">Ma Collection</h1>
    </div>

    <!-- Empty State -->
    <c:if test="${empty articles}">
        <div class="glass border border-white/10 rounded-2xl p-12 text-center text-gray-400">
            <i class="fas fa-bookmark text-5xl mb-4 text-cyan-500/50"></i>
            <p class="text-xl mb-2">Aucun post sauvegardé</p>
            <p class="text-sm text-gray-500 mb-6">Enregistre des posts pour les retrouver ici.</p>
            <a href="${pageContext.request.contextPath}/" class="inline-block px-6 py-2.5 btn-neon rounded-full text-white font-medium">Explorer</a>
        </div>
    </c:if>

    <!-- Posts List -->
    <c:if test="${not empty articles}">
        <div class="space-y-6">
            <c:forEach var="article" items="${articles}">
                <div class="post-item glass rounded-2xl border border-white/10 overflow-hidden group">
                    <!-- Post Header -->
                    <div class="p-4 flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-full neon-ring-story p-0.5">
                                <c:if test="${empty article.auteur.avatar}">
                                    <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-xs text-white font-bold">
                                        ${article.auteur.prenom.charAt(0)}${article.auteur.nom.charAt(0)}
                                    </div>
                                </c:if>
                                <c:if test="${not empty article.auteur.avatar}">
                                    <img src="${article.auteur.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                                </c:if>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/profil?id=${article.auteur.id}" class="font-semibold text-sm hover:underline text-white">${article.auteur.prenom} ${article.auteur.nom}</a>
                                <p class="text-xs text-gray-500"><fmt:formatDate value="${article.datePublication}" pattern="dd MMM yyyy"/></p>
                            </div>
                        </div>
                        <!-- Remove from collection -->
                        <form action="${pageContext.request.contextPath}/collection/retirer" method="post" class="inline">
                            ${csrfField}
                            <input type="hidden" name="articleId" value="${article.id}">
                            <button type="submit" title="Retirer de la collection" class="text-neon-cyan hover:text-red-400 transition-colors p-1">
                                <i class="fas fa-bookmark text-xl"></i>
                            </button>
                        </form>
                    </div>

                    <!-- Post Content -->
                    <a href="${pageContext.request.contextPath}/articles/voir?id=${article.id}" class="block no-underline">
                        <c:if test="${not empty article.image}">
                            <img src="${article.image}" class="w-full h-auto object-cover max-h-[500px]" alt="${article.titre}">
                        </c:if>
                        <c:if test="${empty article.image}">
                            <div class="relative px-6 py-10 bg-gradient-to-br from-dark-800 via-dark-700 to-dark-800 border-y border-white/5">
                                <span class="absolute right-4 top-4 px-3 py-1 rounded-full bg-cyan-500/20 text-cyan-400 text-xs font-medium border border-cyan-500/30 backdrop-blur-md">
                                    ${article.module}
                                </span>
                                <h3 class="text-xl font-bold mb-3 group-hover:text-cyan-400 transition-colors text-white pr-20">
                                    ${article.titre}
                                </h3>
                                <p class="text-gray-300 text-sm line-clamp-3 leading-relaxed">
                                    ${article.extrait}
                                </p>
                            </div>
                        </c:if>
                    </a>

                    <!-- Stats -->
                    <div class="p-4">
                        <p class="text-sm font-semibold text-white mb-1">${article.likes} J'aime &bull; ${article.commentairesCount} commentaires</p>
                        <p class="text-sm text-gray-300 line-clamp-2">
                            <a href="${pageContext.request.contextPath}/profil?id=${article.auteur.id}" class="font-semibold text-white hover:underline no-underline mr-1">${article.auteur.prenom}</a>
                            ${article.extrait}
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<%@ include file="footer.jsp" %>
