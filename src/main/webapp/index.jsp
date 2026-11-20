<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    Member5 member = (Member5) session.getAttribute("member");
    String nextPage = "/login.jsp";
    if (member != null) {
        if ("CUSTOMER".equals(member.getRole())) {
            nextPage = "/view/customer/CustomerMainView5.jsp";
        } else if ("MANAGER".equals(member.getRole())) {
            nextPage = "/view/manager/ManagerHomeView5.jsp";
        }
    }
    response.sendRedirect(request.getContextPath() + nextPage);
%>
