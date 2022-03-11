CREATE DATABASE FOOD
CREATE TABLE CUSTOMER(
	MaKH NVARCHAR(15) PRIMARY KEY,
	HoTen NVARCHAR(50),
	Email NVARCHAR(50),
	Sđt NVARCHAR(15),
	DiaChi NVARCHAR(50)
	)

CREATE TABLE PRODUCT(
	MaSP NVARCHAR(15)PRIMARY KEY,
	TenSP NVARCHAR(50),
	MoTa NVARCHAR(50),
	GiaSP MONEY,
	SoLuongSP INT
	)

CREATE TABLE PAYMENT(
	MaPhuongThucTT NVARCHAR(15) PRIMARY KEY,
	TenPhuongThucTT NVARCHAR(50),
	PhiTT MONEY
	)

CREATE TABLE ORDER_SP(
	MaDH NVARCHAR(15) PRIMARY KEY,
	MaKH NVARCHAR(15) FOREIGN KEY (MaKH) REFERENCES CUSTOMER(MaKH),
	MaPhuongThucTT NVARCHAR(15) FOREIGN KEY (MaPhuongThucTT) REFERENCES PAYMENT(MaPhuongThucTT),
	NgayDat DATE,
	TrangThaiDatHang NVARCHAR(50),
	TongTien MONEY
	)

CREATE TABLE ORDER_DETAIL(
	MaCTDH NVARCHAR(15) PRIMARY KEY,
	MaSP NVARCHAR(15) FOREIGN KEY (MaSP) REFERENCES PRODUCT(MaSP),
	MaDH NVARCHAR(15) FOREIGN KEY (MaDH) REFERENCES ORDER_SP(MaDH),
	SoLuongSPMua INT,
	GiaSPMua MONEY,
	ThanhTien MONEY
	)

--DL

INSERT INTO CUSTOMER(MaKH, HoTen, Email, Sđt, DiaChi) VALUES
	('KH001', N'Lê Thị Xuân',	 'xuan@gmail.com', '0123456789', N'Liên Chiểu'),
	('KH002', N'Lê Văn Bình',	 'binh@gmail.com', '0123456788', N'Hải Châu'),
	('KH003', N'Nguyễn Văn Tấn', 	 'tan@gmail.com',  '0123456787', N'Liên Chiểu'),
	('KH004', N'Thái Thị Hiền',	 'hien@gmail.com', '0123456786', N'Sơn Trà'),
	('KH005', N'Đinh Văn Ngọc',  	 'ngoc@gmail.com', '0123456785', N'Ngũ Hành Sơn')

INSERT INTO PRODUCT(MaSP, TenSP, MoTa, GiaSP, SoLuongSP) VALUES
	('SP001', N'Hoa Hồng',		 N'Hoa Tươi', '15000', '20'),
	('SP002', N'Hoa Huệ Chuông',     N'Hoa Khô',  '20000', '15'),
	('SP003', N'Hoa Anh Đào',	 N'Hoa Khô',  '60000', '10'),
	('SP004', N'Hoa Ly',		 N'Hoa Tươi', '25000', '25'),
	('SP005', N'Hoa Sen Mini',	 N'Hoa Tươi', '70000', '12')

INSERT INTO PAYMENT(MaPhuongThucTT, TenPhuongThucTT, PhiTT) VALUES
	('PTTT1', N'Thanh toán khi nhận hàng','5000'),
	('PTTT2', N'Thanh Toán online','2000')

INSERT INTO ORDER_SP(MaDH, MaKH, MaPhuongThucTT, NgayDat, TrangThaiDatHang, TongTien) VALUES
	('DH001', 'KH001', 'PTTT2', '2022/01/20', N'Giao hàng thành công', '75000'),
	('DH002', 'KH001', 'PTTT1', '2022/02/14', N'Giao hàng thành công', '150000'),
	('DH003', 'KH002', 'PTTT2', '2022/02/23', N'Giao hàng thành công', '140000'),
	('DH004', 'KH003', 'PTTT1', '2022/03/01', N'Giao hàng thành công', '180000'),
	('DH005', 'KH005', 'PTTT1', '2022/03/08', N'Đang giao hàng',	   '200000')

INSERT INTO ORDER_DETAIL(MaCTDH, MaSP, MaDH, SoLuongSPMua, GiaSPMua, ThanhTien) VALUES
	('CTDH01', 'SP001', 'DH001', '5',  '15000', '75000'),
	('CTDH02', 'SP001', 'DH002', '10', '15000', '155000'),
	('CTDH03', 'SP005', 'DH003', '2',  '70000', '142000'),
	('CTDH04', 'SP003', 'DH004', '3',  '60000', '185000'),
	('CTDH05', 'SP002', 'DH005', '10', '20000', '205000')
	


/*câu 2 liệt kê những đơn hàng  có phương thức  thanh toán là " thanh  toán online " và tổng tiền > 75000 */
Select PM.TenPhuongThucTT ,  OD.TongTien from ORDER_SP OD inner join PAYMENT PM 
on OD.MaPhuongThucTT = PM.MaPhuongThucTT 
where   TongTien >'75000' and   PM.TenPhuongThucTT = N'Thanh Toán online'


/* liệt kê  đơn hàng có trạng thái đặt hàng là 'Đang Giao Hàng " và Khách hàng có địa chỉ ở "Ngũ Hành Sơn " */
Select OD.MaKH ,OD.TrangThaiDatHang, CM.DiaChi From CUSTOMER CM JOIN ORDER_SP OD 
ON OD.MaKH = CM.MaKH 
where  CM.DiaChi = N'Ngũ Hành Sơn'  and  OD.TrangThaiDatHang = N'Đang giao hàng';

/*Câu 3Tạo VIEW: lấy thông tin của tất cả khách hàng có địa chỉ là "Liên Chiểu" và TrangThaiDatHang = 'Giao hàng thành công*/
CREATE VIEW V_KHACHHANG
AS
	SELECT DISTINCT C.MaKH, HoTen, Email, Sđt, DiaChi, O.TrangThaiDatHang  FROM CUSTOMER AS C
	JOIN ORDER_SP AS O ON C.MaKH = O.MaKH
	WHERE DiaChi = N'Liên Chiểu' AND TrangThaiDatHang = N'Giao hàng thành công'
	
SELECT * FROM V_KHACHHANG

DROP VIEW V_KHACHHANG

/*Tạo VIEW: lấy thông tin của tất cả sản phẩm có mô tả là 'Hoa Tươi' và số lượng sản phẩm mua > 5*/
CREATE VIEW V_SP
AS
	SELECT P.*, OD.SoLuongSPMua FROM PRODUCT AS P
	JOIN ORDER_DETAIL AS OD ON P.MaSP = OD.MaSP
	WHERE MoTa = N'Hoa Tươi' AND SoLuongSPMua > 5
	
SELECT * FROM V_SP

DROP VIEW V_SP


/*Câu 4 STORE PROCEDUE: a) Stored Procedure Sp_1: Dùng để xóa thông tin của một sản phẩm nào đó (tức là xóa 1 bản ghi trong bảng PRODUCT)
với mã sản phẩm được truyền vào như một tham số của Stored Procedure */ 
CREATE PROCEDURE Sp_1 (@Id_SP NVARCHAR(15))
AS
BEGIN
	DELETE FROM PRODUCT
	WHERE MaSP = @Id_SP
END

EXECUTE Sp_1 'SP004';

SELECT * FROM PRODUCT;

INSERT INTO PRODUCT(MaSP, TenSP, MoTa, GiaSP, SoLuongSP) VALUES
('SP004', N'Hoa Ly', N'Hoa Tươi', '25000', '25')

DROP PROCEDURE Sp_1

 /* câu 4 Tạo procdure in ra  các đơn hàng  */

 CREATE PROC list_Order
 @MaDH NVARCHAR(15)
 AS
 BEGIN 
 SELECT * from ORDER_SP
 END
 GO

 exec list_Order 'DH005'



/*cau 5 Hiển thị tiền của đơn hàng  */
CREATE FUNCTION Donhang (@MaDH nvarchar(15))
RETURNS INT 
AS
BEGIN
     DECLARE @tongtien INT
	 SELECT @tongtien = sum(ThanhTien) from ORDER_DETAIL
	
	 WHERE MaDH = @MaDH
	 RETURN @tongtien
END

select dbo.Donhang('DH001') as ThanhTien


/*Câu 5: -- Thống kê tổng số lượng sản phẩm đã bán và số lượng còn lại là bao nhiêu?

Create function fn_tongsoluongban (@MaSP nvarchar(10))
Returns int 
As
Begin
     Declare @soluongban int
	 Select @soluongban = sum(cthd.SoLuongSPMua) 
	 From ORDER_DETAIL aS cthd , PRODUCT as sp
	 Where cthd.SoLuongSPMua = sp.SoLuongSP and cthd.MaSP = @MaSP
	 Group By sp.MaSP
	 Return @soluongban
END
Go
Select DISTINCT  cthd.MaSP, sp.SoLuongSP,  dbo.fn_tongsoluongban('SP001') 'Số Lượng Bán' , (sp.SoLuongSP - dbo.fn_tongsoluongban('SP001')) 'Số Lượng Còn Lại'
From ORDER_DETAIL as cthd, PRODUCT as sp
Where cthd.MaSP = 'SP001' and sp.MaSP = cthd.MaSP

 




