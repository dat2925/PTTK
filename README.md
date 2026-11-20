# CineMan

Dự án Java Web cho đề số 17 gồm hai chức năng **Tìm kiếm thông tin phim** và **Thống kê khách hàng theo doanh thu**.

## Chạy bản đã chuẩn bị trên máy này

Từ thư mục dự án, chạy trong PowerShell:

    powershell -ExecutionPolicy Bypass -File .\scripts\run-demo.ps1

Mở [CineMan](http://127.0.0.1:8085/CineMan/). Bản demo dùng Tomcat 11 ở cổng 8085 và MySQL 9.4 riêng ở cổng 3317.

| Vai trò | Tên đăng nhập | Mật khẩu demo |
|---|---|---|
| Khách hàng | khachhang | CineManKhach2026! |
| Nhân viên quản lý | quanly | CineManQuanLy2026! |

Để chạy lại sau khi sửa mã, dừng bản demo rồi chạy lại lệnh khởi động.

    powershell -ExecutionPolicy Bypass -File .\scripts\run-demo.ps1 -Stop

## Mở bằng NetBeans hoặc cài trên máy khác

1. Dùng JDK 17 trở lên, Maven, Apache Tomcat 11 và MySQL 8.4 trở lên.
2. Trong NetBeans, chọn **File → Open Project** và mở thư mục chứa pom.xml. Mã Java nằm ở **Source Packages**, các trang JSP nằm ở **Web Pages**.
3. Trong MySQL Workbench, chạy toàn bộ database/schema.sql bằng tài khoản có quyền tạo schema, bảng và thủ tục. Chạy database/demo-data.sql một lần trên schema mới để nạp dữ liệu mẫu.
4. Tạo một tài khoản MySQL cho ứng dụng và cấp quyền **SELECT** và **EXECUTE** trên schema cineman. Ví dụ:

       GRANT SELECT, EXECUTE ON cineman.* TO 'cineman_app'@'127.0.0.1';

5. Đặt các biến môi trường cho tiến trình chạy Tomcat. Nếu dùng PowerShell:

       $env:CINEMAN_DB_URL = 'jdbc:mysql://127.0.0.1:3306/cineman'
       $env:CINEMAN_DB_USER = 'cineman_app'
       $secret = Read-Host 'Mật khẩu tài khoản JDBC' -AsSecureString
       $env:CINEMAN_DB_PASSWORD = [pscredential]::new('cineman_app', $secret).GetNetworkCredential().Password

   Khởi động Tomcat từ phiên đã đặt biến. Nếu muốn NetBeans khởi động Tomcat, hãy mở NetBeans từ phiên đó để cấu hình được kế thừa.
6. Chạy mvn package. Có thể chép target/CineMan.war vào webapps của Tomcat 11 rồi mở /CineMan/ trên cổng HTTP của Tomcat.

## Cấu trúc dự án

    CineMan/
      database/
        schema.sql
        demo-data.sql
      src/main/java/
        dao/
          DAO5.java
          Member5DAO.java
          Movie5DAO.java
          CustomerRevenueStatistic5DAO.java
          TicketPurchaseTransaction5DAO.java
        model/
        web/
      src/main/webapp/
        WEB-INF/
        assets/
        view/customer/
        view/manager/
        index.jsp
        login.jsp
        doLogin.jsp
      pom.xml

Theo Chương 5, các trang JSP gọi DAO trực tiếp, DAO dùng JDBC và lớp model nhận dữ liệu trả về. Bốn thao tác nghiệp vụ dùng CallableStatement để gọi thủ tục MySQL cùng tên. Maven đóng gói JDBC và JSTL vào WEB-INF/lib của file WAR.

## Dữ liệu kiểm tra

- Đăng nhập khách hàng rồi tìm từ khóa **Đảo Mây** để thấy PH015, PH021 và PH034. Mở PH015 rồi quay lại để kiểm tra từ khóa được giữ.
- Đăng nhập quản lý và chọn **01/11/2026 đến 15/11/2026**. KH001 có tổng **360.000 đồng** từ GD0017 và GD0038. Tiền được cộng từ giá bán từng vé. Khoảng ngày tính đến hết ngày kết thúc. Giao dịch tại quầy chưa gắn khách hàng không được tính vào báo cáo theo khách hàng.
- Schema dùng chín bảng theo sơ đồ CSDL trong báo cáo hoàn chỉnh. Thẻ thành viên có khóa khách hàng duy nhất. Suất chiếu được lưu tại giao dịch và dùng chung cho các vé của giao dịch.
