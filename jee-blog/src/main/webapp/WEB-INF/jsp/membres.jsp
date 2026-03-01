<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Découvrir des membres"/>
<%@ include file="header.jsp" %>

<div class="max-w-2xl mx-auto pt-6 px-4">
    <div class="flex items-center justify-between mb-8">
        <h2 class="text-2xl font-bold text-white">Découvrir des membres</h2>
        <span class="text-sm text-gray-500">${membres.size()} membres trouvés</span>
    </div>

    <c:if test="${empty membres}">
        <div class="glass rounded-2xl p-12 text-center border border-white/10">
            <i class="fas fa-users text-5xl mb-4 text-cyan-500/30"></i>
            <p class="text-gray-400">Aucun autre membre n'a été trouvé.</p>
        </div>
    </c:if>

    <div class="grid grid-cols-1 gap-4">
        <c:forEach var="m" items="${membres}">
            <div class="glass p-4 rounded-2xl border border-white/10 flex items-center justify-between group hover:bg-white/5 transition-all">
                <div class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/profil?id=${m.id}" class="w-14 h-14 rounded-full neon-ring p-0.5 relative">
                        <c:if test="${empty m.avatar}">
                            <div class="w-full h-full rounded-full bg-dark-700 flex items-center justify-center text-lg text-white font-bold">
                                ${m.prenom.charAt(0)}${m.nom.charAt(0)}
                            </div>
                        </c:if>
                        <c:if test="${not empty m.avatar}">
                            <img src="${m.avatar}" class="w-full h-full rounded-full bg-dark-700 object-cover">
                        </c:if>
                    </a>
                    <div>
                        <a href="${pageContext.request.contextPath}/profil?id=${m.id}" class="font-bold text-white hover:text-neon-cyan transition-colors no-underline">
                            ${m.prenom} ${m.nom}
                        </a>
                        <p class="text-xs text-gray-500 mt-0.5">@${m.prenom.toLowerCase()}_${m.nom.toLowerCase()}</p>
                        <c:if test="${not empty m.bio}">
                            <p class="text-sm text-gray-400 mt-1 line-clamp-1">${m.bio}</p>
                        </c:if>
                    </div>
                </div>

                <div class="flex items-center gap-2">
                    <c:if test="${not empty sessionScope.membre}">
                        <form action="${pageContext.request.contextPath}/follow" method="post" class="inline">
                            ${csrfField}
                            <input type="hidden" name="id" value="${m.id}">
                            <button type="submit" class="px-6 py-2 rounded-full text-sm font-bold transition-all ${m.estSuivi ? 'bg-dark-700 text-gray-300 hover:bg-red-500/20 hover:text-red-400 border border-white/10' : 'btn-neon text-white shadow-lg shadow-cyan-500/20'}">
                                ${m.estSuivi ? 'Suivi(e)' : 'Suivre'}
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${empty sessionScope.membre}">
                        <a href="${pageContext.request.contextPath}/connexion" class="px-6 py-2 btn-neon rounded-full text-sm font-bold text-white shadow-lg shadow-cyan-500/20">
                            Suivre
                        </a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="footer.jsp" %>
