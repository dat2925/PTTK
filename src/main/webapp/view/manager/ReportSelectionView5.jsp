<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/manager.jspf" %>
<% request.setAttribute("pageTitle", "Chọn báo cáo"); %>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Chọn báo cáo</h1>
<ul class="report-types">
    <li>Thống kê phim</li>
    <li><a href="<c:url value='/view/manager/CustomerRevenueDateRangeView5.jsp'/>">Thống kê khách hàng theo doanh thu</a></li>
    <li>Thống kê doanh thu</li>
</ul>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
