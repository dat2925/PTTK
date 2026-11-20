<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%@ include file="/WEB-INF/jspf/customer.jspf" %>
<%@ page import="dao.Movie5DAO" %>
<%
    String title = WebSupport.trim(request.getParameter("title"));
    if (title.isEmpty() || title.length() > 255) {
        request.setAttribute("message", title.isEmpty() ? "Vui lòng nhập tên phim."
                : "Tên phim không được dài quá 255 ký tự.");
        request.getRequestDispatcher("/view/customer/MovieSearchView5.jsp").forward(request, response);
        return;
    }
    request.setAttribute("pageTitle", "Kết quả tìm kiếm");
    request.setAttribute("keyword", title);
    request.setAttribute("movies", new Movie5DAO().findMoviesByTitle(title));
%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<h1>Kết quả tìm kiếm</h1>
<%@ include file="/WEB-INF/jspf/movie-search.jspf" %>
<c:if test="${param.missing eq '1'}">
    <p class="message error" role="alert">Phim không còn tồn tại.</p>
</c:if>
<c:choose>
    <c:when test="${empty movies}">
        <p class="message" role="status">Không tìm thấy phim.</p>
    </c:when>
    <c:otherwise>
        <div class="table-wrap">
            <table aria-label="Danh sách phim tìm được">
                <thead>
                <tr><th scope="col">Mã phim</th><th scope="col">Tên phim</th><th scope="col">Thể loại</th>
                    <th scope="col">Thời lượng</th><th scope="col">Chọn</th></tr>
                </thead>
                <tbody>
                <c:forEach var="movie" items="${movies}">
                    <c:url var="detail" value="/view/customer/MovieDetailsView5.jsp">
                        <c:param name="movieId" value="${movie.id}"/>
                        <c:param name="title" value="${keyword}"/>
                    </c:url>
                    <tr>
                        <td class="center"><c:out value="${movie.code}"/></td>
                        <td><c:out value="${movie.title}"/></td>
                        <td><c:out value="${movie.genre}"/></td>
                        <td class="center"><c:out value="${movie.duration}"/> phút</td>
                        <td class="action-cell"><a href="<c:out value='${detail}'/>">Xem chi tiết</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>
<c:url var="back" value="/view/customer/MovieSearchView5.jsp"><c:param name="title" value="${keyword}"/></c:url>
<a class="button secondary back" href="<c:out value='${back}'/>">Quay lại</a>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
