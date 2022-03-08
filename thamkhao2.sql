CREATE DATABASE QLMuaHang;
GO
USE QLMuaHang;

CREATE TABLE CUSTOMER (
	MaKH NVARCHAR(100) PRIMARY KEY,
	HoTen NVARCHAR(100),
	Email NVARCHAR(100),
	Phone INT,
	DiaChi NVARCHAR(100)
);

CREATE TABLE PRODUCT (
	MaSP NVARCHAR(100) PRIMARY KEY,
	TenSP NVARCHAR(100),
	MoTa NVARCHAR(100),
	GiaSP INT, 
	SoluongSP INT
);

CREATE TABLE PAYMENT (
	MaPTTT NVARCHAR(100) PRIMARY KEY,
	TenPTTT NVARCHAR(100),
	PhiTT INT
);

CREATE TABLE DONHANG (
	MaDH NVARCHAR(100) PRIMARY KEY,
	NgayDH DATE,
	Trangthai NVARCHAR(100),
	TongTien INT,
	MaKH NVARCHAR(100),
	MaSP NVARCHAR(100),
	FOREIGN KEY (MaKH) REFERENCES CUSTOMER(MaKH),
	FOREIGN KEY (MaSP) REFERENCES PRODUCT(MaSP)
);

CREATE TABLE CHITIETHOADON (
	MaCTHD NVARCHAR(100) PRIMARY KEY,
	SoLuong INT,
	GiaSPmua INT,
	ThanhTien INT,
	MaDH NVARCHAR(100),
	MaSP NVARCHAR(100),
	FOREIGN KEY (MaDH) REFERENCES DONHANG(MaDH),
	FOREIGN KEY (MaSP) REFERENCES PRODUCT(MaSP)
);

-- INSERT INTO PAYMENT
INSERT INTO PAYMENT VALUES
('TT01',N'Thanh toán khi nhận hàng',30000),
('TT02',N'Thanh toán qua thẻ',0);

-- INSERT INTO CUSTOMER
INSERT INTO CUSTOMER VALUES 
('KH001',    N'Nguyễn Tùng Minh',  N'ntm@gmail.com' ,	  '0354111111',   N'Đà Nẵng'        ),
('KH002',    N'Nguyễn B',          N'nguyenb@gmail.com',  '0313232323',   N'Huế'            ),
('KH003',    N'Nguyễn C',          N'nguyenc@gmail.com',  '0354333333',   N'Quảng Ngãi'     ),
('KH004',    N'Trần A'  ,          N'trana@gmail.com',    '0354444444',   N'Đà Nẵng'        ),
('KH005',    N'Trần B'  ,          N'tranb@gmail.com',    '0354555555',   N'Quảng Nam'      );

-- INSERT INTO PRODUCT
INSERT INTO PRODUCT VALUES
('SP001',   N'Trứng',            N'Trứng vĩ 6 lốc',        20000 ,15),
('SP002',   N'Sữa',              N'Thùng sữa Vinamilk',   100000 ,20),
('SP003',   N'Mì tôm',           N'Thùng mì tôm hảo hảo', 120000 ,25),
('SP004',   N'Trái cây',         N'Trái cây đóng hộp',    150000, 50);

-- INSERT INTO DONHANG
INSERT INTO DONHANG VALUES
('DH001', '2022-02-28', N'Đang giao' ,  40000, 'KH001', 'SP001'),
('DH002', '2022-01-27', N'Đang giao',  200000, 'KH002', 'SP002'),
('DH003','2022-03-05',N'Đang giao',120000,'KH001','SP003'),
('DH004','2022-03-06',N'Đã giao',240000,'KH001','SP003'),
('DH005','2022-03-06',N'Đã giao',150000,'KH001','SP004');

-- INSERT INTO CHITETHOADON
INSERT INTO CHITIETHOADON VALUES
('CT001',2,20000,40000,'DH001','SP001'),
('CT002',2,100000,200000,'DH002','SP002'),
('CT003',1,120000,120000,'DH003','SP003'),
('CT004',2,120000,240000,'DH004','SP003'),
('CT005',1,150000,150000,'DH005','SP004');


-- VIEW: Hiển thị thông tin của khách hàng và đơn hàng đã mua 
CREATE VIEW V_DONHANG
AS
SELECT KH.MaKH,KH.DiaChi,KH.HoTen, DH.MaDH, DH.Trangthai, DH.TongTien FROM CUSTOMER KH JOIN DONHANG DH ON KH.MaKH = DH.MaKH 
GO

SELECT * FROM V_DONHANG

GO

-- VIEW: Thông tin những đơn hàng được đặt trong năm nay
CREATE VIEW V_InfoOrder
AS 
    SELECT DISTINCT CUSTOMER.MaKH, 
	DONHANG.MaDH, DONHANG.MaSP, DONHANG.NgayDH, DONHANG.TongTien, 
	DONHANG.Trangthai, CHITIETHOADON.SoLuong
	FROM CUSTOMER
		JOIN DONHANG ON DONHANG.MaKH=CUSTOMER.MaKH
		JOIN CHITIETHOADON ON CHITIETHOADON.MaDH=DONHANG.MaDH
		JOIN PRODUCT ON PRODUCT.MaSP=CHITIETHOADON.MaSP
	WHERE YEAR(DONHANG.NgayDH) = YEAR(GETDATE())
GO

SELECT * FROM V_InfoOrder

GO

-- PROCEDURE: Kiểm tra trạng thái của một đơn hàng
ALTER PROC sp_Status(@mahang NVARCHAR(100))
AS
BEGIN
     IF(@mahang NOT IN(SELECT MaDH FROM DONHANG))
	 PRINT N'Đơn hàng không tồn tại.'
	 ELSE
	    BEGIN
	       DECLARE @trangthai NVARCHAR(100)
	       SELECT @trangthai=Trangthai
	       FROM DONHANG
	       WHERE MaDH = @mahang
	       PRINT @mahang+N' có trạng thái là: '+@trangthai
	     END
END
GO

EXEC sp_Status 'DH006'

EXEC sp_Status 'DH004'
-- PROCEDURE: Kiểm tra khách hàng bất kỳ mua sản phẩm nào chưa, hiển thị tất cả sản phẩm đã mua
ALTER PROC sp_Order(@MaKH NVARCHAR(100))
AS
BEGIN
   IF(@MaKH NOT IN (SELECT MaKH FROM CUSTOMER))
   PRINT N'Khách hàng không có trong danh sách.'
   ELSE
   BEGIN
      DECLARE @MaDH NVARCHAR(100), @MaSP NVARCHAR(100), @Count int, @SoLuong int
      SELECT @Count = COUNT(DISTINCT MaSP) FROM DONHANG WHERE MaKH = @MaKH
      IF(@Count <= 0)
         PRINT N'Khách hàng chưa mua sản phẩm nào.'
      ELSE
      BEGIN
	     PRINT N'Khách hàng ' + @MaKH + N' đã mua sản phẩm : '
         WHILE @Count > 0
         BEGIN
            SELECT @MaSP = MaSP FROM DONHANG WHERE MaKH = @MaKH GROUP BY MaSP ORDER BY MaSP DESC OFFSET (@Count - 1) ROWS FETCH NEXT 1 ROWS ONLY;
			SELECT @SoLuong = SUM(CHITIETHOADON.SoLuong) FROM CHITIETHOADON JOIN DONHANG ON DONHANG.MaDH = CHITIETHOADON.MaDH WHERE CHITIETHOADON.MaSP = @MaSP and DONHANG.MaKH = @MaKH
	        PRINT  @MaSP+ N' - '+CAST(@SoLuong as varchar(100))+ N' sản phẩm'
	        SET @Count = @Count - 1;
         END
      END
   END
END

GO

EXEC sp_Order'KH001'

GO

-- FUNCTION: Tổng giá trị tiền đã mua của khách hàng 
CREATE FUNCTION uf_tienDaMua (@MaKH nvarchar(100))
RETURNS INT
AS
BEGIN
	DECLARE @TongTien INT
	SELECT @TongTien = SUM(CHITIETHOADON.ThanhTien)
	FROM CUSTOMER 
		JOIN DONHANG ON CUSTOMER.MaKH=DONHANG.MaKH
		JOIN CHITIETHOADON ON CHITIETHOADON.MaDH=DONHANG.MaDH
	WHERE CUSTOMER.MaKH=@MaKH 
	RETURN @TongTien
END
GO

SELECT MaKH,dbo.uf_tienDaMua(MaKH) AS [Tiền hàng đã mua] FROM CUSTOMER

GO

-- FUNCTION: Hiển thị thông tin khách hàng đặt hàng nhiều nhất
CREATE FUNCTION uf_muaNhieuNhat ()
RETURNS TABLE
AS
	RETURN SELECT CUSTOMER.*
	       FROM CUSTOMER
		   JOIN ( SELECT TOP 1 CUSTOMER.MaKH, Count(*) as soLuongDat FROM CUSTOMER JOIN DONHANG ON CUSTOMER.MaKH=DONHANG.MaKH GROUP BY CUSTOMER.MaKH) 
		   AS t ON t.MaKH= CUSTOMER.MaKH 
GO

SELECT * FROM dbo.uf_muaNhieuNhat()

GOs