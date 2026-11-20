<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/customer.jspf" %>
<%
    request.setAttribute("pageTitle", "Tìm kiếm thông tin phim");
    String title = WebSupport.trim(request.getParameter("title"));
    request.setAttribute("keyword", title.length() <= 255 ? title : "");
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Tìm kiếm thông tin phim</h1>
<%@ include file="/WEB-INF/jspf/movie-search.jspf" %>
<c:if test="${not empty message}">
    <p class="message error" role="alert"><c:out value="${message}"/></p>
</c:if>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
