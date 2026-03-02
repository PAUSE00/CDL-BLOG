<%@ page pageEncoding="UTF-8" %>
        </main>
        <!-- MAIN CONTENT AREA ends here -->

        <!-- RIGHT SIDEBAR (Suggestions) -->
        <aside class="hidden lg:block p-6 border-l border-white/10 sticky top-0 h-screen overflow-y-auto">
            
            <c:if test="${not empty sessionScope.membre}">
                <!-- User Mini Profile -->
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center gap-3">
                        <c:if test="${empty sessionScope.membre.avatar}">
                            <div class="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-400 to-purple-500 flex items-center justify-center text-lg font-bold text-white uppercase shadow-lg shadow-cyan-500/20 neon-ring p-1">
                                ${sessionScope.membre.prenom.charAt(0)}${sessionScope.membre.nom.charAt(0)}
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.membre.avatar}">
                            <img src="${sessionScope.membre.avatar}" class="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-400 to-purple-500 p-0.5 neon-ring">
                        </c:if>
                        
                        <div>
                            <a href="${pageContext.request.contextPath}/profil" class="font-semibold text-sm hover:underline text-white no-underline block">${sessionScope.membre.prenom} ${sessionScope.membre.nom}</a>
                            <p class="text-gray-500 text-xs">${sessionScope.membre.prenom} ${sessionScope.membre.nom}</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/deconnexion" class="text-neon-cyan text-xs font-bold hover:text-cyan-300 transition-colors no-underline">Basculer</a>
                </div>
            </c:if>

            <!-- Suggestions pour vous -->
            <c:if test="${not empty sessionScope.membre}">
                <div class="mb-6">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-bold text-gray-400">Suggestions pour vous</h3>
                        <a href="${pageContext.request.contextPath}/membres" class="text-xs text-white font-bold hover:text-gray-300 transition-colors no-underline">Voir tout</a>
                    </div>
                    <div class="space-y-3">
                        <c:forEach var="sug" items="${suggestionsMembre}">
                            <div class="flex items-center justify-between group">
                                <div class="flex items-center gap-3">
                                    <a href="${pageContext.request.contextPath}/profil?id=${sug.id}" class="w-9 h-9 rounded-full bg-gradient-to-br from-cyan-400 to-purple-500 flex items-center justify-center text-xs font-bold text-white uppercase no-underline">
                                        <c:if test="${empty sug.avatar}">
                                            ${sug.prenom.charAt(0)}${sug.nom.charAt(0)}
                                        </c:if>
                                        <c:if test="${not empty sug.avatar}">
                                            <img src="${sug.avatar}" class="w-full h-full rounded-full object-cover">
                                        </c:if>
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/profil?id=${sug.id}" class="text-sm font-semibold text-white hover:underline no-underline block">${sug.prenom} ${sug.nom}</a>
                                        <p class="text-[11px] text-gray-500">Nouveau sur CDL BLOG</p>
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/follow" method="post" class="inline">
                                    ${csrfField}
                                    <input type="hidden" name="id" value="${sug.id}">
                                    <button type="submit" class="text-neon-cyan text-xs font-bold hover:text-cyan-300 transition-colors">Suivre</button>
                                </form>
                            </div>
                        </c:forEach>
                        <c:if test="${empty suggestionsMembre}">
                            <p class="text-xs text-gray-600 italic">Pas de nouvelles suggestions.</p>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Tendances (Trending) -->
            <div class="glass rounded-2xl p-4 border border-white/10 mb-6">
                <h3 class="font-bold mb-4 flex items-center gap-2">
                    <i class="fas fa-fire text-neon-pink"></i>
                    Tendances
                </h3>
                <div class="space-y-4">
                    <a href="#" class="flex items-center justify-between cursor-pointer group no-underline">
                        <div>
                            <p class="text-xs text-gray-500">Technologie</p>
                            <p class="text-sm font-bold text-white group-hover:text-neon-cyan transition-colors">#Java21</p>
                            <p class="text-[11px] text-gray-600">2.4k posts</p>
                        </div>
                        <i class="fas fa-chevron-right text-gray-600 text-xs group-hover:text-neon-cyan transition-colors"></i>
                    </a>
                    <a href="#" class="flex items-center justify-between cursor-pointer group no-underline">
                        <div>
                            <p class="text-xs text-gray-500">Design</p>
                            <p class="text-sm font-bold text-white group-hover:text-neon-cyan transition-colors">#NeonUI</p>
                            <p class="text-[11px] text-gray-600">1.8k posts</p>
                        </div>
                        <i class="fas fa-chevron-right text-gray-600 text-xs group-hover:text-neon-cyan transition-colors"></i>
                    </a>
                    <a href="#" class="flex items-center justify-between cursor-pointer group no-underline">
                        <div>
                            <p class="text-xs text-gray-500">D&eacute;veloppement</p>
                            <p class="text-sm font-bold text-white group-hover:text-neon-cyan transition-colors">#SpringBoot</p>
                            <p class="text-[11px] text-gray-600">956 posts</p>
                        </div>
                        <i class="fas fa-chevron-right text-gray-600 text-xs group-hover:text-neon-cyan transition-colors"></i>
                    </a>
                </div>
            </div>

            <div class="text-xs text-gray-600 mt-8 space-y-2">
                <div class="flex flex-wrap gap-x-2 gap-y-1">
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">&Agrave; propos</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Aide</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Presse</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">API</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Emplois</a>
                </div>
                <div class="flex flex-wrap gap-x-2 gap-y-1">
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Confidentialit&eacute;</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Conditions</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Localisations</a> &bull;
                    <a href="#" class="hover:text-gray-400 transition-colors no-underline">Langue</a>
                </div>
                <div class="flex items-center justify-between mt-4">
                    <div class="flex items-center gap-4">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-globe"></i>
                            <span class="uppercase">${sessionScope.langue}</span>
                        </div>
                        <div class="flex gap-2">
                            <a href="?lang=fr" class="hover:text-cyan-400 transition-colors no-underline ${sessionScope.langue == 'fr' ? 'text-cyan-400 font-bold' : ''}">FR</a>
                            <span>|</span>
                            <a href="?lang=en" class="hover:text-cyan-400 transition-colors no-underline ${sessionScope.langue == 'en' ? 'text-cyan-400 font-bold' : ''}">EN</a>
                        </div>
                    </div>
                </div>
                <p class="text-gray-700 mt-2">&copy; 2024 NEONBLOG FROM META</p>
            </div>

        </aside>

    </div><!-- END MAIN APP CONTAINER -->

    <!-- MOBILE BOTTOM NAVIGATION -->
    <nav class="lg:hidden fixed bottom-0 w-full glass border-t border-white/10 z-50 pb-safe">
        <div class="flex justify-around items-center h-16 px-4">
            <a href="${pageContext.request.contextPath}/" class="bottom-nav-item active text-white hover:text-neon-cyan transition-colors">
                <i class="fas fa-home text-2xl drop-shadow-[0_0_8px_rgba(0,243,255,0.8)]"></i>
            </a>
            <a href="${pageContext.request.contextPath}/articles/nouveau" class="bottom-nav-item text-gray-400 hover:text-white transition-colors">
                <i class="far fa-plus-square text-2xl"></i>
            </a>
            <c:if test="${not empty sessionScope.membre}">
                <a href="${pageContext.request.contextPath}/messages" class="bottom-nav-item text-gray-400 hover:text-white transition-colors">
                    <i class="far fa-paper-plane text-2xl"></i>
                </a>
                <a href="${pageContext.request.contextPath}/profil" class="bottom-nav-item text-gray-400 hover:text-white transition-colors">
                    <i class="far fa-user text-2xl"></i>
                </a>
            </c:if>
            <c:if test="${empty sessionScope.membre}">
                <a href="${pageContext.request.contextPath}/connexion" class="bottom-nav-item text-gray-400 hover:text-white transition-colors">
                    <i class="fas fa-sign-in-alt text-2xl"></i>
                </a>
            </c:if>
        </div>
    </nav>

    <!-- Scripts utiles -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = 'fixed top-4 left-1/2 -translate-x-1/2 glass-strong px-6 py-3 rounded-full z-[9999] flex items-center gap-2 border border-white/10 transition-all duration-500 ease-out transform -translate-y-full opacity-0';
            toast.innerHTML = `
                <i class="fas \${type === 'success' ? 'fa-check-circle text-neon-green' : 'fa-exclamation-circle text-neon-pink'}"></i>
                <span class="text-sm font-medium">\${message}</span>
            `;
            document.body.appendChild(toast);
            
            // Animation In
            requestAnimationFrame(() => {
                toast.classList.remove('-translate-y-full', 'opacity-0');
            });
            
            // Animation Out
            setTimeout(() => {
                toast.classList.add('-translate-y-full', 'opacity-0');
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }
    </script>
</body>
</html>
