<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    response.setStatus(500);
    response.setHeader("Cache-Control", "no-store");
    application.log("CineMan: lỗi khi xử lý yêu cầu.", exception);
%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lỗi xử lý | CineMan</title>
    <link rel="stylesheet" href="<c:url value='/assets/site.css'/>">
</head>
<body>
<div class="panel">
    <header class="masthead"><a class="brand" href="<c:url value='/'/>">CineMan</a></header>
    <main>
        <h1>Không thể xử lý yêu cầu</h1>
        <p>Nếu lỗi xảy ra khi lấy dữ liệu, hãy kiểm tra MySQL và cấu hình kết nối.</p>
        <a class="button secondary" href="<c:url value='/'/>">Về trang chủ</a>
    </main>
</div>
</body>
</html>
