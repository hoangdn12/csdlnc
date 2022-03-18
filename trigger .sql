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
	('CTDH01', 'SP001', 'DH002', '5',  '15000', '75000'),
	('CTDH02', 'SP001', 'DH004', '10', '15000', '155000'),
	('CTDH03', 'SP005', 'DH005', '2',  '70000', '142000'),
	('CTDH04', 'SP003', 'DH002', '3',  '60000', '185000'),
	('CTDH05', 'SP002', 'DH005', '10', '20000', '205000')
--Chi
-- cập nhật số lượng hàng trong bảng sản phẩm sau khi đặt hàng hoặc cập nhật
CREATE TRIGGER trg_DatHang ON ORDER_DETAIL AFTER INSERT AS 
BEGIN
	UPDATE PRODUCT
	SET SoLuongSP = SoLuongSP - (SELECT SoLuongSPMUA
		                         FROM inserted
		                         WHERE MaSP = PRODUCT.MaSP)
	FROM PRODUCT
	JOIN inserted ON PRODUCT.MaSP = inserted.MaSP
END
GO


select * from ORDER_SP
select * from ORDER_DETAIL
select * from PRODUCT

INSERT INTO ORDER_DETAIL VALUES
    --MaCTDH, MaSP, MaDH, SoLuongSPMua, GiaSPMua, ThanhTien
	('CTDH08', 'SP004', 'DH005', '5',  '55000', '275000');
	
	UPDATE PRODUCT 
	set SoLuongSP = 100
	where MaSP = 'SP004'
--Hoàng
--Trigger ngăn không cho xoá dữ liệu bảng ORDER_DETAIL
CREATE TRIGGER Trigger_check_delete_OrderDetail ON order_detail
FOR delete
AS 
	print 'Can not delete data'
	rollback transaction

delete ORDER_DETAI
--Không cho cập nhập đơn ở trạng thái đã nhận hàng 
CREATE TRIGGER Trigger_check_update_order ON order_SP
FOR update
AS 
	if ( (SELECT 1 FROM inserted
		WHERE MaDH IN (select MaDH from ORDER_SP 
						where TrangThaiDatHang = N'Giao hàng thành công')) > 0 )
	BEGIN
		PRINT 'CAN NOT EDIT BECAUSE N"Giao hàng thành công" '
		ROLLBACK TRANSACTION
	END

select * from ORDER_SP
UPDATE  ORDER_SP SET MaKH = 'KH001' WHERE MaDH = 'DH001'

--Vi
/*Tạo TRIGGER: Khi thực hiện thêm bản ghi vào bảng PRODUCT đảm bảo cột SoLuongSP không nhỏ hơn 5*/
CREATE TRIGGER KiemTra_SoLuongSP ON PRODUCT
FOR INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted WHERE SoLuongSP < 5)
		BEGIN 
			PRINT N'Số lượng sản phẩm không thể nhỏ hơn 5';
			ROLLBACK 
		END
	END


INSERT INTO PRODUCT VALUES ('SP006', N'Hoa Hướng Dương', N'Hoa Tươi', '130000', '4')

INSERT INTO PRODUCT VALUES ('SP006', N'Hoa Hướng Dương', N'Hoa Tươi', '130000', '17')

SELECT * FROM PRODUCT

DROP TRIGGER KiemTra_SoLuongSP


--Yến
-- trigger: Tạo một update nhằm đảm bảo khi tiến hành cập nhập dữ  liệu thì PhiTT mới khác phí thanh toán cũ 
CREATE TRIGGER checkPTT 
on PAYMENT 
FOR UPDATE 
AS 
  BEGIN 
  If EXISTS (SELECT * FROM inserted id inner join  deleted dl 
  on id.MaPhuongThucTT = dl.MaPhuongThucTT 
  where dl.PhiTT = id.PhiTT )
   BEGIN 
    PRINT N' Phí thanh toán không thỏa mãn với điều kiện';
	ROLLBACK TRANSACTION ;
	END
	END
GO 
UPDATE PAYMENT SET PhiTT = '3000' WHERE MaPhuongThucTT = 'PTTT1'
select *  from PAYMENT 


--Trâm
/* TRIGGER: Tạo một Trigger không cho phép xoá nhiều hơn 1 đơn hàng trong bảng ORDERS */
CREATE TRIGGER DELETE_DONHANG 
ON ORDERS
FOR DELETE
AS
BEGIN
	IF ((SELECT COUNT (*) FROM DELETED) > 1)
	BEGIN
		PRINT N'Không thể xoá nhiều hơn 1 đơn hàng!!'
		ROLLBACK TRANSACTION
	END
END

SELECT * FROM ORDERS;

DELETE FROM ORDERS WHERE MaDH = 'DH001';

DELETE FROM ORDERS WHERE MaDH = 'DH001' OR MaDH = 'DH003';

INSERT INTO ORDERS(MaDH, MaKH, MaPT_TT, NgayDatHang, TrangThaiDatHang, TongTien) VALUES
   ('DH001','KH001','PTTT1','2022/02/25','Giao hang thanh cong','120000')

DROP TRIGGER DELETE_DONHANG 

--Long
--Tạo trigger cập nhật số lượng tồn kho của các mặt hàng bất kì được mua.
Create trigger trg_CapNhatSoLuong
On ORDER_DETAIL
After insert
as 
  begin
    --lấy thông tin vừa insert
	Declare @MaSP nvarchar(15)
	Declare @Soluongmua int
	Select @MaSP = MaSP, @Soluongmua = SoLuongSPMua From inserted

	-- Cập nhật giảm số lượng tồn của sản phẩm
	Update PRODUCT
	Set SoLuongSP = SoLuongSP - @Soluongmua
	Where MaSP = @MaSP
	End
Go

select * from ORDER_DETAIL where MaDH = 'DH001'
select * from PRODUCT where MaSP = 'SP004'

Insert into ORDER_DETAIL(MaCTDH, MaSP, MaDH, SoLuongSPMua, GiaSPMua, ThanhTien)
Values ('CTDH006','SP004', 'DH001', 15, 15000.00, 85000.00)

