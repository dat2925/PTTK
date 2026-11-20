<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/manager.jspf" %>
<% request.setAttribute("pageTitle", "Trang chủ quản lý"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Trang chủ quản lý</h1>
<a class="button primary home-action" href="<c:url value='/view/manager/ReportSelectionView5.jsp'/>">Xem báo cáo</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
