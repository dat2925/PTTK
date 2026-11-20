<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/manager.jspf" %>
<%@ page import="dao.CustomerRevenueStatistic5DAO,web.ReportPeriod" %>
<%
    ReportPeriod period;
    try {
        period = ReportPeriod.from(request.getParameter("startDate"), request.getParameter("endDate"));
    } catch (IllegalArgumentException ex) {
        request.setAttribute("dateError", ex.getMessage());
        request.getRequestDispatcher("/view/manager/CustomerRevenueDateRangeView5.jsp").forward(request, response);
        return;
    }

    request.setAttribute("pageTitle", "Thống kê khách hàng theo doanh thu");
    period.expose(request);
    request.setAttribute("rows", new CustomerRevenueStatistic5DAO()
            .getCustomerRevenue(period.startDate(), period.endDate()));
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<fmt:setLocale value="vi_VN"/>
<h1>Thống kê khách hàng theo doanh thu</h1>
<%@ include file="/WEB-INF/jspf/period.jspf" %>
<div class="table-wrap">
    <table aria-label="Thống kê khách hàng theo doanh thu">
        <thead>
        <tr><th scope="col">Mã khách hàng</th><th scope="col">Họ tên</th>
            <th scope="col">Tổng tiền (đồng)</th><th scope="col">Chọn</th></tr>
        </thead>
        <tbody>
        <c:forEach var="row" items="${rows}">
            <c:url var="detail" value="/view/manager/CustomerTransactionDetailsView5.jsp">
                <c:param name="customerId" value="${row.id}"/>
                <c:param name="startDate" value="${startDate}"/>
                <c:param name="endDate" value="${endDate}"/>
            </c:url>
            <tr>
                <td class="center"><c:out value="${row.code}"/></td>
                <td><c:out value="${row.name}"/></td>
                <td class="number"><fmt:formatNumber value="${row.totalAmount}" maxFractionDigits="2"/></td>
                <td class="action-cell"><a href="<c:out value='${detail}'/>">Xem chi tiết</a></td>
            </tr>
        </c:forEach>
        <c:if test="${empty rows}">
            <tr><td colspan="4">Không có dữ liệu thống kê.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
<c:url var="back" value="/view/manager/CustomerRevenueDateRangeView5.jsp">
    <c:param name="startDate" value="${startDate}"/>
    <c:param name="endDate" value="${endDate}"/>
</c:url>
<a class="button secondary back" href="<c:out value='${back}'/>">Quay lại</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
