<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Publication - ${article.titre}"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<div class="max-w-2xl mx-auto pt-6 px-4 pb-20">
    
    <a href="${pageContext.request.contextPath}/" class="mb-6 flex items-center gap-2 text-gray-400 hover:text-neon-cyan transition-colors group inline-flex w-fit font-medium">
        <i class="fas fa-arrow-left group-hover:-translate-x-1 transition-transform text-sm"></i>
        Retour
    </a>

    <!-- POST => Article Container -->
    <article class="post-item glass rounded-2xl border border-white/10 overflow-hidden mb-8">
        <!-- Post Header -->
        <div class="p-4 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-full neon-ring p-0.5">
                    <c:if test="${empty article.auteur.avatar}">
                        <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-sm text-white font-bold">
                            ${article.auteur.prenom.charAt(0)}${article.auteur.nom.charAt(0)}
                        </div>
                    </c:if>
                    <c:if test="${not empty article.auteur.avatar}">
                        <img src="${article.auteur.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                    </c:if>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/profil?id=${article.auteur.id}" class="font-bold text-base hover:underline text-white">${article.auteur.prenom} ${article.auteur.nom}</a>
                    <p class="text-xs text-gray-400">
                        <fmt:formatDate value="${article.datePublication}" pattern="dd MMM yyyy à HH:mm"/>
                    </p>
                </div>
            </div>
            
            <c:if test="${not empty sessionScope.membre && sessionScope.membre.id == article.membreId}">
                <div class="flex gap-2">
                    <a href="${pageContext.request.contextPath}/articles/modifier?id=${article.id}" class="text-gray-400 hover:text-neon-cyan p-2 transition-colors">
                        <i class="fas fa-pen"></i>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/articles/supprimer" onsubmit="return confirm('Supprimer cette publication ?')" class="inline">
                        ${csrfField}
                        <input type="hidden" name="id" value="${article.id}">
                        <button type="submit" class="text-gray-400 hover:text-red-400 p-2 transition-colors">
                            <i class="fas fa-trash"></i>
                        </button>
                    </form>
                </div>
            </c:if>
            <c:if test="${empty sessionScope.membre || sessionScope.membre.id != article.membreId}">
                <button class="text-gray-400 hover:text-white transition-colors">
                    <i class="fas fa-ellipsis-h"></i>
                </button>
            </c:if>
        </div>

        <!-- Content -->
        <div class="px-4 pb-4">
            <span class="inline-block px-3 py-1 rounded-full bg-dark-800 text-neon-purple text-xs font-bold border border-purple-500/30 mb-4">
                #${article.module}
            </span>
            <h1 class="text-xl md:text-2xl font-bold text-white mb-4 leading-snug">${article.titre}</h1>
            
            <div class="prose prose-invert prose-p:text-gray-300 prose-headings:text-white max-w-none text-sm md:text-base leading-relaxed whitespace-pre-line mb-4">
                ${article.contenu}
            </div>
        </div>

        <!-- Image if any -->
        <c:if test="${not empty article.image}">
            <div class="w-full bg-dark-900 flex justify-center border-y border-white/5">
                <img src="${article.image}" class="max-h-[600px] w-full object-cover" alt="Image publication">
            </div>
        </c:if>

        <!-- Stats line -->
        <div class="px-4 py-3 flex items-center justify-between text-xs font-medium text-gray-400 border-t border-white/5">
            <span>${article.vues} vues</span>
            <span>${commentaires.size()} réponses</span>
        </div>

        <!-- Actions -->
        <div class="p-4 border-t border-white/10 flex items-center gap-6 text-2xl">
             <form action="${pageContext.request.contextPath}/like" method="post" class="inline">
                ${csrfField}
                <input type="hidden" name="articleId" value="${article.id}">
                <input type="hidden" name="from" value="detail">
                <button type="submit" class="text-gray-400 hover:text-neon-pink transition-colors group flex items-center gap-2">
                    <i class="far fa-heart group-hover:scale-125 transition-transform duration-300"></i>
                </button>
            </form>
            
            <a href="#respond" class="text-gray-400 hover:text-neon-cyan transition-colors group flex items-center gap-2 no-underline">
                <i class="far fa-comment group-hover:scale-125 transition-transform duration-300"></i>
            </a>
            
            <button class="text-gray-400 hover:text-neon-green transition-colors group">
                <i class="far fa-paper-plane group-hover:-translate-y-1 group-hover:translate-x-1 transition-transform duration-300"></i>
            </button>
            
            <div class="flex-1"></div>
            
            <c:set var="bookmarkAction" value="${article.estSauvegarde ? '/collection/retirer' : '/collection/sauvegarder'}" />
            <c:set var="bookmarkIcon" value="${article.estSauvegarde ? 'fas' : 'far'}" />
            <c:set var="bookmarkColor" value="${article.estSauvegarde ? 'text-neon-cyan' : 'text-gray-400'}" />

            <form action="${pageContext.request.contextPath}${bookmarkAction}" method="post" class="inline">
                ${csrfField}
                <input type="hidden" name="articleId" value="${article.id}">
                <button type="submit" class="${bookmarkColor} hover:text-neon-cyan transition-colors group" title="${article.estSauvegarde ? 'Retirer' : 'Sauvegarder'}">
                    <i class="${bookmarkIcon} fa-bookmark group-hover:scale-110 transition-transform"></i>
                </button>
            </form>
        </div>
    </article>

    <!-- Comments Section (Réponses) -->
    <div class="mt-8" id="respond">
        <h3 class="text-lg font-bold mb-6 text-white border-b border-white/10 pb-2">Réponses (${commentaires.size()})</h3>

        <!-- Add Comment Form -->
        <c:if test="${not empty sessionScope.membre}">
            <div class="flex gap-4 mb-8">
                <div class="w-10 h-10 rounded-full flex-shrink-0 neon-ring p-0.5">
                    <c:if test="${empty sessionScope.membre.avatar}">
                        <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-xs text-white font-bold">
                            ${sessionScope.membre.prenom.charAt(0)}${sessionScope.membre.nom.charAt(0)}
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.membre.avatar}">
                        <img src="${sessionScope.membre.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                    </c:if>
                </div>
                
                <form method="post" action="${pageContext.request.contextPath}/commentaires/ajouter" class="flex-1">
                    ${csrfField}
                    <input type="hidden" name="article_id" value="${article.id}">
                    <textarea id="commentTextarea" name="contenu" rows="1" class="w-full bg-transparent border-b border-white/20 pb-2 text-white placeholder-gray-500 focus:outline-none focus:border-neon-cyan transition-colors resize-none overflow-hidden" placeholder="Ajouter un commentaire..." required oninput="this.style.height = ''; this.style.height = this.scrollHeight + 'px'"></textarea>
                    
                    <div class="mt-2 flex items-center justify-between">
                        <div class="flex items-center gap-4 relative">
                            <!-- Link Button -->
                            <button type="button" onclick="insertCommentLink()" class="text-neon-purple hover:scale-110 transition-transform" title="Ajouter un lien">
                                <i class="fas fa-link text-lg"></i>
                            </button>
                            <!-- Code Button -->
                            <button type="button" onclick="insertCommentCode()" class="text-neon-pink hover:scale-110 transition-transform" title="Insérer du code">
                                <i class="fas fa-code text-lg"></i>
                            </button>
                            <!-- Emoji Button & Picker -->
                            <div class="relative">
                                <button type="button" onclick="toggleCommentEmojiPicker()" class="text-neon-green hover:scale-110 transition-transform" title="Ajouter un emoji">
                                    <i class="fas fa-smile text-lg"></i>
                                </button>
                                <!-- Simple Emoji Picker -->
                                <div id="commentEmojiPicker" class="hidden absolute bottom-full left-0 mb-4 p-3 glass-strong border border-white/10 rounded-2xl z-50 grid grid-cols-6 gap-2 w-48 shadow-2xl">
                                    <button type="button" onclick="addCommentEmoji('😊')" class="hover:scale-125 transition-transform">😊</button>
                                    <button type="button" onclick="addCommentEmoji('🔥')" class="hover:scale-125 transition-transform">🔥</button>
                                    <button type="button" onclick="addCommentEmoji('🚀')" class="hover:scale-125 transition-transform">🚀</button>
                                    <button type="button" onclick="addCommentEmoji('💻')" class="hover:scale-125 transition-transform">💻</button>
                                    <button type="button" onclick="addCommentEmoji('✨')" class="hover:scale-125 transition-transform">✨</button>
                                    <button type="button" onclick="addCommentEmoji('❤️')" class="hover:scale-125 transition-transform">❤️</button>
                                    <button type="button" onclick="addCommentEmoji('👍')" class="hover:scale-125 transition-transform">👍</button>
                                    <button type="button" onclick="addCommentEmoji('😂')" class="hover:scale-125 transition-transform">😂</button>
                                    <button type="button" onclick="addCommentEmoji('🙌')" class="hover:scale-125 transition-transform">🙌</button>
                                    <button type="button" onclick="addCommentEmoji('⚡')" class="hover:scale-125 transition-transform">⚡</button>
                                    <button type="button" onclick="addCommentEmoji('✅')" class="hover:scale-125 transition-transform">✅</button>
                                    <button type="button" onclick="addEmoji('👀')" class="hover:scale-125 transition-transform">👀</button>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="px-5 py-1.5 btn-neon text-white text-sm font-bold rounded-full">
                            Publier
                        </button>
                    </div>
                </form>

                <script>
                    const commentArea = document.getElementById('commentTextarea');

                    function insertAtCommentCursor(text) {
                        const start = commentArea.selectionStart;
                        const end = commentArea.selectionEnd;
                        const value = commentArea.value;
                        commentArea.value = value.substring(0, start) + text + value.substring(end);
                        commentArea.selectionStart = commentArea.selectionEnd = start + text.length;
                        commentArea.focus();
                        // Adjust height
                        commentArea.style.height = '';
                        commentArea.style.height = commentArea.scrollHeight + 'px';
                    }

                    function insertCommentLink() {
                        const url = prompt("Entrez l'URL du lien :");
                        if (url) {
                            const selection = commentArea.value.substring(commentArea.selectionStart, commentArea.selectionEnd);
                            const text = selection || "Lien";
                            insertAtCommentCursor(`[${text}](${url})`);
                        }
                    }

                    function insertCommentCode() {
                        const selection = commentArea.value.substring(commentArea.selectionStart, commentArea.selectionEnd);
                        if (selection) {
                            insertAtCommentCursor("```\n" + selection + "\n```");
                        } else {
                            insertAtCommentCursor("```\n\n```");
                            commentArea.selectionStart = commentArea.selectionEnd = commentArea.selectionStart - 4;
                        }
                    }

                    function toggleCommentEmojiPicker() {
                        document.getElementById('commentEmojiPicker').classList.toggle('hidden');
                    }

                    function addCommentEmoji(emoji) {
                        insertAtCommentCursor(emoji);
                        toggleCommentEmojiPicker();
                    }

                    // Handle clicking outside comment emoji picker to close it
                    document.addEventListener('click', function(e) {
                       const picker = document.getElementById('commentEmojiPicker');
                       const emojiBtn = document.querySelector('button[onclick="toggleCommentEmojiPicker()"]');
                       if (picker && !picker.contains(e.target) && e.target !== emojiBtn && !emojiBtn.contains(e.target)) {
                           picker.classList.add('hidden');
                       }
                    });
                </script>
            </div>
        </c:if>
        
        <c:if test="${empty sessionScope.membre}">
            <div class="glass rounded-xl p-4 text-center mb-8 border border-white/10">
                <p class="text-gray-400 mb-2">Connectez-vous pour participer à la discussion.</p>
                <a href="${pageContext.request.contextPath}/connexion" class="font-bold text-neon-cyan hover:underline">Se connecter</a>
            </div>
        </c:if>

        <!-- Comments List -->
        <div class="space-y-6">
            <c:if test="${empty commentaires}">
                <div class="text-center py-6">
                    <p class="text-gray-500 text-sm">Pas encore de réponses. Soyez le premier !</p>
                </div>
            </c:if>
            
            <c:forEach var="com" items="${commentaires}">
                <div class="flex gap-3 glass p-4 rounded-xl border border-white/5">
                    <a href="${pageContext.request.contextPath}/profil?id=${com.auteur.id}" class="w-10 h-10 rounded-full flex-shrink-0 border border-white/20 p-0.5 cursor-pointer hover:border-neon-cyan transition-colors">
                        <c:if test="${empty com.auteur.avatar}">
                            <div class="w-full h-full rounded-full bg-dark-800 flex items-center justify-center text-xs text-white font-bold">
                                ${com.auteur.prenom.charAt(0)}${com.auteur.nom.charAt(0)}
                            </div>
                        </c:if>
                        <c:if test="${not empty com.auteur.avatar}">
                            <img src="${com.auteur.avatar}" class="w-full h-full rounded-full bg-dark-800 object-cover">
                        </c:if>
                    </a>
                    
                    <div class="flex-1 min-w-0">
                        <div class="flex items-center justify-between gap-2 mb-1">
                            <a href="${pageContext.request.contextPath}/profil?id=${com.auteur.id}" class="font-bold text-sm text-gray-200 hover:text-white transition-colors truncate">
                                ${com.auteur.prenom} ${com.auteur.nom}
                            </a>
                            <span class="text-xs text-gray-500 flex-shrink-0"><fmt:formatDate value="${com.dateCommentaire}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        
                        <p class="text-gray-300 text-sm whitespace-pre-wrap leading-relaxed">${com.contenu}</p>
                        
                        <div class="mt-2 flex items-center gap-4 text-xs font-medium text-gray-500">
                            <button class="hover:text-neon-pink transition-colors">J'aime</button>
                            <button class="hover:text-white transition-colors">Répondre</button>
                            
                            <c:if test="${not empty sessionScope.membre && sessionScope.membre.id == com.membreId}">
                                <form method="post" action="${pageContext.request.contextPath}/commentaires/supprimer" onsubmit="return confirm('Supprimer ce commentaire ?')" class="inline ml-auto">
                                    ${csrfField}
                                    <input type="hidden" name="id" value="${com.id}">
                                    <input type="hidden" name="article_id" value="${article.id}">
                                    <button type="submit" class="text-red-400 hover:text-red-300 transition-colors border border-red-500/30 bg-red-500/10 px-2 py-1 rounded">Supprimer</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
