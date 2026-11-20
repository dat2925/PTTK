<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (!"POST".equals(request.getMethod())) {
        response.sendError(405);
        return;
    }
    if (!WebSupport.validToken(session, request.getParameter("token"))) {
        response.sendError(403);
        return;
    }
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/login.jsp");
%>
