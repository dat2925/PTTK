<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/customer.jspf" %>
<% request.setAttribute("pageTitle", "Trang chủ khách hàng"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Trang chủ khách hàng</h1>
<a class="button primary home-action" href="<c:url value='/view/customer/MovieSearchView5.jsp'/>">Tìm thông tin phim</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
