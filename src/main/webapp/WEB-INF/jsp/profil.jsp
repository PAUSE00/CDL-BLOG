<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Profil - ${profileUser.prenom} ${profileUser.nom}"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<!-- PROFILE TAB -->
<div id="tab-content-profile" class="max-w-4xl mx-auto pt-6 px-4">
    <!-- Profile Header -->
    <div class="p-6">
        <div class="flex flex-col md:flex-row gap-8 mb-8">
            <!-- Avatar -->
            <div class="flex-shrink-0 mx-auto md:mx-0 relative group">
                <div class="w-32 h-32 md:w-36 md:h-36 rounded-full neon-ring p-1 overflow-hidden">
                    <c:if test="${empty profileUser.avatar}">
                        <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-4xl font-bold text-white uppercase shadow-lg">
                            ${profileUser.prenom.charAt(0)}${profileUser.nom.charAt(0)}
                        </div>
                    </c:if>
                    <c:if test="${not empty profileUser.avatar}">
                        <img src="${profileUser.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                    </c:if>
                </div>
                
                <c:if test="${not empty sessionScope.membre and sessionScope.membre.id == profileUser.id}">
                    <!-- Avatar Upload Overlay -->
                    <form action="${pageContext.request.contextPath}/profil/avatar" method="post" enctype="multipart/form-data" id="avatarForm">
                        ${csrfField}
                        <label class="absolute inset-0 m-1 rounded-full bg-black/60 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">
                            <i class="fas fa-camera text-white text-2xl"></i>
                            <input type="file" name="avatar" class="hidden" accept="image/*" onchange="document.getElementById('avatarForm').submit();">
                        </label>
                    </form>
                </c:if>
            </div>
            
            <!-- Info & Stats -->
            <div class="flex-1 text-center md:text-left">
                <div class="flex flex-col md:flex-row md:items-center justify-center md:justify-start gap-4 mb-4">
                    <h2 class="text-2xl font-medium text-white">${profileUser.prenom} ${profileUser.nom}</h2>
                    
                    <div class="flex justify-center gap-2">
                        <c:choose>
                            <c:when test="${not empty sessionScope.membre and sessionScope.membre.id == profileUser.id}">
                                <!-- Owner seeing their own profile -->
                                <button onclick="document.getElementById('editProfileForm').classList.toggle('hidden')" class="px-6 py-2 rounded-lg bg-white text-dark-900 font-medium text-sm hover:bg-gray-200 transition-colors">
                                    Modifier profil
                                </button>
                            </c:when>
                            <c:when test="${not empty sessionScope.membre}">
                                <!-- User seeing someone else's profile -->
                                <form action="${pageContext.request.contextPath}/follow" method="post" class="inline">
                                    ${csrfField}
                                    <input type="hidden" name="followingId" value="${profileUser.id}">
                                    <button type="submit" class="px-6 py-2 rounded-lg font-medium text-sm transition-colors ${isFollowing ? 'glass hover:bg-white/10 text-white' : 'bg-neon-cyan hover:bg-cyan-400 text-dark-900'}">
                                        ${isFollowing ? 'Abonné(e)' : 'S\'abonner'}
                                    </button>
                                </form>
                                <a href="${pageContext.request.contextPath}/messages?userId=${profileUser.id}" class="px-6 py-2 rounded-lg glass text-sm font-medium text-white hover:bg-white/10 ml-2">
                                    Message
                                </a>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
                
                <div class="flex justify-center md:justify-start gap-8 mb-4 text-sm">
                    <span class="flex flex-col md:flex-row items-center gap-1"><strong class="text-white text-lg md:text-sm">${mesArticles.size()}</strong> <span class="text-gray-400">publications</span></span>
                    <span class="flex flex-col md:flex-row items-center gap-1"><strong class="text-white text-lg md:text-sm">${followersCount}</strong> <span class="text-gray-400">abonnés</span></span>
                    <span class="flex flex-col md:flex-row items-center gap-1"><strong class="text-white text-lg md:text-sm">${followingCount}</strong> <span class="text-gray-400">abonnements</span></span>
                </div>
                
                <div class="mt-4">
                    <p class="font-medium text-white">${profileUser.prenom} ${profileUser.nom}</p>
                    <c:if test="${not empty profileUser.bio}">
                        <div class="text-gray-300 text-sm mt-2 whitespace-pre-wrap">${profileUser.bio}</div>
                    </c:if>
                    <c:if test="${empty profileUser.bio}">
                        <p class="text-gray-500 text-sm italic mt-1">Aucune bio enregistrée.</p>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Edit Profile Form (hidden by default) -->
        <c:if test="${not empty sessionScope.membre and sessionScope.membre.id == profileUser.id}">
            <div id="editProfileForm" class="hidden glass p-6 rounded-2xl mb-8 border border-white/10">
                <h3 class="text-xl font-bold mb-4">Modifier mon profil</h3>
                
                <form method="post" action="${pageContext.request.contextPath}/profil/modifier" class="space-y-4">
                    ${csrfField}
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm text-gray-400 mb-1">Prénom</label>
                            <input type="text" name="prenom" value="${profileUser.prenom}" required class="w-full bg-dark-700 border border-white/10 rounded-lg px-4 py-2 text-white input-glow focus:outline-none focus:border-neon-cyan">
                        </div>
                        <div>
                            <label class="block text-sm text-gray-400 mb-1">Nom</label>
                            <input type="text" name="nom" value="${profileUser.nom}" required class="w-full bg-dark-700 border border-white/10 rounded-lg px-4 py-2 text-white input-glow focus:outline-none focus:border-neon-cyan">
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm text-gray-400 mb-1">Bio</label>
                        <textarea name="bio" rows="3" class="w-full bg-dark-700 border border-white/10 rounded-lg px-4 py-2 text-white input-glow focus:outline-none focus:border-neon-cyan">${profileUser.bio}</textarea>
                    </div>
                    <div class="flex justify-end gap-2">
                        <button type="button" onclick="document.getElementById('editProfileForm').classList.add('hidden')" class="px-4 py-2 rounded-lg glass text-white text-sm">Annuler</button>
                        <button type="submit" class="px-4 py-2 rounded-lg btn-neon text-white text-sm font-medium">Enregistrer</button>
                    </div>
                </form>
            </div>
        </c:if>

        <c:if test="${not empty succes}">
            <script>showToast("Profil mis à jour avec succès !", "success");</script>
        </c:if>

    </div>

    <!-- Tabs -->
    <div class="flex border-t border-white/10">
        <button class="flex-1 py-4 text-center border-t-2 border-white text-white -mt-[1px] font-medium text-sm tracking-widest">
            <i class="fas fa-th md:hidden"></i> <span class="hidden md:inline"><i class="fas fa-th mr-2"></i>PUBLICATIONS</span>
        </button>
    </div>

    <!-- Posts Grid -->
    <div class="grid grid-cols-3 gap-1 md:gap-4 p-1 md:p-4 mb-10">
        <c:if test="${empty mesArticles}">
            <div class="col-span-3 text-center py-12 text-gray-500">
                <i class="fas fa-camera text-4xl mb-4 opacity-50"></i>
                <p>Aucune publication</p>
            </div>
        </c:if>
        
        <c:forEach var="article" items="${mesArticles}">
            <a href="${pageContext.request.contextPath}/articles/voir?id=${article.id}" class="post-item relative aspect-square bg-dark-800 cursor-pointer group overflow-hidden rounded md:rounded-xl">
                <c:if test="${not empty article.image}">
                    <img src="${article.image}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
                </c:if>
                <c:if test="${empty article.image}">
                    <div class="w-full h-full flex items-center justify-center p-4 bg-gradient-to-br from-dark-700 to-dark-800 border border-white/5 transition-transform duration-500 group-hover:scale-110">
                        <p class="text-white text-center text-xs md:text-sm font-medium line-clamp-3">${article.titre}</p>
                    </div>
                </c:if>
                
                <div class="post-overlay absolute inset-0 flex items-center justify-center gap-2 md:gap-6 text-white font-medium">
                    <span class="flex items-center gap-1 md:gap-2"><i class="fas fa-heart text-neon-pink text-xs md:text-base"></i> <span class="text-xs md:text-base">${article.likes}</span></span>
                    <!-- You can add comment count here if available -->
                </div>
            </a>
        </c:forEach>
    </div>

</div>

<%@ include file="footer.jsp" %>
