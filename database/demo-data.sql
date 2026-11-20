USE cineman;
SET NAMES utf8mb4;
START TRANSACTION;

INSERT INTO tblMember5 (id, name, username, authenticationInfo, role) VALUES
(1, 'Nguyễn Minh An', 'khachhang', '600000:siRPiDkeUlwb/kSl/keUcg==:XJWLjWr4iru4TFs109dez29TnB+H5exkRBnxnh+5wDY=', 'CUSTOMER'),
(2, 'Trần Gia Linh', 'kh002', 'disabled', 'CUSTOMER'),
(3, 'Lê Hoàng Nam', 'kh003', 'disabled', 'CUSTOMER'),
(4, 'Phạm Thu Hà', 'quanly', '600000:reW71gKalOUxHFcwyt3gLw==:WefgaC1PDKjK8jZ5ymziq2HqSBt06vkCWobdXFvtp7g=', 'MANAGER'),
(5, 'Đỗ Văn Minh', 'banve', 'disabled', 'SALE_STAFF');

INSERT INTO tblCustomer5 (memberId) VALUES (1), (2), (3);
INSERT INTO tblStaff5 (memberId, position) VALUES (4, 'Quản lý'), (5, 'Bán hàng');
INSERT INTO tblMembershipCard5 (cardCode, issueDate, tblCustomer5Id, issuedByStaffId)
VALUES ('THE001', '2026-10-30', 1, 5);

INSERT INTO tblMovie5 (id, title, genre, duration, description) VALUES
(15, 'Hành trình đến Đảo Mây', 'Phiêu lưu', 105,
 'Hai người bạn lên đường tìm một hòn đảo bí ẩn qua những dấu vết trên tấm bản đồ cũ.'),
(21, 'Bí mật Đảo Mây', 'Kỳ ảo', 98,
 'Một người đưa thư lần theo ánh sáng bí ẩn xuất hiện trên Đảo Mây mỗi đêm.'),
(34, 'Đảo Mây và cơn bão', 'Hoạt hình', 92,
 'Những cư dân nhỏ cùng nhau tìm nơi trú ẩn khi một cơn bão tiến về hòn đảo.'),
(42, 'Đêm thành phố', 'Tâm lý', 106,
 'Một cuộc gặp bất ngờ làm thay đổi kế hoạch của hai người trong một đêm mưa.');

INSERT INTO tblScreeningRoom5 (id, name, capacity) VALUES (1, 'Phòng 1', 80), (2, 'Phòng 2', 60);
INSERT INTO tblScreening5 (id, startDateTime, ticketPrice, tblScreeningRoom5Id, tblMovie5Id) VALUES
(1, '2026-11-05 20:15:00', 100000, 1, 15),
(2, '2026-11-12 18:30:00', 80000, 2, 34),
(3, '2026-11-01 19:00:00', 120000, 1, 21),
(4, '2026-11-16 18:00:00', 90000, 2, 21);

INSERT INTO tblTicketPurchaseTransaction5
    (id, transactionCode, transactionDateTime, purchaseChannel, tblCustomer5Id, tblScreening5Id, tblStaff5Id)
VALUES
(17, 'GD0017', '2026-11-05 19:10:00', 'ONLINE', 1, 1, NULL),
(38, 'GD0038', '2026-11-12 17:35:00', 'COUNTER', 1, 2, 5),
(41, 'GD0041', '2026-11-01 00:00:00', 'ONLINE', 2, 3, NULL),
(45, 'GD0045', '2026-11-15 23:59:59', 'ONLINE', 3, 4, NULL),
(47, 'GD0047', '2026-11-11 10:00:00', 'COUNTER', NULL, 2, 5),
(51, 'GD0051', '2026-11-16 00:00:00', 'ONLINE', 1, 4, NULL);

INSERT INTO tblMovieTicket5 (ticketCode, salePrice, tblTicketPurchaseTransaction5Id) VALUES
('VE017A', 100000, 17), ('VE017B', 100000, 17),
('VE038A', 80000, 38), ('VE038B', 80000, 38),
('VE041A', 120000, 41), ('VE041B', 120000, 41),
('VE045A', 90000, 45), ('VE045B', 90000, 45),
('VE047A', 80000, 47), ('VE051A', 90000, 51);

COMMIT;
