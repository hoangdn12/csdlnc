CREATE DATABASE FOOD
CREATE TABLE CUSTOMER(
	MaKH NVARCHAR(15) PRIMARY KEY,
	HoTen NVARCHAR(50),
	Email NVARCHAR(50),
	Sđt NVARCHAR(15),
	DiaChi NVARCHAR(50)
	)
go
CREATE TABLE PRODUCT(
	MaSP NVARCHAR(15)PRIMARY KEY,
	TenSP NVARCHAR(50),
	MoTa NVARCHAR(50),
	GiaSP MONEY,
	SoLuongSP INT
	)
go
CREATE TABLE PAYMENT(
	MaPhuongThucTT NVARCHAR(15) PRIMARY KEY,
	TenPhuongThucTT NVARCHAR(50),
	PhiTT MONEY
	)
go
CREATE TABLE ORDER_SP(
	MaDH NVARCHAR(15) PRIMARY KEY,
	MaKH NVARCHAR(15) FOREIGN KEY (MaKH) REFERENCES CUSTOMER(MaKH),
	MaPhuongThucTT NVARCHAR(15) FOREIGN KEY (MaPhuongThucTT) REFERENCES PAYMENT(MaPhuongThucTT),
	NgayDat DATE,
	TrangThaiDatHang NVARCHAR(50),
	TongTien MONEY
	)
go
CREATE TABLE ORDER_DETAIL(
	MaCTDH NVARCHAR(15) PRIMARY KEY,
	MaSP NVARCHAR(15) FOREIGN KEY (MaSP) REFERENCES PRODUCT(MaSP),
	MaDH NVARCHAR(15) FOREIGN KEY (MaDH) REFERENCES ORDER_SP(MaDH),
	SoLuongSPMua INT,
	GiaSPMua MONEY,
	ThanhTien MONEY
	)
go
--DL

INSERT INTO CUSTOMER(MaKH, HoTen, Email, Sđt, DiaChi) VALUES
	('KH001', N'Lê Thị Xuân',	 'xuan@gmail.com', '0123456789', N'Liên Chiểu'),
	('KH002', N'Lê Văn Bình',	 'binh@gmail.com', '0123456788', N'Hải Châu'),
	('KH003', N'Nguyễn Văn Tấn', 	 'tan@gmail.com',  '0123456787', N'Liên Chiểu'),
	('KH004', N'Thái Thị Hiền',	 'hien@gmail.com', '0123456786', N'Sơn Trà'),
	('KH005', N'Đinh Văn Ngọc',  	 'ngoc@gmail.com', '0123456785', N'Ngũ Hành Sơn')
go
INSERT INTO PRODUCT(MaSP, TenSP, MoTa, GiaSP, SoLuongSP) VALUES
	('SP001', N'Hoa Hồng',		 N'Hoa Tươi', '15000', '20'),
	('SP002', N'Hoa Huệ Chuông',     N'Hoa Khô',  '20000', '15'),
	('SP003', N'Hoa Anh Đào',	 N'Hoa Khô',  '60000', '10'),
	('SP004', N'Hoa Ly',		 N'Hoa Tươi', '25000', '25'),
	('SP005', N'Hoa Sen Mini',	 N'Hoa Tươi', '70000', '12')
go
INSERT INTO PAYMENT(MaPhuongThucTT, TenPhuongThucTT, PhiTT) VALUES
	('PTTT1', N'Thanh toán khi nhận hàng','5000'),
	('PTTT2', N'Thanh Toán online','2000')
go
INSERT INTO ORDER_SP(MaDH, MaKH, MaPhuongThucTT, NgayDat, TrangThaiDatHang, TongTien) VALUES
	('DH001', 'KH001', 'PTTT2', '2022/01/20', N'Giao hàng thành công', '75000'),
	('DH002', 'KH001', 'PTTT1', '2022/02/14', N'Giao hàng thành công', '150000'),
	('DH003', 'KH002', 'PTTT2', '2022/02/23', N'Giao hàng thành công', '140000'),
	('DH004', 'KH003', 'PTTT1', '2022/03/01', N'Giao hàng thành công', '180000'),
	('DH005', 'KH005', 'PTTT1', '2022/03/08', N'Đang giao hàng',	   '200000')
go
INSERT INTO ORDER_DETAIL(MaCTDH, MaSP, MaDH, SoLuongSPMua, GiaSPMua, ThanhTien) VALUES
	('CTDH01', 'SP001', 'DH001', '5',  '15000', '75000'),
	('CTDH02', 'SP001', 'DH002', '10', '15000', '155000'),
	('CTDH03', 'SP005', 'DH003', '2',  '70000', '142000'),
	('CTDH04', 'SP003', 'DH004', '3',  '60000', '185000'),
	('CTDH05', 'SP002', 'DH005', '10', '20000', '205000')