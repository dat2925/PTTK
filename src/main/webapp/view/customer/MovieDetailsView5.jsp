<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/customer.jspf" %>
<%@ page import="dao.Movie5DAO,model.Movie5" %>
<%
    int movieId = WebSupport.positiveId(request.getParameter("movieId"));
    String title = WebSupport.trim(request.getParameter("title"));
    if (title.length() > 255) {
        title = "";
    }

    Movie5 movie = movieId == 0 ? null : new Movie5DAO().getMovieDetails(movieId);
    if (movie == null) {
        if (title.isEmpty()) {
            request.setAttribute("message", "Phim không còn tồn tại.");
            request.getRequestDispatcher("/view/customer/MovieSearchView5.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/view/customer/MovieSearchResultsView5.jsp?title="
                    + WebSupport.encode(title) + "&missing=1");
        }
        return;
    }
    request.setAttribute("pageTitle", "Chi tiết phim");
    request.setAttribute("movie", movie);
    request.setAttribute("keyword", title);
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Chi tiết phim</h1>
<h2><c:out value="${movie.title}"/></h2>
<dl class="movie-facts">
    <div><dt>Mã phim</dt><dd><c:out value="${movie.code}"/></dd></div>
    <div><dt>Thể loại</dt><dd><c:out value="${movie.genre}"/></dd></div>
    <div><dt>Thời lượng</dt><dd><c:out value="${movie.duration}"/> phút</dd></div>
</dl>
<h3>Nội dung giới thiệu</h3>
<p class="description"><c:out value="${movie.description}"/></p>
<c:choose>
    <c:when test="${empty keyword}"><c:url var="back" value="/view/customer/MovieSearchView5.jsp"/></c:when>
    <c:otherwise>
        <c:url var="back" value="/view/customer/MovieSearchResultsView5.jsp">
            <c:param name="title" value="${keyword}"/>
        </c:url>
    </c:otherwise>
</c:choose>
<a class="button secondary back" href="<c:out value='${back}'/>">Quay lại</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
