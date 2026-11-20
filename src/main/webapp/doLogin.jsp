<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ page import="dao.Member5DAO" %>
<%
    if (!"POST".equals(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!WebSupport.validToken(session, request.getParameter("token"))) {
        response.sendError(403);
        return;
    }
    String username = WebSupport.trim(request.getParameter("username"));
    String password = request.getParameter("password");
    Member5 member = null;
    if (!username.isEmpty() && username.length() <= 255
            && password != null && !password.isEmpty() && password.length() <= 128) {
        member = new Member5DAO().authenticate(username, password);
    }

    if (member == null) {
        request.setAttribute("username", username.length() <= 255 ? username : "");
        request.setAttribute("loginError", "Tên đăng nhập hoặc mật khẩu chưa đúng.");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;
    }
    request.changeSessionId();
    session.setAttribute("member", member);
    session.removeAttribute("formToken");
    WebSupport.formToken(session);
    response.sendRedirect(request.getContextPath() + "/");
%>
