<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (session.getAttribute("member") != null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    WebSupport.formToken(session);
    request.setAttribute("pageTitle", "Đăng nhập");
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Đăng nhập</h1>
<c:if test="${not empty loginError}">
    <p class="message error" role="alert"><c:out value="${loginError}"/></p>
</c:if>
<form class="login-form" action="<c:url value='/doLogin.jsp'/>" method="post">
    <input type="hidden" name="token" value="<c:out value='${sessionScope.formToken}'/>">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" value="<c:out value='${username}'/>"
           required maxlength="255" autocomplete="username">
    <label for="password">Mật khẩu</label>
    <input type="password" id="password" name="password" required maxlength="128" autocomplete="current-password">
    <button class="primary" type="submit">Đăng nhập</button>
</form>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
