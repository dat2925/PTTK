<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/manager.jspf" %>
<%
    request.setAttribute("pageTitle", "Thống kê khách hàng theo doanh thu");
    String start = request.getParameter("startDate");
    String end = request.getParameter("endDate");
    if (start == null && end == null && request.getAttribute("dateError") == null) {
        start = "2026-11-01";
        end = "2026-11-15";
    }
    request.setAttribute("startDate", start);
    request.setAttribute("endDate", end);
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Thống kê khách hàng theo doanh thu</h1>
<c:if test="${not empty dateError}">
    <p class="message error" role="alert"><c:out value="${dateError}"/></p>
</c:if>
<form class="form-row date-form" action="<c:url value='/view/manager/CustomerRevenueResultsView5.jsp'/>" method="get" novalidate>
    <div>
        <label for="startDate">Ngày bắt đầu</label>
        <input type="date" id="startDate" name="startDate" required
               min="1000-01-01" max="9999-12-31" value="<c:out value='${startDate}'/>">
    </div>
    <div>
        <label for="endDate">Ngày kết thúc</label>
        <input type="date" id="endDate" name="endDate" required
               min="1000-01-01" max="9999-12-31" value="<c:out value='${endDate}'/>">
    </div>
    <button class="primary" type="submit">Xem thống kê</button>
</form>
<a class="button secondary back" href="<c:url value='/view/manager/ReportSelectionView5.jsp'/>">Quay lại</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
