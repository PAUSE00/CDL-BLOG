<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Accueil"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<!-- HOME FEED -->
<div id="tab-content-home" class="max-w-2xl mx-auto pt-4 px-4">

    <!-- ===== EMPTY STATE ===== -->
    <c:if test="${empty articles}">
        <div class="glass border border-white/10 rounded-2xl p-12 text-center text-gray-400">
            <i class="fas fa-newspaper text-5xl mb-4 text-cyan-500/50"></i>
            <p class="text-xl mb-6"><fmt:message key="home.aucunArticle" bundle="${msg}"/></p>
            <c:if test="${not empty sessionScope.membre}">
                <a href="${pageContext.request.contextPath}/articles/nouveau" class="inline-block px-6 py-2.5 btn-neon rounded-full text-white font-medium">
                    <fmt:message key="nav.nouvelArticle" bundle="${msg}"/>
                </a>
            </c:if>
        </div>
    </c:if>

    <!-- ===== POSTS FEED ===== -->
    <c:if test="${not empty articles}">
        <div id="postsFeed" class="space-y-6">
            <c:forEach var="article" items="${articles}" varStatus="status">
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
                                <div class="flex items-center gap-2">
                                    <a href="${pageContext.request.contextPath}/profil?id=${article.auteur.id}" class="font-semibold text-sm hover:underline text-white">${article.auteur.prenom} ${article.auteur.nom}</a>
                                    <c:if test="${not empty article.auteur && article.auteur.id == 1}">
                                        <i class="fas fa-check-circle text-neon-cyan text-xs" title="Verified"></i>
                                    </c:if>
                                </div>
                                <p class="text-xs text-gray-500">
                                    <span class="text-gray-500">Original audio</span>
                                </p>
                            </div>
                        </div>
                        <button class="text-gray-400 hover:text-white transition-colors p-1">
                            <i class="fas fa-ellipsis-h"></i>
                        </button>
                    </div>

                    <!-- Post Content (card body) -->
                    <a href="${pageContext.request.contextPath}/articles/voir?id=${article.id}" class="block no-underline">
                        <c:if test="${not empty article.image}">
                            <img src="${article.image}" class="w-full h-auto object-cover max-h-[500px]" alt="${article.titre}">
                        </c:if>
                        <c:if test="${empty article.image}">
                            <!-- Text-only post with decorative gradient background -->
                            <div class="relative px-6 py-10 bg-gradient-to-br from-dark-800 via-dark-700 to-dark-800 border-y border-white/5">
                                <!-- Module Tag floating -->
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

                    <!-- Post Actions Bar (Instagram-style) -->
                    <div class="p-4">
                        <div class="flex items-center gap-5 text-2xl mb-3">
                            <!-- LIKE -->
                            <form action="${pageContext.request.contextPath}/like" method="post" class="flex items-center gap-2">
                                ${csrfField}
                                <input type="hidden" name="articleId" value="${article.id}">
                                <button type="submit" class="text-gray-400 hover:text-neon-pink transition-colors group">
                                    <i class="far fa-heart group-hover:scale-125 transition-transform duration-300"></i>
                                </button>
                                <span class="text-base font-semibold text-white">${article.likes}</span>
                            </form>
                            <!-- COMMENT -->
                            <a href="${pageContext.request.contextPath}/articles/voir?id=${article.id}" class="flex items-center gap-2 text-gray-400 hover:text-white transition-colors no-underline">
                                <i class="far fa-comment hover:scale-110 transition-transform"></i>
                                <span class="text-base font-semibold text-white">${article.commentairesCount}</span>
                            </a>
                            <!-- SHARE -->
                            <button class="text-gray-400 hover:text-white transition-colors">
                                <i class="far fa-paper-plane hover:-translate-y-0.5 hover:translate-x-0.5 transition-transform"></i>
                            </button>
                            <div class="flex-1"></div>
                            <!-- BOOKMARK -->
                            <c:set var="bookmarkAction" value="${article.estSauvegarde ? '/collection/retirer' : '/collection/sauvegarder'}" />
                            <c:set var="bookmarkIcon" value="${article.estSauvegarde ? 'fas' : 'far'}" />
                            <c:set var="bookmarkColor" value="${article.estSauvegarde ? 'text-neon-cyan' : 'text-gray-400'}" />
                            
                            <form action="${pageContext.request.contextPath}${bookmarkAction}" method="post" class="inline">
                                ${csrfField}
                                <input type="hidden" name="articleId" value="${article.id}">
                                <button type="submit" class="${bookmarkColor} hover:text-neon-cyan transition-colors" title="${article.estSauvegarde ? 'Retirer' : 'Sauvegarder'}">
                                    <i class="${bookmarkIcon} fa-bookmark"></i>
                                </button>
                            </form>
                        </div>
                        
                        <!-- Post text preview -->
                        <p class="text-sm text-gray-300 mb-1">
                            <a href="${pageContext.request.contextPath}/profil?id=${article.auteur.id}" class="font-semibold text-white hover:underline no-underline mr-1">${article.auteur.prenom}</a>
                            <span class="line-clamp-2">${article.extrait}</span>
                        </p>

                        <!-- Comment count & Redirect -->
                        <a href="${pageContext.request.contextPath}/articles/voir?id=${article.id}" class="text-sm text-gray-500 hover:text-gray-400 transition-colors no-underline block mb-2">
                            Voir les ${article.commentairesCount} commentaires
                        </a>

                        <!-- Inline Comment Form -->
                        <c:if test="${not empty sessionScope.membre}">
                            <div class="mt-3 flex items-start gap-3">
                                <c:if test="${empty sessionScope.membre.avatar}">
                                    <div class="w-8 h-8 flex-shrink-0 rounded-full bg-dark-700 flex items-center justify-center text-[10px] text-white font-bold">
                                        ${sessionScope.membre.prenom.charAt(0)}${sessionScope.membre.nom.charAt(0)}
                                    </div>
                                </c:if>
                                <c:if test="${not empty sessionScope.membre.avatar}">
                                    <img src="${sessionScope.membre.avatar}" class="w-8 h-8 flex-shrink-0 rounded-full bg-dark-700 object-cover">
                                </c:if>
                                <form action="${pageContext.request.contextPath}/commentaires/ajouter" method="post" class="flex-1 relative">
                                    ${csrfField}
                                    <input type="hidden" name="article_id" value="${article.id}">
                                    <div class="flex items-center border-b border-white/5 pb-1 gap-2">
                                        <textarea name="contenu" rows="1" placeholder="Ajouter un commentaire..." 
                                                  class="w-full bg-transparent border-none focus:ring-0 text-sm placeholder-gray-500 text-white p-0 resize-none overflow-hidden" 
                                                  oninput="this.style.height = ''; this.style.height = this.scrollHeight + 'px'" required></textarea>
                                        
                                        <div class="relative flex items-center">
                                            <button type="button" onclick="toggleFeedEmojiPicker(this)" class="text-gray-500 hover:text-neon-green transition-colors">
                                                <i class="fas fa-smile text-base"></i>
                                            </button>
                                            <!-- Simple Emoji Picker for Feed -->
                                            <div class="feedEmojiPicker hidden absolute bottom-full right-0 mb-2 p-2 glass-strong border border-white/10 rounded-xl z-50 grid grid-cols-4 gap-1 shadow-2xl">
                                                <button type="button" onclick="addFeedEmoji(this, '😊')" class="text-sm">😊</button>
                                                <button type="button" onclick="addFeedEmoji(this, '🔥')" class="text-sm">🔥</button>
                                                <button type="button" onclick="addFeedEmoji(this, '🚀')" class="text-sm">🚀</button>
                                                <button type="button" onclick="addFeedEmoji(this, '💡')" class="text-sm">💡</button>
                                                <button type="button" onclick="addFeedEmoji(this, '💻')" class="text-sm">💻</button>
                                                <button type="button" onclick="addFeedEmoji(this, '✅')" class="text-sm">✅</button>
                                                <button type="button" onclick="addFeedEmoji(this, '❤️')" class="text-sm">❤️</button>
                                                <button type="button" onclick="addFeedEmoji(this, '🙌')" class="text-sm">🙌</button>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="text-neon-cyan text-sm font-bold opacity-0 group-focus-within/form:opacity-100 transition-opacity">Publier</button>
                                    </div>
                                </form>
                            </div>
                        </c:if>

                        <script>
                            function toggleFeedEmojiPicker(btn) {
                                const picker = btn.nextElementSibling;
                                const allPickers = document.querySelectorAll('.feedEmojiPicker');
                                allPickers.forEach(p => { if(p !== picker) p.classList.add('hidden'); });
                                picker.classList.toggle('hidden');
                            }

                            function addFeedEmoji(emojiBtn, emoji) {
                                const picker = emojiBtn.closest('.feedEmojiPicker');
                                const textarea = picker.closest('form').querySelector('textarea');
                                
                                const start = textarea.selectionStart;
                                const end = textarea.selectionEnd;
                                const value = textarea.value;
                                textarea.value = value.substring(0, start) + emoji + value.substring(end);
                                textarea.selectionStart = textarea.selectionEnd = start + emoji.length;
                                textarea.focus();
                                
                                textarea.style.height = '';
                                textarea.style.height = textarea.scrollHeight + 'px';
                                
                                picker.classList.add('hidden');
                            }
                            
                            // Close feed pickers on outside click
                            document.addEventListener('click', function(e) {
                                if (!e.target.closest('.feedEmojiPicker') && !e.target.closest('button[onclick^="toggleFeedEmojiPicker"]')) {
                                    document.querySelectorAll('.feedEmojiPicker').forEach(p => p.classList.add('hidden'));
                                }
                            });
                        </script>

                        <p class="text-[11px] text-gray-600 mt-2 uppercase tracking-wide">
                            <fmt:formatDate value="${article.datePublication}" pattern="dd MMM yyyy"/>
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <div class="p-8 text-center mb-10">
            <div class="inline-flex items-center gap-2 text-gray-500">
                <div class="w-2 h-2 bg-neon-cyan rounded-full animate-bounce"></div>
                <div class="w-2 h-2 bg-neon-purple rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
                <div class="w-2 h-2 bg-neon-pink rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
            </div>
            <c:if test="${totalPages > 1}">
                <div class="flex gap-2 justify-center mt-6">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}" class="w-8 h-8 flex items-center justify-center rounded-lg no-underline font-medium transition-colors ${pageCourante == i ? 'btn-neon text-white' : 'glass text-gray-400 hover:text-white hover:bg-white/10'}">${i}</a>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </c:if>
</div>

<%@ include file="footer.jsp" %>
