<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${empty article ? 'Créer une publication' : 'Modifier la publication'}"/>
<%@ include file="header.jsp" %>

<fmt:setBundle basename="messages" var="msg" />

<!-- CREATE/EDIT POST -->
<div class="max-w-2xl mx-auto pt-6 px-4 pb-20">
    <div class="glass rounded-2xl p-6 border border-white/10 animate-scale-in">
        <h2 class="text-xl font-bold mb-6 text-white">
            <c:choose>
                <c:when test="${empty article}">Créer une publication</c:when>
                <c:otherwise>Modifier la publication</c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty erreur}">
            <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/30 text-red-400 flex items-center gap-3 text-sm">
                <i class="fas fa-exclamation-triangle"></i>
                <p>${erreur}</p>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty article}">
                <form method="post" action="${pageContext.request.contextPath}/articles/nouveau" class="space-y-4" enctype="multipart/form-data">
                    ${csrfField}
            </c:when>
            <c:otherwise>
                <form method="post" action="${pageContext.request.contextPath}/articles/modifier" class="space-y-4" enctype="multipart/form-data">
                    ${csrfField}
                    <input type="hidden" name="id" value="${article.id}">
            </c:otherwise>
        </c:choose>

            <div class="flex gap-4 mb-2">
                <div class="w-10 h-10 rounded-full neon-ring p-0.5 flex-shrink-0">
                    <c:if test="${empty sessionScope.membre.avatar}">
                        <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-xs font-bold text-white uppercase">
                            ${sessionScope.membre.prenom.charAt(0)}${sessionScope.membre.nom.charAt(0)}
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.membre.avatar}">
                        <img src="${sessionScope.membre.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                    </c:if>
                </div>
                <div class="flex-1">
                    <p class="font-medium text-white">${sessionScope.membre.prenom} ${sessionScope.membre.nom}</p>
                    <select name="module" class="bg-dark-700 text-sm text-gray-300 rounded-lg px-3 py-1 mt-1 border border-white/10 focus:outline-none focus:border-neon-cyan transition-colors">
                        <option value="Java" ${article.module == 'Java' ? 'selected' : ''}>Java</option>
                        <option value="Réseaux" ${article.module == 'Réseaux' ? 'selected' : ''}>Réseaux</option>
                        <option value="Développement Web" ${article.module == 'Développement Web' ? 'selected' : ''}>Développement Web</option>
                        <option value="Systèmes" ${article.module == 'Systèmes' ? 'selected' : ''}>Systèmes & OS</option>
                        <option value="Général" ${empty article.module || article.module == 'Général' ? 'selected' : ''}>Général</option>
                    </select>
                </div>
            </div>

            <div class="space-y-4 pt-2">
                <input type="text" name="titre" value="${article.titre}" placeholder="Titre de la publication" required autocomplete="off"
                       class="w-full bg-transparent text-lg font-bold placeholder-gray-500 focus:outline-none border-b border-white/10 pb-2 text-white transition-colors focus:border-neon-cyan">

                <textarea name="contenu" rows="6" placeholder="De quoi voulez-vous discuter ?" required
                          class="w-full bg-transparent text-base placeholder-gray-500 resize-none focus:outline-none text-white leading-relaxed pb-4 oninput="this.style.height = ''; this.style.height = this.scrollHeight + 'px'">${article.contenu}</textarea>
            </div>

            <!-- Image Preview -->
            <div id="imagePreviewContainer" class="hidden relative w-full rounded-xl overflow-hidden mb-4 bg-dark-800 flex justify-center items-center h-auto min-h-[150px] max-h-[400px]">
                <img id="imagePreview" src="" class="max-w-full max-h-[400px] object-contain rounded-xl">
                <button type="button" onclick="removeImage()" class="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/60 text-white flex items-center justify-center hover:bg-red-500 transition-colors backdrop-blur-sm z-10">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Real actions for upload -->
            <div class="flex items-center gap-6 p-4 border-y border-white/10 mb-4 mt-2 relative">
                <label class="text-neon-cyan hover:scale-110 transition-transform cursor-pointer" title="Ajouter une image">
                    <i class="fas fa-image text-xl"></i>
                    <input type="file" name="image" id="imageInput" accept="image/*" class="hidden" onchange="previewImage(this)">
                </label>
                
                <!-- Link Button -->
                <button type="button" onclick="insertLink()" class="text-neon-purple hover:scale-110 transition-transform" title="Ajouter un lien">
                    <i class="fas fa-link text-xl"></i>
                </button>
                
                <!-- Code Button -->
                <button type="button" onclick="insertCode()" class="text-neon-pink hover:scale-110 transition-transform" title="Insérer du code">
                    <i class="fas fa-code text-xl"></i>
                </button>
                
                <!-- Emoji Button & Picker -->
                <div class="relative">
                    <button type="button" onclick="toggleEmojiPicker()" class="text-neon-green hover:scale-110 transition-transform" title="Ajouter un emoji">
                        <i class="fas fa-smile text-xl"></i>
                    </button>
                    <!-- Simple Emoji Picker -->
                    <div id="emojiPicker" class="hidden absolute bottom-full left-0 mb-4 p-3 glass-strong border border-white/10 rounded-2xl z-50 grid grid-cols-6 gap-2 w-48 shadow-2xl">
                        <button type="button" onclick="addEmoji('😊')" class="hover:scale-125 transition-transform">😊</button>
                        <button type="button" onclick="addEmoji('🔥')" class="hover:scale-125 transition-transform">🔥</button>
                        <button type="button" onclick="addEmoji('🚀')" class="hover:scale-125 transition-transform">🚀</button>
                        <button type="button" onclick="addEmoji('💻')" class="hover:scale-125 transition-transform">💻</button>
                        <button type="button" onclick="addEmoji('✨')" class="hover:scale-125 transition-transform">✨</button>
                        <button type="button" onclick="addEmoji('❤️')" class="hover:scale-125 transition-transform">❤️</button>
                        <button type="button" onclick="addEmoji('👍')" class="hover:scale-125 transition-transform">👍</button>
                        <button type="button" onclick="addEmoji('😂')" class="hover:scale-125 transition-transform">😂</button>
                        <button type="button" onclick="addEmoji('🙌')" class="hover:scale-125 transition-transform">🙌</button>
                        <button type="button" onclick="addEmoji('⚡')" class="hover:scale-125 transition-transform">⚡</button>
                        <button type="button" onclick="addEmoji('✅')" class="hover:scale-125 transition-transform">✅</button>
                        <button type="button" onclick="addEmoji('👀')" class="hover:scale-125 transition-transform">👀</button>
                    </div>
                </div>
            </div>

            <script>
                const textarea = document.querySelector('textarea[name="contenu"]');

                function insertAtCursor(text) {
                    const start = textarea.selectionStart;
                    const end = textarea.selectionEnd;
                    const value = textarea.value;
                    textarea.value = value.substring(0, start) + text + value.substring(end);
                    textarea.selectionStart = textarea.selectionEnd = start + text.length;
                    textarea.focus();
                }

                function insertLink() {
                    const url = prompt("Entrez l'URL du lien :");
                    if (url) {
                        const selection = textarea.value.substring(textarea.selectionStart, textarea.selectionEnd);
                        const text = selection || "Lien";
                        insertAtCursor(`[${text}](${url})`);
                    }
                }

                function insertCode() {
                    const selection = textarea.value.substring(textarea.selectionStart, textarea.selectionEnd);
                    if (selection) {
                        insertAtCursor("```\n" + selection + "\n```");
                    } else {
                        insertAtCursor("```\n\n```");
                        textarea.selectionStart = textarea.selectionEnd = textarea.selectionStart - 4;
                    }
                }

                function toggleEmojiPicker() {
                    document.getElementById('emojiPicker').classList.toggle('hidden');
                }

                function addEmoji(emoji) {
                    insertAtCursor(emoji);
                    toggleEmojiPicker();
                }

                function previewImage(input) {
                    if (input.files && input.files[0]) {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            document.getElementById('imagePreview').src = e.target.result;
                            document.getElementById('imagePreviewContainer').classList.remove('hidden');
                        }
                        reader.readAsDataURL(input.files[0]);
                    }
                }
                function removeImage() {
                    document.getElementById('imageInput').value = '';
                    document.getElementById('imagePreview').src = '';
                    document.getElementById('imagePreviewContainer').classList.add('hidden');
                }

                // Handle clicking outside emoji picker to close it
                document.addEventListener('click', function(e) {
                   const picker = document.getElementById('emojiPicker');
                   const emojiBtn = document.querySelector('button[onclick="toggleEmojiPicker()"]');
                   if (!picker.contains(e.target) && e.target !== emojiBtn && !emojiBtn.contains(e.target)) {
                       picker.classList.add('hidden');
                   }
                });
            </script>

            <div class="flex justify-end gap-4 mt-6">
                <a href="${pageContext.request.contextPath}/" class="py-3 px-6 rounded-xl glass text-white font-medium hover:bg-white/10 transition-colors">
                    Annuler
                </a>
                <button type="submit" class="py-3 px-8 rounded-xl btn-neon text-white font-bold pr-10 relative">
                    <c:choose>
                        <c:when test="${empty article}">Publier </c:when>
                        <c:otherwise>Mettre à jour</c:otherwise>
                    </c:choose>
                    <i class="fas fa-paper-plane absolute right-4 top-1/2 -translate-y-1/2"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>
