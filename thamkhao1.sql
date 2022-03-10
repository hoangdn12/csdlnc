CREATE DATABASE QUANLIMUAHANG
go
use QUANLIMUAHANG
CREATE TABLE KHACHHANG(
MKH VARCHAR (255) PRIMARY KEY,
TenKH VARCHAR (255),
Email VARCHAR(255),
Phone VARCHAR(255),
DiaChi VARCHAR(255)
)
GO
CREATE TABLE SANPHAM(
MSP VARCHAR(255) PRIMARY KEY,
TenSP VARCHAR(255),
MoTa VARCHAR(255),
GiaSP INT,
SoLuongSP INT)
GO
CREATE TABLE DONHANG(
MDH VARCHAR(255) PRIMARY KEY,
MPTTT VARCHAR(255)
FOREIGN KEY (MPTTT) REFERENCES PHUONGTHUCTHANHTOAN(MPTTT),
MKH VARCHAR(255)
FOREIGN KEY (MKH) REFERENCES KHACHHANG (MKH),
NgayDD DATE,
TTDH VARCHAR(255),
TongTien INT
)
GO
CREATE TABLE PHUONGTHUCTHANHTOAN(
MPTTT VARCHAR(255) PRIMARY KEY,
TenPTTT VARCHAR(255),
PhiTT INT
)
GO
CREATE TABLE CHITIETDONHANG(
MCTDH VARCHAR(255) PRIMARY KEY,
MDH VARCHAR(255)
FOREIGN KEY (MDH) REFERENCES DONHANG (MDH),
MSP VARCHAR(255)
FOREIGN KEY (MSP) REFERENCES SANPHAM (MSP),
SoLuongSPM INT,
GiaSPM INT,
ThanhTien INT
)
GO
INSERT INTO KHACHHANG VALUES
-- MKH TenKH Email Phone Diachi
('KH01', 'Hoang Van Nhat', 'Nhat@gmail.com' , '012345678', 'Lien Chieu- Da Nang'),
('KH02', 'Nguyen Nhat Anh','Anh@gmail.com','012345687', 'Son Tra - Da Nang'),
('KH03','Tran Anh Tuan', 'Tuan@gmail.com','012345688','Hai Chau - Da Nang'),
('KH04','Le Van Hoang', 'Hoang@gmail.com','012365478','Lien Chieu - Da Nang'),
('KH05' , 'Nguyen Minh Huy', 'Huy@gmail.com', '012398745','Hoa Vang - Da Nang')
GO
INSERT INTO SANPHAM VALUES
---MSP TenSp Mota GiaSP SoLuongSp
('SP1', 'Banh Donut', 'Banh ngot trang mieng','60000','20'),
('SP2','Banh Tiramisu','Banh ngot xuast su tu Y','50000','30'),
('SP3','Banh Mochi','Banh ngot tu Nhat Ban','40000','30'),
('SP4','Banh Black Forest','Banh ngot tu Duc','45000','20'),
('SP5','Banh Limburg Pie','Banh ngot tu Ha Lan','30000','20'),
('SP6','Banh Tao','Banh xuat su tu My','60000','25')
INSERT INTO PHUONGTHUCTHANHTOAN VALUES
--MPTTT TenPTTT PhiTT
('PTTT1','Thanh toan khi nhan duoc hang','20000'),
('PTTT2','Thanh Toan online','10000')
GO
INSERT INTO DONHANG VALUES
--MDH MPTTT MKH NgayDH TrangThai TongTien
('DH1','PTTT1','KH01','2022-2-20','Da dat hang','160000'),
('DH2','PTTT1','KH03','2022-2-22','Dang giao hang','155000'),
('DH3','PTTT2','KH04','2022-2-25','Giao hang thanh cong','120000')
GO
INSERT INTO DONHANG VALUES
--MDH MPTTT MKH NgayDH TrangThai TongTien



('DH4','PTTT2','KH04','2022-2-25','Giao hang thanh cong','120000')



INSERT INTO CHITIETDONHANG VALUES
--MCTDH MDH MSP SoLuongSp GiaSP ThanhTien
('CTDH1','DH1','SP1','2','70000','140000'),
('CTDH2','DH2','SP5','2','40000','80000'),
('CTDH3','DH2','SP4','1','55000','55000'),
('CTDH4','DH3','SP2','1','60000','60000'),
('CTDH5','DH3','SP3','1','50000','50000')
GO
INSERT INTO CHITIETDONHANG VALUES
('CTDH6','DH4','SP2','1','60000','60000'),
('CTDH7','DH4','SP3','1','50000','50000')
-- Tong tien ma khach hang do da mua
CREATE VIEW TONGTIEN AS
SELECT KH.MKH,KH.TenKH, SUM(DH.TongTien) AS N'TongTien' FROM DONHANG DH
JoIN KHACHHANG KH
ON KH.MKH = DH.MKH
GROUP BY KH.MKH,KH.TenKH




GO
DROP VIEW TONGTIEN
SELECT * FROM TONGTIEN

GO

-- nhap vao MSP in ra gia tien cua san pham do
CREATE FUNCTION GiaTienSP (@MSP VARCHAR(255))
RETURNS INT
AS
BEGIN
DECLARE @GiaTienSP int
SELECT @GiaTienSP = SP.GiaSP FROM SANPHAM SP WHERE MSP = @MSP
RETURN @GiaTienSP
END
GO
SELECT dbo.GiaTienSP ('SP3')
GO
SELECT dbo.GiaTienSP (MSP) FROM SANPHAM
-- Nhập vào MKH và in ra tổng số tiền mà người đó đã mua
GO
CREATE FUNCTION TongTienKH (@MKH VARCHAR(255))
RETURNS INT
AS
BEGIN
DECLARE @TongTienKH int
SELECT @TongTienKH = SUM(DH.TongTien) FROM KHACHHANG KH JOIN DONHANG DH
ON KH.MKH = DH.MKH WHERE @MKH = DH.MKH
RETURN @TongTienKH
END
GO
DROP FUNCTION TongTienKH




GO
SELECT dbo.TongTienKH('KH04')
--
SELECT * FROM KHACHHANG KH JOIN DONHANG DH
ON KH.MKH = DH.MKH
WHERE DH.TongTien =
(SELECT MAX(SUM(DH.TongTien)) FROM DONHANG DH WHERE month(DH.NgayDD) = 2 )



-- Nhập vào số tháng in ra người mua nhiều hàng nhất
GO
CREATE FUNCTION NguoiMuaHang(@thang INT)
RETURNS VARCHAR(255)
AS
BEGIN
DECLARE @Nguoimuahang VARCHAR(255)

SELECT top 1 @Nguoimuahang = KH.TenKH FROM DONHANG DH JOIN KHACHHANG KH ON DH.MKH = KH.MKH
WHERE month(DH.NgayDD) = @thang GROUP BY KH.MKH,KH.TenKH Order by SUM(DH.TongTien) DESC
RETURN @Nguoimuahang
END
GO
DROP FUNCTION NguoiMuaHang
SELECT dbo.NguoiMuaHang('2')
GO
-- Tạo thủ tục lưu trữ: Nhập vào MSP đưa ra thông tin chi tiết về MSP đó
SELECT SUM(DH.TongTien) FROM DONHANG DH WHERE MONTH(DH.NgayDD) = '2'



GO
CREATE PROC SANPHAMM(@MSP VARCHAR(10)) AS
BEGIN
  IF(exists(SELECT * FROM SANPHAM SP WHERE SP.MSP=@MSP))
    SELECT * FROM SANPHAM SP WHERE SP.MSP=@MSP
  ELSE
    print N'Không tìm thấy sản phẩm có mã ' + @MSP;
END;
GO
EXEC SANPHAMM '*';
GO
EXEC SANPHAMM 'SP2';
GO
DROP PROC SANPHAMM
GO
CREATE PROC DOANHTHUTRONGTHANG(@month INT) AS
BEGIN
  IF(exists(SELECT * FROM DONHANG DH WHERE MONTH(DH.NgayDD) = @month))
   SELECT SUM(DH.TongTien) AS N'DOAnh thu trong tháng' FROM DONHANG DH WHERE MONTH(DH.NgayDD) = @month AND DH.TTDH = 'Giao hang thanh cong'
  ELSE
    print N'Doanh thu thang nay khong co' ;
END;
GO
DROP PROC DOANHTHUTRONGTHANG
GO
EXEC DOANHTHUTRONGTHANG 3;

hello
