<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${not empty sessionScope.membre}">
        <jsp:forward page="/articles"/>
    </c:when>
    <c:otherwise>
        <jsp:forward page="/connexion"/>
    </c:otherwise>
</c:choose>
