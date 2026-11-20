<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/manager.jspf" %>
<%@ page import="dao.Member5DAO,dao.TicketPurchaseTransaction5DAO,model.Customer5,model.TicketPurchaseTransaction5,web.ReportPeriod,java.math.BigDecimal" %>
<%
    ReportPeriod period;
    try {
        period = ReportPeriod.from(request.getParameter("startDate"), request.getParameter("endDate"));
    } catch (IllegalArgumentException ex) {
        request.setAttribute("dateError", ex.getMessage());
        request.getRequestDispatcher("/view/manager/CustomerRevenueDateRangeView5.jsp").forward(request, response);
        return;
    }
    int customerId = WebSupport.positiveId(request.getParameter("customerId"));
    if (customerId == 0) {
        response.sendError(404);
        return;
    }

    TicketPurchaseTransaction5[] transactions = new TicketPurchaseTransaction5DAO()
            .getCustomerTransactions(customerId, period.startDate(), period.endDate());
    Customer5 customer = transactions.length > 0 ? transactions[0].getCustomer()
            : new Member5DAO().findCustomer(customerId);
    if (customer == null) {
        response.sendError(404);
        return;
    }

    BigDecimal totalAmount = BigDecimal.ZERO;
    for (TicketPurchaseTransaction5 transaction : transactions) {
        totalAmount = totalAmount.add(transaction.getTotalAmount());
    }

    request.setAttribute("pageTitle", "Chi tiết giao dịch");
    period.expose(request);
    request.setAttribute("customer", customer);
    request.setAttribute("transactions", transactions);
    request.setAttribute("totalAmount", totalAmount);
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<fmt:setLocale value="vi_VN"/>
<h1>Chi tiết giao dịch</h1>
<h2><c:out value="${customer.code}"/> – <c:out value="${customer.name}"/></h2>
<%@ include file="/WEB-INF/jspf/period.jspf" %>
<div class="table-wrap">
    <table aria-label="Giao dịch của khách hàng">
        <thead>
        <tr><th scope="col">Mã giao dịch</th><th scope="col">Thời điểm mua</th>
            <th scope="col">Hình thức mua</th><th scope="col">Số vé</th><th scope="col">Số tiền (đồng)</th></tr>
        </thead>
        <tbody>
        <c:forEach var="transaction" items="${transactions}">
            <tr>
                <td class="center"><c:out value="${transaction.transactionCode}"/></td>
                <td class="center"><c:out value="${transaction.displayDateTime}"/></td>
                <td><c:out value="${transaction.displayChannel}"/></td>
                <td class="center"><c:out value="${transaction.ticketCount}"/></td>
                <td class="number"><fmt:formatNumber value="${transaction.totalAmount}" maxFractionDigits="2"/></td>
            </tr>
        </c:forEach>
        <c:if test="${empty transactions}">
            <tr><td colspan="5">Không có giao dịch trong khoảng ngày đã chọn.</td></tr>
        </c:if>
        </tbody>
        <tfoot>
            <tr><th colspan="4" scope="row">Tổng cộng</th>
                <td class="number"><fmt:formatNumber value="${totalAmount}" maxFractionDigits="2"/></td></tr>
        </tfoot>
    </table>
</div>
<c:url var="back" value="/view/manager/CustomerRevenueResultsView5.jsp">
    <c:param name="startDate" value="${startDate}"/>
    <c:param name="endDate" value="${endDate}"/>
</c:url>
<a class="button secondary back" href="<c:out value='${back}'/>">Quay lại</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
