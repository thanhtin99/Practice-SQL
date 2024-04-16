-- Phan Thanh Tin


use [AdventureWorks2019] EXEC sp_changedbowner 'sa'
CREATE DATABASE SmallWorks 
ON PRIMARY (
	NAME = 'SmallWorksPrimary1',
	FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\SmallWorks.mdf', 
	SIZE = 10MB, 
	FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
), 
FILEGROUP SWUserDatal (
	NAME = 'SmallWorksDatal',
	FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\SmallWorksDatal.ndf', 
	SIZE = 10MB, 
	FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
),
FILEGROUP SWUserData2 (
	NAME = 'SmallWorksData2',
	FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\SmallWorksData2.ndf', 
	SIZE = 10MB, FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
) 
LOG ON (
	NAME = 'SmallWorks_log',
	FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\SmallWorks_log.ldf', 
	SIZE = 10MB, 
	FILEGROWTH = 10%, 
	MAXSIZE = 20MB 
)

USE master
GO

ALTER DATABASE SmallWorks  
ADD FILEGROUP Test1FG1;  
GO

ALTER DATABASE SmallWorks   
ADD FILE   
(  
    NAME = 'filedat1',  
    FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\filedat1.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 50MB,  
    FILEGROWTH = 20%  
),  
(  
    NAME = 'filedat2',  
    FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\CSDL\filedat2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 50MB,  
    FILEGROWTH = 20% 
)  
TO FILEGROUP Test1FG1;  
GO


---MODULE 1:

CREATE DATABASE Sales
ON PRIMARY (
	NAME = 'Sales',
	FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\Phan_Thanh_Tin\Sales.ndf', 
	SIZE = 10MB, 
	FILEGROWTH = 20%, 
	MAXSIZE = 50MB 
)
LOG ON (NAME = Sales_Log,
     FILENAME = 'E:\DOWNLOADS_G\Nam3HK2\KDL\Phan_Thanh_Tin\Sales_log.ldf',
     SIZE = 5 MB,
     MAXSIZE = 50MB,
     FILEGROWTH = 20%)
GO
Use Sales
-- 1  Tạo các kiểu dữ liêu người dùng
Exec sp_addtype 'Mota', 'nvarchar(40)', 'Not null'
Exec sp_addtype 'IDKH', 'char(10)', 'Not null'
Exec sp_addtype 'DT', 'char(12)', 'Not null'

Use Sales
Create Table SanPham
(
	MaSp char(6) not null,
	TenSp varchar(20) not null,
	NgayNhap Date not null,
	DVT char (10) not null,
	SoLuongTon Int not null,
	DonGiaNhap money not null
)



Create Table HoaDon
(
	MaHD char(10) not null,
	NgayLap date not null,
	NgayGiao Date not null,
	Makh IDKH not null,
	DienGiai Mota not null
)

Create Table KhachHang
(
	MaKH IDKH not null,
	TenKH nvarchar not null,
	DiaChi nvarchar not null,
	DienThoai DT not null
)

Create Table ChiTietHD
(
	MaHD char(10) not null ,
	MaSp char(6) not null,
	SoLuong int not null
)

--3
ALTER TABLE HoaDon 
ALTER COLUMN DienGiai nvarchar(100)
--4 
ALTER TABLE  SanPham
ADD TyleHoaHong float
--5 
ALTER TABLE SanPham
DROP COLUMN NgayNhap

--6. Tạo các ràng buộc khóa chính và khóa ngoại


ALTER TABLE SanPham ADD CONSTRAINT PK_SanPham Primary Key (MaSp);
ALTER TABLE HoaDon ADD CONSTRAINT PK_HoaDon Primary Key (MaHD);
ALTER TABLE KhachHang ADD CONSTRAINT PK_KhachHang Primary Key (MaKH);
ALTER TABLE ChiTietHD ADD CONSTRAINT PK_ChiTietHD Primary Key (MaHD,MaSp);


ALTER TABLE ChiTietHD ADD CONSTRAINT FK_MaHD FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD);
ALTER TABLE ChiTietHD ADD CONSTRAINT FK_MaSp FOREIGN KEY (MaSp) REFERENCES SanPham(MaSp);

ALTER TABLE HoaDon ADD CONSTRAINT FK_MaKH FOREIGN KEY (Makh) REFERENCES KhachHang(MaKH);


--7. Thêm ràng buộc
ALTER TABLE HoaDon
ADD CONSTRAINT check_ngay_giao CHECK ( NgayGiao >= NgayLap);

ALTER TABLE HoaDon
ADD CONSTRAINT CK_MaHD_Format CHECK (MaHD LIKE '[a-zA-Z][a-zA-Z][0-9][0-9][0-9][0-9]')


ALTER TABLE HoaDon
ADD CONSTRAINT DF_HoaDon_NgayLap
DEFAULT GETDATE() FOR NgayLap;

-- Cau 8
alter table SanPham
add constraint SoLuongTon CHECK (SoLuongTon BETWEEN 0 AND 500);

ALTER TABLE SanPham
ADD CONSTRAINT DonGiaNhap CHECK (DonGiaNhap > 0);

ALTER TABLE SanPham
ADD CONSTRAINT NgayNhap DEFAULT GETDATE() FOR NgayNhap;

ALTER TABLE SanPham
ADD CONSTRAINT CK_DVT CHECK (DVT IN ('KG', 'Thùng', 'Hộp', 'Cái'));

-- Cau 9: Nhap gia tri cho 4 bang 
INSERT INTO SanPham (MaSp, TenSp, DVT, SoLuongTon, DonGiaNhap, TyLeHoaHong) VALUES
('SP001', 'Sữa tươi Vinamilk', 'Thùng', 300, 150000, 0.1),
('SP002', 'Bánh mì trứng', 'Cái', 100, 5000, 0.05),
('SP003', 'Bia Sài Gòn', 'Thùng', 200, 30000, 0.07),
('SP004', 'Trà sen Vina', 'Hộp', 50, 25000, 0.1),
('SP005', 'Kẹo mút Chupa Chups', 'Cái', 150, 2000, 0.03);

INSERT INTO KhachHang (MaKH, TenKH, DiaChi, DienThoai) VALUES
('KH001', N'Nguyễn A', N'123 Đường số 1, Quận 1, TP.HCM', '0901234567'),
('KH002', N'Trần B', N'456 Đường số 2, Quận 2, TP.HCM', '0902345678'),
('KH003', N'Văn C', N'789 Đường số 3, Quận 3, TP.HCM', '0903456789'),
('KH004', N'Thị D', N'321 Đường số 4, Quận 4, TP.HCM', '0904567890'),
('KH005', N'Văn E', N'654 Đường số 5, Quận 5, TP.HCM', '0905678901');


INSERT INTO HoaDon (MaHD, NgayLap, NgayGiao, Makh, DienGiai)
VALUES 
    ('HD001', '2022-01-01', '2022-01-03', 'KH001', 'Hoa don ban le'),
    ('HD002', '2022-02-15', '2022-02-17', 'KH003', 'Hoa don ban si'),
    ('HD003', '2022-03-20', '2022-03-23', 'KH002', 'Hoa don thanh toan sau');

INSERT INTO ChiTietHD (MaHD, MaSp, SoLuong)
VALUES 
    ('HD001', 'SP001', 5),
    ('HD001', 'SP002', 3),
    ('HD002', 'SP003', 10),
    ('HD002', 'SP004', 20),
    ('HD003', 'SP001', 7),
    ('HD003', 'SP003', 12);

select * from SanPham
select *from HoaDon
select * from KhachHang
select *from ChiTietHD

-- Câu 10
--Không thể xóa được 1 hóa đơn bất kì trong bảng HoaDon. Vì bảng ChiTietHD có ràng buộc về khóa ngoại với bảng HoaDon. Nếu vẫn muốn xóa thì ta xóa 
--trong bảng ChiTietHD trước sau đó xóa nó xong bảng HoaDon 

---Cau 11
--Nhập 2 bản ghi mới vào bảng ChiTietHD với MaHD = ‘HD999999999’ vàMaHD=’1234567890’. Có nhập được không? Tại sao?
-- Không nhập được tại vì MaHD trong bảng ChiTietHD là khóa ngoại tham chiếu tới MaHD trong bảng HoaDon. Mà trong bảng HoaDon chưa có các mã hóa đơn trên
-- nên không thể nhập vào bảng ChiTietHoaDon được.

--Câu 12

ALTER DATABASE Sales MODIFY NAME = BanHang

--Câu 14
BACKUP DATABASE BanHang
TO DISK = 'E:\DOWNLOADS_G\Nam3HK2\KDL\Phan_Thanh_Tin\BanHang_Backup.bak'

--Câu 15
DROP DATABASE BanHang

--Câu 16
CREATE DATABASE BanHang

RESTORE DATABASE BanHang
FROM DISK = 'E:\DOWNLOADS_G\Nam3HK2\KDL\Phan_Thanh_Tin\BanHang_Backup.bak'
WITH REPLACE;


--MODULE 2
--Câu lệnh SELECT sử dụng các hàm thống kê với các mệnh đề Group by và Having:
--1)Liệt kê danh sách các hóa đon (SalesOrderlD) lập trong tháng 6 năm 2008 có tổng tiền >70000
SELECT soh.SalesOrderID, OrderDate, SUM(OrderQty * UnitPrice) AS SubTotal
FROM Sales.SalesOrderHeader as soh INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderDate BETWEEN '2013-06-01' AND '2013-6-30'
GROUP BY soh.SalesOrderID, OrderDate 

select max(sod.OrderDate), min(sod.OrderDate)
from Sales.SalesOrderHeader as sod

--2)Đếm tổng số khách hàng và tổng tiền của những khách hàng thuộc các quốc gia có mã vùng là US
SELECT st.TerritoryID, COUNT(DISTINCT c.CustomerID) AS countofCus, SUM(OrderQty * UnitPrice) AS Subtotal
FROM Sales.SalesTerritory as st INNER JOIN Sales.Customer as c
ON st.TerritoryID = c.TerritoryID 
INNER JOIN Sales.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail as sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE st.CountryRegionCode = 'US'
GROUP BY st.TerritoryID

--3)Tính tổng trị giá của những hóa đơn với Mã theo dôi giao hàng (CarrierTrackingNumber) có 3 ký tự đầu là 4BD
SELECT sod.SalesOrderID, CarrierTrackingNumber, SUM(OrderQty * UnitPrice) AS SubTotal
FROM Sales.SalesOrderDetail as sod INNER JOIN Sales.SalesOrderHeader as soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE CarrierTrackingNumber LIKE '4BD%'
GROUP BY sod.SalesOrderID, CarrierTrackingNumber

--4)Liệt kê các sản phẩm (Product) có đơn giá (UnitPrice) < 25 và số lượng bán trung bình > 5
SELECT p.ProductID, Name, AVG(OrderQty) as AverageofQty
FROM Production.Product as p INNER JOIN Sales.SalesOrderDetail as sod
ON p.ProductID = sod.ProductID
WHERE UnitPrice < 25
GROUP BY p.ProductID, Name
HAVING AVG(OrderQty) > 5 

--5)Liệt kê các công việc (JobTitle) có tổng số nhân viên >20 người
SELECT JobTitle, COUNT(*) AS countofPerson
FROM HumanResources.Employee
GROUP BY JobTitle
HAVING COUNT(*) > 20

--6)Tính tổng số lượng và tổng trị giá của các sản phẩm do các nhà cung cấp có tên kết thúc bằng ‘Bicycles’ và tổng trị giá > 800000
SELECT v.BusinessEntityID, v.Name AS VendorName, pod.ProductID, SUM(pod.OrderQty) AS SumOfQty, SUM(pod.LineTotal) AS SubTotal
FROM Purchasing.Vendor AS v JOIN Purchasing.PurchaseOrderHeader AS poh ON v.BusinessEntityID = poh.VendorID
JOIN Purchasing.PurchaseOrderDetail AS pod ON poh.PurchaseOrderID = pod.PurchaseOrderID
WHERE v.Name LIKE '%Bicycles'
GROUP BY v.BusinessEntityID, v.Name, pod.ProductID
HAVING SUM(pod.LineTotal) > 800000

--7)Liệt kê các sản phẩm có trên 500 đơn đặt hàng trong quí 1 năm 2008 và có tổng trị giá >10000
SELECT pod.ProductID, p.Name AS Product_name, COUNT(DISTINCT poh.PurchaseOrderID) AS countofOrderID, SUM(pod.OrderQty * pod.UnitPrice) AS Subtotal
FROM Purchasing.PurchaseOrderHeader poh JOIN Purchasing.PurchaseOrderDetail pod ON poh.PurchaseOrderID = pod.PurchaseOrderID 
JOIN Production.Product p ON pod.ProductID = p.ProductID
WHERE YEAR(POH.OrderDate) = 2008
AND MONTH(POH.OrderDate) BETWEEN 1 AND 3
GROUP BY pod.ProductID,p.Name
HAVING COUNT(DISTINCT POH.PurchaseOrderID) >= 500
AND SUM(POD.OrderQty * POD.UnitPrice) > 10000

--8)Liệt kê danh sách các khách hàng có trên 25 hóa đơn đặt hàng từ năm 2007 đến 2008
SELECT PersonID, COUNT(SalesOrderID) AS CountOfOrders
FROM Sales.Customer INNER JOIN Sales.SalesOrderHeader
ON Sales.Customer.CustomerID = Sales.SalesOrderHeader.CustomerID
WHERE OrderDate BETWEEN '2007-01-01' AND '2008-12-31'
GROUP BY PersonID
HAVING COUNT(SalesOrderID) > 25

--9)Liệt kê những sản phẩm có tên bắt đầu với ‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi năm trên 500 sản phẩm
SELECT p.ProductID, p.Name, SUM(sod.OrderQty) AS CountOfOrderQty, YEAR(soh.OrderDate) AS Year
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE (p.Name LIKE 'Bike%' OR p.Name LIKE 'Sport%')
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate)
HAVING SUM(sod.OrderQty) > 500;

--10) Liệt kê những phòng ban có lương (Rate: lương theo giờ) trung bình >30
SELECT d.DepartmentID, d.[Name], AVG(p.Rate) AS AvgofRate
FROM HumanResources.Department d
INNER JOIN HumanResources.EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
INNER JOIN HumanResources.EmployeePayHistory p ON edh.BusinessEntityID = p.BusinessEntityID
GROUP BY d.DepartmentID, d.[Name]
HAVING AVG(p.Rate) > 30

-- II. Subquery
-- SUB QUERY
 --1)Liệt kê các sản phẩm gồm các thông tin Product Names và Product ID có trên 100 đơn đặt hàng trong tháng 7 năm 2008
SELECT p.Name AS ProductName, p.ProductID, COUNT(sod.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderDetail AS sod
JOIN Production.Product AS p ON sod.ProductID = p.ProductID
JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2013 AND MONTH(soh.OrderDate) = 7
GROUP BY p.Name, p.ProductID
HAVING COUNT(sod.SalesOrderID) >= 100

--2)Liệt kê các sản phẩm (ProductID, Name) có số hóa đem đặt hàng nhiều nhất trong tháng 7/2008
SELECT p.ProductID, p.Name, COUNT(sod.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2013 AND MONTH(soh.OrderDate) = 7
GROUP BY p.ProductID, p.Name
ORDER BY OrderCount DESC

--3)Hiển thị thông tin của khách hàng cổ số đơn đặt hàng nhiều nhất, thông tin gồm: CustomerlD, Name, CountOíOrder
SELECT TOP 100 c.CustomerID, COUNT(soh.SalesOrderID) AS CountOfOrder
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
WHERE MONTH(soh.OrderDate) = 7 AND YEAR(soh.OrderDate) = 2013
GROUP BY c.CustomerID
ORDER BY CountOfOrder DESC;

--4)Liệt kê các sản phẩm (ProductID, Name) thuộc mô hình sản phẩm áo dài tay với tên bắt đầu với “Long-Sleeve Logo Jersey”, dùng IN và EXISTS
SELECT ProductID, Name
FROM Production.Product
WHERE ProductModelID IN (
  SELECT ProductModelID 
  FROM Production.ProductModel 
  WHERE Name = 'Long-Sleeve Logo Jersey'
) AND Name LIKE 'Long-Sleeve Logo Jersey%';

SELECT ProductID, Name
FROM Production.Product p
WHERE EXISTS (
  SELECT * 
  FROM Production.ProductModel pm
  WHERE pm.ProductModelID = p.ProductModelID
  AND pm.Name = 'Long-Sleeve Logo Jersey'
) AND Name LIKE 'Long-Sleeve Logo Jersey%';

--5)Tìm các mô hình sản phẩm (ProductModelID) mà giá niêm yết (list price) tối đa cao hom giá trung bình của tất cả các mô hình.
SELECT ProductModelID
FROM Production.Product
GROUP BY ProductModelID
HAVING MAX(ListPrice) > (SELECT AVG(ListPrice) FROM Production.Product)

-- 6)Liệt kê các sản phẩm gồm các thông tin ProductID, Name, có tổng số lượng đặt hàng > 5000 
SELECT Product.ProductID, Product.Name
FROM Production.Product
WHERE Product.ProductID IN (
  SELECT SalesOrderDetail.ProductID
  FROM Sales.SalesOrderDetail
  GROUP BY SalesOrderDetail.ProductID
  HAVING SUM(SalesOrderDetail.OrderQty) > 5000
)

-- 7)Liệt kê những sản phẩm (ProductlD, UnitPrice) có đơn giá (UnitPrice) cao nhất trong bảng Sales.SalesOrderDetail
SELECT TOP 10 ProductID, UnitPrice
FROM Sales.SalesOrderDetail
ORDER BY UnitPrice DESC;

--8)Liệt kê các sản phẩm không có đom đặt hàng nào thông tin gồm ProductlD, Nam; dùng 3 cách Not in, Not exists và Left join.
-- su dung in
SELECT ProductID, Name 
FROM Production.Product 
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail)
-- su dung not exist
SELECT ProductID, Name 
FROM Production.Product AS p
WHERE NOT EXISTS 
    (SELECT * FROM Sales.SalesOrderDetail AS sod 
     WHERE sod.ProductID = p.ProductID)
-- su dung left join
SELECT p.ProductID, p.Name
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL


--10)Liệt kê danh sách các khách hàng (CustomerlD, Name) có hóa đom dặt hàng trong năm 2007 nhưng không có hóa đom đặt hàng trong năm 2008
SELECT c.CustomerID
FROM Sales.Customer as c
WHERE c.CustomerID NOT IN (
    SELECT o.CustomerID
    FROM Sales.SalesOrderHeader o
    WHERE YEAR(o.OrderDate) = 2008
)
AND c.CustomerID IN (
    SELECT o.CustomerID
    FROM Sales.SalesOrderHeader o
    WHERE YEAR(o.OrderDate) = 2007
)

-- Tuần 3:
--Câu 1: tạo 2 bảng mới trong csdl Adventureworks2008 là MyDepartment và MyEmployee
create table MyDepartment (
DepID smallint not null primary key, 
DepName nvarchar(50) , 
GrpName nvarchar(50) 
)
create table MyEmployee (
EmpID int not null primary key, 
FrstName nvarchar(50) , 
MidName nvarchar(50) ,
LstName nvarchar(50) ,
DepID smallint not null,
CONSTRAINT FK_MyEmployee_MyDepartment
foreign key (DepID)references MyDepartment(DepID)
)

--Câu 2: lấy dữ liệu từ bảng HumanResources.Department chèn vào bảng MyDepartment
INSERT INTO MyDepartment (DepID, DepName, GrpName)
SELECT DepartmentID, Name, GroupName FROM HumanResources.Department

--Câu 3: lấy dữ liệu từ bảng Person và EmployeeDepartmentHistory  chèn vào bảng MyEmployee
INSERT INTO MyEmployee (EmpID, FrstName, MidName, LstName, DepID)
SELECT TOP 20 p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName, edh.DepartmentID
FROM Person.Person p
JOIN HumanResources.EmployeeDepartmentHistory edh ON p.BusinessEntityID = edh.BusinessEntityID

--Câu 4
--Dùng lệnh delete xóa 1 record hong bảng MyDepartment với DepID= 1, có thực hiện được không? Vì sao?
select *from MyDepartment
DELETE FROM MyDepartment
WHERE DepID = 1;
-- kết quả xóa được 1 record trong bảng MyDepartment với DepID =1 vì trong bảng MyEmployee không có DepID nào bằng 1 hết

--Câu 5:Thêm một default constraint vào field DepID trong bảng MyEmployee, với giá trị mặc định là 1.
ALTER TABLE MyEmployee
ADD CONSTRAINT DF_MyEmployee_DepID DEFAULT 1 FOR DepID;

--Câu 6:Nhập thêm một record mới trong bảng MyEmployee, theo cú pháp sau: insert into MyEmployee (EmpID, FrstName, MidName, LstName) values(l, 'Nguyên'Nhat'Nam')
insert into MyEmployee (EmpID, FrstName, MidName, LstName) values(1, N'Nguyên',N'Nhật',N'Nam')
select * from MyDepartment
-- kết quả không thêm vào được

--Câu 7:Xóa foreign key constraint trong bảng MyEmployee
ALTER TABLE MyEmployee
DROP CONSTRAINT FK_MyEmployee_MyDepartment;

--thiết lập lại khóa ngoại DepID tham chiếu đến DepID của bảng MyDepartment với thuộc tính on delete set default.
ALTER TABLE MyEmployee
ADD CONSTRAINT FK_MyEmployee_MyDepartment FOREIGN KEY (DepID)
REFERENCES MyDepartment (DepID)
ON DELETE SET DEFAULT;

--Câu 8:Xóa một record trong bảng MyDepartment có DepID=7, quan sát kết quả trong hai bảng MyEmployee và MyDepartment
DELETE FROM MyDepartment 
WHERE DepID = 7;

--Câu 9:Xóa foreign key trong bảng MyEmployee. 
ALTER TABLE MyEmployee 
DROP CONSTRAINT FK_MyEmployee_MyDepartment;

--Hiệu chỉnh ràng buộc khóa ngoại DepID trong bảng MyEmployee, thiết lập thuộc tính on delete cascade và on update cascade
ALTER TABLE MyEmployee
ADD CONSTRAINT FK_MyEmployee_MyDepartment FOREIGN KEY (DepID)
REFERENCES MyDepartment (DepID)
ON DELETE CASCADE 
ON UPDATE CASCADE;

--Câu 10:Thực hiện xóa một record trong bảng MyDepartment với DepID =3, có thực hiện được không?
DELETE FROM MyDepartment 
WHERE DepID = 3;
-- kết quả là thực hiện được 

--Câu 11:Thêm ràng buộc check vào bảng MyDepartment tại field GrpName, chỉ cho phép nhận thêm những Department thuộc group Manufacturing
ALTER TABLE MyDepartment
ADD CONSTRAINT ck_department_group
CHECK (GrpName IN ('Manufacturing'))

--Câu 12:Thêm ràng buộc check vào bảng [HumanResources].[Employee], tại cột BirthDate, chỉ cho phép nhập thêm nhân viên mới có tuổi từ 18 đến 60
ALTER TABLE HumanResources.Employee
ADD CONSTRAINT ck_birthdate
CHECK (DATEDIFF(year, BirthDate, GETDATE()) BETWEEN 18 AND 60)

					--Module 3:
--1)Tạo view dbo.vw_Products hiển thị danh sách các sản phẩm từ bảng Production.Product và bảng Production.ProductCostHistory. Thông tin bao gồm ProductID, Name, Color, Size, Style, Standardcost, EndDate, StartDate
CREATE VIEW dbo.vw_Products 
AS
SELECT p.ProductID, p.Name, p.Color, p.Size, p.Style, pc.StandardCost, pc.EndDate, pc.StartDate
FROM Production.Product p JOIN Production.ProductCostHistory pc 
ON p.ProductID = pc.ProductID;

--2)Tạo view List_Product_View chứa danh sách các sản phẩm có trên 500 đơn đặt hàng trong quí 1 năm 2008 và có tổng trị giá >10000, thông tin gồm ProductlD, Product Name, CountOíOrderlD và SubTotal.
CREATE VIEW List_Product_View 
AS
SELECT od.ProductID, p.Name, COUNT(DISTINCT od.SalesOrderID) AS CountOíOrderlD, SUM(od.LineTotal) AS SubTotal
FROM Sales.SalesOrderDetail od
JOIN Sales.SalesOrderHeader oh ON od.SalesOrderID = oh.SalesOrderID
JOIN Production.Product p ON od.ProductID = p.ProductID
WHERE DATEPART(QUARTER, oh.OrderDate) = 1 AND YEAR(oh.OrderDate) = 2008
GROUP BY od.ProductID, p.Name
HAVING COUNT(DISTINCT od.SalesOrderID) > 500 AND SUM(od.LineTotal) > 10000;
 
--3)Tạo view dbo.vw CustomerTotals hiển thị tổng tiền bán được (total sales) từ cột TotalDue của mỗi khách hàng (customer) theo tháng và theo năm. Thông tin gồm CustomerlD, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, SUM(TotalDue).
CREATE VIEW dbo.vw_CustomerTotals
AS
SELECT c.CustomerID, YEAR(so.OrderDate) AS OrderYear, MONTH(so.OrderDate) AS OrderMonth, SUM(so.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader so
JOIN Sales.Customer c ON so.CustomerID = c.CustomerID
GROUP BY c.CustomerID, YEAR(so.OrderDate), MONTH(so.OrderDate);

--4)Tạo view trả về tong số lượng sản phẩm (Total Quantity) bán được của mỗi nhân viên theo từng năm. Thông tin gồm SalesPersonlD, OrderYear, sumOfOrderQty
CREATE VIEW dbo.vw_EmployeeSales
AS
SELECT soh.SalesPersonID AS SalesPersonlD, YEAR(soh.OrderDate) AS OrderYear, SUM(sod.OrderQty) AS sumOfOrderQty
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE soh.SalesPersonID IS NOT NULL
GROUP BY soh.SalesPersonID, YEAR(soh.OrderDate);


--5)Tạo view ListCustomer view chứa danh sách các khách hàng có trên 25 hóa đơn đặt hàng từ năm 2007 đến 2008, thông tin gồm mã khách (PersonlD) , họ tên (FirstName +' '+ LastName as FullName), số hóa đơn (CountOfOrders).
CREATE VIEW dbo.ListCustomer
AS
SELECT c.CustomerID AS PersonID, COUNT(*) AS CountOfOrders
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE YEAR(soh.OrderDate) BETWEEN 2007 AND 2008
GROUP BY c.CustomerID
HAVING COUNT(*) > 25;

--6)Tạo view ListProduct view chứa danh sách những sản phẩm có tên bắt đầu với ‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi năm trên 50 sản phẩm, thông tin gồm ProductID, Name, SumOfOrderQty, Year
CREATE VIEW dbo.ListProduct
AS
SELECT p.ProductID, p.Name, YEAR(soh.OrderDate) AS Year, SUM(sod.OrderQty) AS SumOfOrderQty
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID
WHERE p.Name LIKE 'Bike%' OR p.Name LIKE 'Sport%'
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate)
HAVING SUM(sod.OrderQty) > 50;

--7)Tạo view List department view chứa danh sách các phòng ban có lương (Rate: lương theo giờ) trung bình >30, thông tin gồm Mã phòng ban (DepartmentlD), tên phòng ban (Name), Lương trung bình (AvgOfRate)
CREATE VIEW dbo.ListDepartment
AS
SELECT d.DepartmentID AS DepartmentlD, d.Name, AVG(eh.Rate) AS AvgOfRate
FROM HumanResources.Department d
JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.DepartmentID = d.DepartmentID
JOIN HumanResources.EmployeePayHistory eh ON eh.BusinessEntityID = edh.BusinessEntityID
GROUP BY d.DepartmentID, d.Name
HAVING AVG(eh.Rate) > 30;

--8)Tạo view Sales.vw OrderSummary với từ khóa WITH ENCRYPTION gồm OrderYear (năm của ngày lập), OrderMonth (tháng của ngày lập), OrderTotal (tổng tiền)
CREATE VIEW Sales.vwOrderSummary
WITH ENCRYPTION
AS
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, SUM(TotalDue) AS OrderTotal
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)

--9)Tạo view Production.vwProducts với từ khóa WITH SCHEMABINDING gồm ProductID, Name, StartDate,EndDate,ListPrice của bảng Product và bảng ProductCostHistory. Xem thông tin của View. Xóa cột ListPrice của bảng Product. Có xóa được không? Vì sao?
CREATE VIEW Production.vwProducts 
WITH SCHEMABINDING 
AS
SELECT p.ProductID, p.Name, p.SellStartDate, p.SellEndDate, p.ListPrice, h.StartDate AS CostStartDate, h.EndDate AS CostEndDate, h.StandardCost
FROM Production.Product p
JOIN Production.ProductCostHistory h ON p.ProductID = h.ProductID;

select *from Production.vwProducts
--Sau đó, để xóa cột ListPrice của bảng Product, ta có thể sử dụng câu lệnh ALTER TABLE như sau:
ALTER TABLE Production.Product DROP COLUMN ListPrice;
--Tuy nhiên, vì view Production.vwProducts đã được tạo với WITH SCHEMABINDING và dựa trên cột ListPrice của bảng Product, nên nếu ta thực hiện lệnh này, sẽ xảy ra lỗi
--Để xóa cột ListPrice của bảng Product, ta phải xóa view Production.vwProducts trước đó.

--10) Tạo view view Department với từ khóa WITH CHECK OPTION chỉ chứa các phòng thuộc nhóm có tên (GroupName) là “Manufacturing” và “Quality Assurance”, thông tin gồm: DepartmentlD, Name, GroupName.
CREATE VIEW Department 
AS 
SELECT DepID, DepName, GrpName 
FROM MyDepartment 
WHERE GrpName IN ('Manufacturing', 'Quality Assurance')
WITH CHECK OPTION;
--a) Chúng ta không thể chèn được phòng ban khác ngoài 2 phòng ban trên vì chúng ta đã sử dụng từ khóa with check option trong câu lệnh tạo view.

-- b) Chèn thêm 2 phòng ban mới thuộc group manufaturing và quality assurance
INSERT INTO Department VALUES (17,'abcd','Manufacturing')
INSERT INTO Department VALUES (18,'efgh','Quality Assurance')

-- c) Xem kết quả trong Department
SELECT *FROM Department


-- MODULE 4:
Câu 1:
DECLARE @tongsoHD int
SELECT @tongsoHD = COUNT(*) FROM Sales.SalesOrderDetail WHERE ProductID = '778'
IF @tongsoHD > 500
    PRINT 'Sản phẩm 778 có trên 500 đơn hàng'
ELSE
    PRINT 'Sản phẩm 778 có ít đơn đặt hàng'
Câu 2:
DECLARE @makh int, @nam int, @n int
SELECT @makh = 27611, @nam = 2008
SELECT @n = COUNT(*) FROM Sales.SalesOrderHeader WHERE CustomerID = @makh AND YEAR(OrderDate) = @nam
IF @n > 0
    PRINT 'Khách hàng ' + CAST(@makh as nvarchar(50))  + ' có ' + CAST(@n AS nvarchar(10)) + ' hóa đơn trong năm ' + CAST(@nam AS nvarchar(4))
ELSE
    PRINT 'Khách hàng ' + CAST(@makh as nvarchar(50))  + ' không có hóa đơn nào trong năm ' + CAST(@nam AS nvarchar(4))
GO
Câu 3:
SELECT SalesOrderID, SUM(LineTotal) AS SubTotal,
CASE 
    WHEN SUM(LineTotal) < 100000 THEN 0 
    WHEN SUM(LineTotal) >= 100000 AND SUM(LineTotal) < 120000 THEN 0.05 * SUM(LineTotal) 
    WHEN SUM(LineTotal) >= 120000 AND SUM(LineTotal) < 150000 THEN 0.1 * SUM(LineTotal) 
    ELSE 0.15 * SUM(LineTotal) 
END AS Discount
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal) > 100000
Câu 4:
DECLARE @mancc INT, @masp INT, @soluongcc INT;
select @mancc = 421,@masp = 1616
SELECT @soluongcc = OnOrderQty
FROM Purchasing.ProductVendor
WHERE ProductID = @mancc AND BusinessEntityID = @masp;
IF @soluongcc IS NULL
    PRINT 'Nhà cung cấp ' + CAST(@mancc AS NVARCHAR(10)) + ' không cung cấp sản phẩm ' + CAST(@masp AS NVARCHAR(10))
ELSE
    PRINT 'Nhà cung cấp ' + CAST(@mancc AS NVARCHAR(10)) + ' cung cấp sản phẩm ' + CAST(@masp AS NVARCHAR(10)) + ' với số lượng là ' + CAST(@soluongcc AS VARCHAR(10));
Câu 5:
WHILE (SELECT SUM(rate) FROM [HumanResources].[EmpLoyeePayHistory]) < 6000 BEGIN
	UPDATE [HumanResources].[EmpLoyeePayHistory] SET rate = rate*1.1
		IF (SELECT MAX(rate)FROM 
		[HumanResources].[EmpLoyeePayHistory]) > 150 BREAK
		ELSE
			CONTINUE
END
+Stored Procedure:
Câu 1:
CREATE PROCEDURE GetTotalDueByCustomerAndMonthYear
    @month INT,
    @year INT
AS
BEGIN
    SELECT CustomerID, SUM(TotalDue) AS SumOfTotalDue
    FROM Sales.SalesOrderHeader
    WHERE MONTH(OrderDate) = @month AND YEAR(OrderDate) = @year
    GROUP BY CustomerID
END

--Thủ tục GetTotalDueByCustomerAndMonthYear được tạo ra để tính tổng tiền thu (TotalDue) của mỗi khách hàng trong một tháng và năm cụ thể được truyền vào thông qua các tham số @month và @year.
--Truy vấn lấy dữ liệu từ bảng Sales.SalesOrderHeader với điều kiện là MONTH(OrderDate) = @month và YEAR(OrderDate) = @year, tức là chỉ lấy các hóa đơn được tạo ra trong tháng và năm được truyền vào.
--Sử dụng hàm SUM để tính tổng tiền thu (TotalDue) của mỗi khách hàng, và sử dụng GROUP BY để nhóm kết quả theo CustomerID.


Câu 2:
CREATE PROCEDURE GetSalesYTD
  @Salesperson nvarchar(50),
  @SalesYTD money OUTPUT
AS
BEGIN
  SELECT @SalesYTD = SalesYTD
  FROM Sales.SalesPerson
  WHERE BusinessEntityID = @Salesperson
END
Go

Ví dụ:
DECLARE @SalesYTD money
EXEC GetSalesYTD 290, @SalesYTD OUTPUT
SELECT @SalesYTD as SalesYTD

Câu 3:
CREATE PROCEDURE ListProduct
	@MaxPrice MONEY
AS
BEGIN
	SELECT ProductID, ListPrice
	FROM Production.Product
	WHERE ListPrice <= @MaxPrice
END

-- Test
EXEC ListProduct 150000

Câu 4:
CREATE PROCEDURE NewBonus
    @SalesPersonlD INT
AS
BEGIN
    UPDATE Sales.SalesPerson
    SET Bonus = Bonus + (SELECT SUM(SubTotal) * 0.01 FROM Sales.SalesOrderHeader WHERE SalesPersonID = @SalesPersonlD)
    WHERE BusinessEntityID = @SalesPersonlD
END
Khi thực thi thủ tục NewBonus, nó sẽ tính toán tổng doanh thu của nhân viên bán hàng đó và cập nhật mức thưởng mới vào bảng SalesPerson. 
Chạy thử
Exec dbo.NewBonus 285
Câu 5:
CREATE PROC ViewProductCategory
@Year int
AS
BEGIN
	Select PC.ProductCategoryID, PC.Name, Sum(SSD.OrderQty) as SumOfQty
	From Production.ProductCategory PC
		join Production.ProductSubcategory PPS ON PC.ProductCategoryID = PPS.ProductCategoryID
		Join Production.Product PP ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
		Join Sales.SalesOrderDetail SSD ON PP.ProductID = SSD.ProductID
		Join Sales.SalesOrderHeader SSOH ON SSD.SalesOrderID = SSOH.SalesOrderID
	Where PC.ProductCategoryID =(
		Select Top 1 PC2.ProductCategoryID  from Production.ProductCategory PC2
			Join Production.ProductSubcategory PPS2 ON PC2.ProductCategoryID = PPS2.ProductCategoryID
			Join Production.Product PP2 ON PPS.ProductSubcategoryID = PP2.ProductSubcategoryID
			Join Sales.SalesOrderDetail SSD2 ON PP2.ProductID = SSD2.ProductID
			Join Sales.SalesOrderHeader SSOH2 ON SSD2.SalesOrderID = SSOH2.SalesOrderID
		WHERE YEAR(SSOH2.OrderDate) = @Year
		Group By PC2.ProductCategoryID
		Order By Sum(SSD2.OrderQty))
	GROUP BY   PC.ProductCategoryID, PC.Name
END

EXEC ViewProductCategory 2011

/*Trong thủ tục này, chúng ta sử dụng một câu lệnh SELECT để truy vấn các thông tin cần thiết từ bảng ProductCategory, ProductSubcategory, Product và SalesOrderDetail. 
Trong phần WHERE của truy vấn, chúng ta sử dụng điều kiện YEAR(SOH.OrderDate) = @Year để lấy ra các đơn đặt hàng trong năm được truyền vào. Trong phần SELECT, chúng ta
tính tổng số lượng đặt hàng (SumOfQty) của mỗi nhóm sản phẩm (ProductCategory) bằng cách sử dụng hàm SUM.
Để tìm nhóm sản phẩm có tổng số lượng đặt hàng cao nhất trong năm, chúng ta sử dụng một câu lệnh con (subquery) để lấy ra ProductCategoryID của nhóm sản phẩm đó. Câu lệnh con này có cùng các điều kiện WHERE với câu lệnh chính, nhưng không có phần GROUP BY và chỉ lấy TOP 1 kết quả đã được sắp xếp theo thứ tự giảm dần của tổng số lượng đặt hàng (SUM(SOD2.OrderQty) DESC). Cuối cùng, chúng ta lọc kết quả của truy vấn chính bằng cách chỉ lấy nhóm sản phẩm có ProductCategoryID tương ứng với kết quả trả về của câu l */

Câu 6:
CREATE PROCEDURE TongThu 
    @EmployeeID INT,
    @TotalSales MONEY OUTPUT
AS
BEGIN
    SELECT @TotalSales = SUM(SubTotal) 
    FROM Sales.SalesOrderHeader 
    WHERE SalesPersonID = @EmployeeID;
	Return 1
    IF (@TotalSales > 0)
        RETURN 0; -- trả về trạng thái thành công nếu có dữ liệu
    ELSE
        RETURN 1; -- trả về trạng thái thất bại nếu không có dữ liệu
END

Chạy thử:
DECLARE @TotalSales money
Exec TongThu 2344, @TotalSales OutPut
Select @TotalSales

Câu 7:
CREATE PROC HienThi
@Year int
AS
BEGIN
	SELECT TOP 1 Name, SubTotal
	FROM Purchasing.PurchaseOrderHeader 
		Join Purchasing.Vendor ON Purchasing.PurchaseOrderHeader.VendorID = Purchasing.Vendor.BusinessEntityID
	WHERE YEAR(OrderDate) = @Year
	ORDER BY SubTotal DESC
END

EXEC HienThi 2012

Câu8:


Câu 9:
CREATE PROC XoaHD 
@SalesOrderID int
AS
BEGIN
	IF EXISTS(Select *from Sales.SalesOrderDetail where SalesOrderID = @SalesOrderID)
		BEGIN
			Delete from Sales.SalesOrderDetail where Sales.SalesOrderDetail.SalesOrderID = @SalesOrderID
			Delete from Sales.SalesOrderHeader where Sales.SalesOrderHeader.SalesOrderID = @SalesOrderID
		END
	ELSE
		Delete from Sales.SalesOrderHeader where Sales.SalesOrderHeader.SalesOrderID = @SalesOrderID

END

Câu 10:
CREATE PROC Sp_Update_Product 
@ProductID int
AS
BEGIN
	if @ProductID is not null
		BEGIN 
			SELECT ProductID, ListPrice = ListPrice*1.1 
			FROM Production.Product
			WHERE ProductID = @ProductID
		END
	ELSE	
		Print 'Không có sản phẩm này'
END

Chạy thử:
EXEC Sp_Update_Product 522

+Function:

Câu 1:
CREATE FUNCTION CountOfEmployees(@mapb INT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT
    SELECT @count = COUNT(*)
    FROM HumanResources.EmployeeDepartmentHistory
    WHERE DepartmentID = @mapb
    RETURN @count
END
--Câu lệnh trên sẽ tạo ra một hàm scalar function có tên CountOfEmployees, với một tham số đầu vào là @mapb kiểu INT. Hàm sẽ trả về số lượng nhân viên trong phòng ban tương ứng với giá trị truyền vào tham số @mapb.
SELECT Department.DepartmentID, Department.Name, dbo.CountOfEmployees(Department.DepartmentID) AS countOfEmp
FROM HumanResources.Department
JOIN HumanResources.EmployeeDepartmentHistory ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
GROUP BY Department.DepartmentID, Department.Name
--Câu truy vấn này sử dụng INNER JOIN để kết nối bảng Department và EmployeeDepartmentHistory thông qua trường DepartmentID. Sau đó, câu truy vấn sử dụng GROUP BY để nhóm các bản ghi theo DepartmentID và Name và sử dụng hàm CountOfEmployees để tính số lượng nhân viên của mỗi phòng ban. Kết quả trả về là danh sách các phòng ban với số nhân viên của mỗi phòng ban.


Câu 2:
CREATE FUNCTION InventoryProd (@ProductID INT, @LocationID INT)
RETURNS INT
AS
BEGIN
    DECLARE @InventoryQty INT
    SELECT @InventoryQty = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID AND LocationID = @LocationID
    RETURN @InventoryQty
END
/*Trong đó, hàm này sử dụng hai tham số đầu vào @ProductID và @LocationID để xác định sản phẩm và khu vực tương ứng. 
Sau đó, câu lệnh SELECT được sử dụng để truy vấn bảng Production.ProductInventory để lấy số lượng sản phẩm có sẵn trong khu vực tương ứng 
và lưu trữ giá trị đó vào biến @InventoryQty. Cuối cùng, hàm trả về giá trị @InventoryQty.
Select dbo.InventoryProd(1, 1) As SumQuantity */

Câu 3:
Create FUNCTION SubTotalOfEmp(@EmplID INT, @MonthOrder INT, @YearOrder INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @SubTotalEmp MONEY
	Select @SubTotalEmp = Sum(SubTotal)
	FROM Sales.SalesOrderHeader
	WHERE SalesPersonID = @EmplID
	AND MONTH(OrderDate) = @MonthOrder
	AND YEAR(OrderDate) = @YearOrder
	RETURN @SubTotalEmp
END

/* Lưu ý rằng hàm này sử dụng bảng Sales.SalesOrderHeader để tính tổng doanh thu của một nhân viên trong một tháng và năm cụ thể. Tham số đầu vào là @EmplID để chỉ định nhân viên, @MonthOrder và @YearOrder để chỉ định tháng và năm. Hàm trả về giá trị kiểu MONEY là tổng doanh thu của nhân viên trong tháng và năm đó.
Select dbo.SubTotalOfEmp(279, 5, 2011) as SubTotalOfEmp */

Câu 4:
CREATE FUNCTION SumOfOrder (@thang int, @nam int)
RETURNS TABLE 
AS
RETURN 
	Select SOH.SalesOrderID, SOH.OrderDate, SUM(SOD.OrderQty*SOD.UnitPrice) AS SubTotal
	FROM Sales.SalesOrderDetail SOD
	Join Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
	WHERE MONTH(SOH.OrderDate) = @thang AND YEAR(SOH.OrderDate) = @nam AND SubTotal > 7000
	GROUP BY
	SOH.SalesOrderID,
	SOH.OrderDate
/* Hàm này sử dụng câu lệnh SELECT để truy vấn các hóa đơn (SalesOrderlD) lập trong tháng và năm được truyền vào từ hai tham số @thang và @nam, với điều kiện tổng tiền (SubTotal) lớn hơn 7000. Giá trị SubTotal được tính bằng cách nhân OrderQty với UnitPrice, theo công thức SubTotal = sum(OrderQty * UnitPrice).
Select *from SumOfOrder(5, 2011) */

Câu 5: Chưa test
CREATE FUNCTION NewBonus()
RETURNS TABLE
AS
RETURN
    SELECT SalesPersonID, Bonus + SumOfSubTotal * 0.01 AS NewBonus, SumOfSubTotal
    FROM (
        SELECT SalesPersonID, Bonus, SUM(SubTotal) AS SumOfSubTotal
        FROM Sales.SalesOrderHeader
        JOIN Sales.SalesPerson ON Sales.SalesOrderHeader.SalesPersonID = Sales.SalesPerson.BusinessEntityID
        GROUP BY SalesPersonID, Bonus
    ) AS T;
/* Hàm này sử dụng câu lệnh SELECT để truy vấn dữ liệu từ hai bảng SalesOrderHeader và SalesPerson. Câu lệnh này sẽ tính toán lại tiền thưởng (NewBonus) cho mỗi nhân viên bán hàng, dựa trên tổng doanh thu của mỗi nhân viên. Cụ thể, giá trị NewBonus được tính bằng cách thêm 1% tổng doanh thu (SumOfSubTotal) vào mức thưởng hiện tại (Bonus).
Để tính tổng doanh thu, hàm sử dụng câu lệnh JOIN để kết nối hai bảng SalesOrderHeader và SalesPerson. Sau đó, nó sử dụng câu lệnh GROUP BY để nhóm các hóa đơn theo SalesPersonID và tính tổng doanh thu của mỗi nhân viên (SumOfSubTotal). */

--- Test:
Select *from fnc_NewBonus()

Câu 6:
CREATE FUNCTION SumOfProduct (@MaNCC INT)
RETURNS TABLE
AS
RETURN
    SELECT POD.ProductID, SUM(POD.OrderQty) AS SumOfQty, SUM(POD.LineTotal) AS SumOfSubTotal
    FROM Purchasing.PurchaseOrderDetail AS POD
    JOIN Purchasing.PurchaseOrderHeader AS POH ON POD.PurchaseOrderID = POH.PurchaseOrderID
    JOIN Purchasing.Vendor AS V ON POH.VendorID = V.BusinessEntityID
    WHERE V.BusinessEntityID = @MaNCC
    GROUP BY POD.ProductID;
/* Hàm này sử dụng các bảng Purchasing.Vendor, Purchasing.PurchaseOrderHeader và Purchasing.PurchaseOrderDetail 
để tính tổng số lượng (SumOfQty) và tổng trị giá (SumOfSubTotal) của các sản phẩm do nhà cung cấp cung cấp. 
Cột ProductID là mã sản phẩm, cột SumOfQty là tổng số lượng của sản phẩm đó, và cột SumOfSubTotal là tổng trị giá của sản phẩm đó.  */

-- Test
Select *from SumOfProduct(1520)

Câu 7:
CREATE FUNCTION Discount_Func (@SalesOrderID INT)
RETURNS TABLE
AS
RETURN
    SELECT SalesOrderID, SubTotal,
        CASE 
            WHEN SubTotal < 1000 THEN 0
            WHEN SubTotal >= 1000 AND SubTotal < 5000 THEN SubTotal * 0.05
            WHEN SubTotal >= 5000 AND SubTotal < 10000 THEN SubTotal * 0.1
            ELSE SubTotal * 0.15
        END AS Discount
    FROM Sales.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;
-- test
Select *from Discount_Func(43659)

Câu 8:
CREATE FUNCTION TotalOfEmp (@MonthOrder INT, @YearOrder INT)
RETURNS TABLE
AS
RETURN
(
    SELECT SOH.SalesPersonID, SUM(SOH.SubTotal) AS Total
    FROM Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesPerson SP ON SOH.SalesPersonID = SP.BusinessEntityID
    WHERE MONTH(SOH.OrderDate) = @MonthOrder AND YEAR(SOH.OrderDate) = @YearOrder
    GROUP BY SOH.SalesPersonID
)
/* Để tính tổng doanh thu, ta sử dụng câu lệnh SELECT để lấy dữ liệu từ bảng SalesOrderHeader và SalesPerson, 
sau đó sử dụng INNER JOIN để kết hợp các bảng theo SalesPersonID. Điều kiện WHERE được sử dụng để lọc các đơn hàng theo tháng 
và năm truyền vào thông qua tham số @MonthOrder và @YearOrder. Cuối cùng, ta sử dụng GROUP BY để nhóm các đơn hàng theo SalesPersonID
và tính tổng doanh thu bằng cách sử dụng hàm SUM trên cột SubTotal trong bảng SalesOrderHeader. */

-- Test
select *from TotalOfEmp(5,2011)

Câu 9:
- Viết lại câu 5:
CREATE FUNCTION NewBonus_Multi_statement ()
RETURNS @result TABLE (
    SalesPersonID INT,
    NewBonus MONEY,
    SumOfSubTotal MONEY
)
AS
BEGIN
    DECLARE @bonus MONEY
    SET @bonus = (SELECT MAX(Bonus) FROM Sales.SalesPerson)

    INSERT INTO @result (SalesPersonID, NewBonus, SumOfSubTotal)
    SELECT SOH.SalesPersonID, @bonus + SUM(SOH.SubTotal) * 0.01 AS NewBonus, SUM(SOH.SubTotal) AS SumOfSubTotal
    FROM Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesPerson SP ON SOH.SalesPersonID = SP.BusinessEntityID
    GROUP BY SOH.SalesPersonID

    RETURN
END
/*Để tính lại tiền thưởng cho nhân viên bán hàng, ta sử dụng câu lệnh SELECT để lấy dữ liệu từ bảng SalesOrderHeader và SalesPerson,
sau đó sử dụng INNER JOIN để kết hợp các bảng theo SalesPersonID. Sau đó, ta sử dụng GROUP BY để nhóm các đơn hàng theo SalesPersonID
và tính tổng doanh thu bằng cách sử dụng hàm SUM trên cột SubTotal trong bảng SalesOrderHeader. Cuối cùng, ta tính toán tiền thưởng mới 
bằng cách sử dụng biến @bonus để lấy giá trị tiền thưởng hiện tại và thêm 1% tổng doanh thu. Cuối cùng, ta chèn các giá trị SalesPersonID, NewBonus 
và SumOfSubTotal vào bảng kết quả @result.*/
-- Test:
Select *from NewBonus_Multi_statement()
---- Viết lại câu 6:
CREATE FUNCTION SumOfProduct_Multi_statement(@MaNCC INT)
RETURNS @result TABLE (
    ProductID INT,
    SumOfQty INT,
    SumOfSubTotal MONEY
)
AS
BEGIN
    INSERT INTO @result (ProductID, SumOfQty, SumOfSubTotal)
    SELECT POD.ProductID, SUM(POD.OrderQty) AS SumOfQty, SUM(POD.LineTotal) AS SumOfSubTotal
    FROM Purchasing.PurchaseOrderHeader POH
    INNER JOIN Purchasing.PurchaseOrderDetail POD ON POH.PurchaseOrderID = POD.PurchaseOrderID
    INNER JOIN Purchasing.Vendor V ON poh.VendorID = V.BusinessEntityID
    WHERE V.BusinessEntityID = @MaNCC
    GROUP BY POD.ProductID

    RETURN
END
--Để tính tổng số lượng và tổng trị giá của các sản phẩm do nhà cung cấp @MaNCC cung cấp, ta sử dụng câu lệnh SELECT để lấy dữ liệu từ bảng PurchaseOrderHeader, PurchaseOrderDetail và Vendor. Sau đó, ta sử dụng INNER JOIN để kết hợp các bảng theo PurchaseOrderID và VendorID. Sau đó, ta sử dụng WHERE để lọc ra các đơn hàng của nhà cung cấp @MaNCC. Cuối cùng, ta sử dụng GROUP BY để nhóm các sản phẩm theo ProductID và tính tổng số lượng và tổng trị giá bằng cách sử dụng hàm SUM trên cột OrderQty và LineTotal trong bảng PurchaseOrderDetail. Cuối cùng, ta chèn các giá trị ProductID, SumOfQty và SumOfSubTotal vào bảng kết quả @result.
-- Test:
Select *from SumOfProduct_Multi_statement(1492)
- Viết lại câu 7:
CREATE FUNCTION Discount_Func_Multi_statement (@SalesOrderID Int)
RETURNS @Discount TABLE (SalesOrderID INT, SubTotal DECIMAL(18,2), Discount DECIMAL(18,2))
AS
BEGIN
    DECLARE @SubTotal INT
    SET @SubTotal = (SELECT SubTotal FROM Sales.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)

    DECLARE @DiscountValue DECIMAL(18,2)

    SET @DiscountValue = 
        CASE
            WHEN @SubTotal < 1000 THEN 0
            WHEN @SubTotal >= 1000 AND @SubTotal < 5000 THEN @SubTotal * 0.05
            WHEN @SubTotal >= 5000 AND @SubTotal < 10000 THEN @SubTotal * 0.1
            ELSE @SubTotal * 0.15
        END
    
    INSERT INTO @Discount (SalesOrderID, SubTotal, Discount)
    VALUES (@SalesOrderID, @SubTotal, @DiscountValue)

    RETURN
END
--- Test:
Select *from Discount_Func_Multi_statement(43659)

--Viết lại câu 8:
CREATE FUNCTION TotalOfEmp_Multi_statement(@MonthOrder int, @YearOrder int)
Returns @Total TABLE (SalePerson int, Total money)
AS
BEGIN
	INSERT INTO @Total(SalePerson, Total)
	SELECT SOH.SalesPersonID, SUM(SOH.SubTotal) AS Total
    FROM Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesPerson SP ON SOH.SalesPersonID = SP.BusinessEntityID
    WHERE MONTH(SOH.OrderDate) = @MonthOrder AND YEAR(SOH.OrderDate) = @YearOrder
    GROUP BY SOH.SalesPersonID

	RETURN
END

Chạy thử:
SELECT *from TotalOfEmp_Multi_statement(5, 2011)

Câu 10:
CREATE FUNCTION SalaryOfEmp_Multi_statement(@MaNV INT)
RETURNS @ResultTable TABLE (
    BusinessEntityID INT,
    FName NVARCHAR(50),
    LName NVARCHAR(50),
    Salary MONEY
)
AS 
BEGIN
    IF @MaNV IS NULL
    BEGIN
        INSERT INTO @ResultTable (BusinessEntityID, FName, LName, Salary)
        SELECT E.BusinessEntityID, P.FirstName, P.LastName, EPH.Rate
        FROM HumanResources.Employee E
        JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
        JOIN HumanResources.EmployeePayHistory EPH ON E.BusinessEntityID = EPH.BusinessEntityID
    END
    ELSE
    BEGIN
        INSERT INTO @ResultTable (BusinessEntityID, FName, LName, Salary)
        SELECT E.BusinessEntityID, P.FirstName, P.LastName, EPH.Rate
        FROM HumanResources.Employee E
        JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
        JOIN HumanResources.EmployeePayHistory EPH ON E.BusinessEntityID = EPH.BusinessEntityID
        WHERE E.BusinessEntityID = @MaNV
    END

    RETURN
END

/*Trong đó, đoạn mã này tạo ra một table-valued function có tên SalaryOfEmp và một tham số đầu vào là @MaNV. Hàm trả về một bảng với các cột là BusinessEntityID, FName, LName và Salary.
Nếu @MaNV bằng null, hàm sẽ trả về bảng lương của tất cả nhân viên trong bảng Employee, 
ngược lại nếu @MaNV khác null, hàm sẽ trả về bảng lương của nhân viên có BusinessEntityID bằng với giá trị của tham số @MaNV. */
--Test:
Select *from SalaryOfEmp_Multi_statement(285)
Select *from SalaryOfEmp_Multi_statement(NULL)



--MODULE 5:

--CAU 1
-- Tạo mới 2 bảng M_Empartment và M_Department
create table M_Department
(
DepartmentID int not null primary key,
Name nvarchar(50),
GroupName nvarchar(50)
)

create table M_Employees
(
EmployeeID int not null primary key,

Firtname nvarchar(50),

MiddleName nvarchar(50),

LastName nvarchar(50),

DepartmentID int foreign key references M_Department(DepartmentID)
)

--tạo view   EmpDepart_view bao gồm các field: EmployeeID, Firtname,MiddleName, LastName, e.DepartmentID, Name, groupName, 
--dựa trên 2 bảngM_employees và M_Department.

create view EmpDepart_View
as
select EmployeeID, Firtname, MiddleName, LastName, e.DepartmentID, Name, GroupName
from M_Employees e join M_Department d on e.DepartmentID=d.DepartmentID
go

select * from EmpDepart_View


---tạo trigger InsteadOf_Trigger thực hiện trên view EmpDepart_view,
--dùng để chèn dữ liệu vào các bảng M_employees và M_Department khi chèn một record mới thông qua view EmpDepart_view
create trigger InsteadOf_Trigger on EmpDepart_View
instead of insert
as
begin
insert M_Department
select DepartmentID, Name, GroupName from inserted   -- chèn dữ liệu vào bảng M_Department
insert M_Employees
select EmployeeID, Firtname, MiddleName, LastName, DepartmentID   -- chèn dữ liệu vào bảng M_Employees
from inserted
end
--  Câu lệnh INSTEAD OF INSERT được sử dụng để thay thế quá trình chèn vào view EmpDepart_view bằng việc chèn dữ liệu vào các bảng M_Employees và M_Department.
-- các câu lệnh INSERT được sử dụng để chèn dữ liệu vào các bảng M_Employees và M_Department.

--Test triiger
select*from EmpDepart_View

insert EmpDepart_View values(1, 'Phan','Thanh','Tin', 10,'Marketing','Sales')

select*from M_Department

select*from M_Employees

--CAU 2
-- Tạo một trigger thực hiện trên bảng MySalesOrders có chức năng thiết lập độ ưu tiên của khách hàng (custpriority)
--khi người dùng thực hiện các thao tác Insert,Update và Delete trên bảng MySalesOrders 


-- Tạo 2 bảng MCustomer và MSalesOrders

create table MCustomer
(
CustomerID int not null primary key,
CustPriority int
)
create table MSalesOrders
(
SalesOrderID int not null primary key,
OrderDate date,
SubTotal money,
CustomerID int foreign key references Mcustomer(customerID)
)
drop table MSalesOrders

/*Chèn dữ liệu cho hai bảng trên lấy từ SalesPerson và SalesOrderHeader*/
--lấy CustomerID>30100 và CustomerID<30118, cột custpriority chogiá trị null.
insert MCustomer ([CustomerID],CustPriority)
select [CustomerID], null
from Sales.Customer
where CustomerID>30100 and CustomerID<30118


select*from Mcustomer


insert MSalesOrders 
select SalesOrderID, OrderDate, SubTotal, customerId
from  [Sales].[SalesOrderHeader]
where CustomerID>30100 and CustomerID<30118

select*from MsalesOrders
order by customerID

-- Viết Trigger
go

create trigger trigger_priority on MsalesOrders
for insert, update, delete
as
WITH CTE AS (
select CustomerId from inserted
union
select CustomerId from deleted
)

UPDATE MCustomer



SET CustPriority =
case

when t.Total < 10000 then 3  -- Tổng tiền khách hàng dưới 10000 thì độ ưu tiên là 3
when t.Total between 10000 and 50000 then 2 -- Tổng tiền khách hàng từ 10000 đến dưới 50000 thì độ ưu tiên là 2
when t.Total > 50000 then 1  -- Tổng tiền khách hàng từ 50000 trở lên thì độ ưu tiên là 3
when t.Total IS NULL then NULL

end

FROM MCustomer c INNER JOIN CTE ON CTE.CustomerId = c.CustomerId

LEFT JOIN (select MSalesOrders.CustomerID, SUM(SubTotal) Total
from MSalesOrders inner join CTE

on CTE.CustomerId = MSalesOrders.CustomerId

group by MSalesOrders.CustomerID) t ON t.CustomerId = c.CustomerId


--- Test trigger
insert MSalesOrders values(91849, '2023-02-24', 40000, 30115)

select*from MCustomer

where CustomerId=30112

select*from MSalesOrders


-- CAU 3:
-- Viết một trigger thực hiện trên bảng Memployees sao cho khi người dùng thực hiện 
--chèn thêm một nhân viên mới vào bảng Memployees thì chương trình cập nhật số nhân viên
--trong cột NumOfEmployee của bảng MDepartment.

-- Tạo mới 2 bảng MEmployess và MDepartment

create table MDepartment(
	DepartmentID int not null primary key,
	Name nvarchar(50),
	NumOfEmployee int
)

create table MEmployees
(
EmployeeID int not null,
Firtname nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
DepartmentID int foreign key references MDepartment(DepartmentID)
constraint pk_emp_depart primary key(EmployeeID, DepartmentID)
)

-- chèn dữ liệu cho 2 bảng
insert MDepartment
select DepartmentID, Name, null
from [HumanResources].[Department]
select  * from MDepartment 

insert [Memployees]
select e.[BusinessEntityID], [FirstName],[MiddleName],[LastName], [DepartmentID]
from [HumanResources].[Employee] e join [Person].[Person] p on e.BusinessEntityID=p.BusinessEntityID
join [HumanResources].[EmployeeDepartmentHistory] h on e.BusinessEntityID=h.BusinessEntityID

select*from [dbo].[Memployees]
order by [DepartmentID]
go

-- Viet trigger


create trigger Num_Emp on [dbo].[MEmployees]
for insert
as
declare @numofEmp int, @DepartID int
select @DepartID=i.DepartmentID from inserted i
set @numofEmp=(select COUNT(*)  -- đếm số nhân viên cùng phòng
from [dbo].[Memployees] e
where e.DepartmentID=@DepartID
)

if @numofEmp>=180
begin
print 'Bộ phận đã đủ nhân viên'    -- nếu số lượng nhân viên của phòng @numofEmp >= 180 thì
rollback						   -- in thông báo Bộ phận đã đủ nhân viên 
end


else
update MDepartment      -- cập nhật số nhân viên trong phòng khi thêm nhân viên
set NumOfEmployee =@numofEmp
where DepartmentID= @DepartID

go

-- Test

insert [dbo].[MEmployees] values(291, 'Phan','Thanh','Tin',3)
insert [dbo].[MEmployees] values(292, 'Nguyen','Thanh','Hung',2)
insert [dbo].[MEmployees] values(293, 'Le','Phuoc','Yen',2)

select *from MDepartment


-- CAU 4:
--Bảng [Purchasing].[Vendor], chứa thông tin của nhà cung cấp, thuộc tính
--CreditRating hiển thị thông tin đánh giá mức tín dụng, có các giá trị:
--1 = Superior
--2 = Excellent
--3 = Above average
--4 = Average
--5 = Below average
--Viết một trigger nhằm đảm bảo khi chèn thêm một record mới vào bảng
--[Purchasing].[PurchaseOrderHeader], nếu Vender có CreditRating=5 thì hiển thị
--thông báo không cho phép chèn và đồng thời hủy giao tác

select*from [Purchasing].[Vendor]
select*from [Purchasing].[PurchaseOrderHeader]


CREATE TRIGGER Purchasing.LowCredit ON Purchasing.PurchaseOrderHeader

AFTER INSERT
AS
IF EXISTS (SELECT *
FROM Purchasing.PurchaseOrderHeader AS p
JOIN inserted AS i ON p.PurchaseOrderID = i.PurchaseOrderID

JOIN Purchasing.Vendor AS v ON v.BusinessEntityID = p.VendorID

WHERE v.CreditRating = 5
)

BEGIN

RAISERROR ('A vendor''s credit rating is too low to accept new purchase orders.', 16, 1);
ROLLBACK TRANSACTION;

END;

GO

-- Test:
go
INSERT INTO Purchasing.PurchaseOrderHeader (RevisionNumber, Status,EmployeeID, VendorID, ShipMethodID, OrderDate, ShipDate, SubTotal, TaxAmt,Freight) 
VALUES ( 2 ,3, 261, 1652, 4 ,GETDATE() ,GETDATE() , 44594.55,3567.564, 1114.8638 );

-- Kết quả thông báo: A vendor''s credit rating is too low to accept new purchase orders.

--CAU 5:


--Viết một trigger thực hiện trên bảng SalesOrderDetail. Khi chèn thêm một đơn đặt
--hàng vào bảng SalesOrderDetail với số lượng xác định trong field OrderQty, nếu
--số lượng trong kho (ProductInventory
--lưu thông tin số lượng sản phẩm trong
--kho) Quantity> OrderQty thì cập nhật
--lại số lượng trong kho
--Quantity= Quantity - OrderQty,
--ngược lại nếu Quantity = 0 thì xuất
--thông báo “Kho hết hàng” và đồng thời
--hủy giao tác.

--=================================================================
create table MProduct 
(
	MProductID int not null primary key,
	ProductName nvarchar(50),
	ListPrice money
)
insert MProduct (MProductID, ProductName,ListPrice)
select [ProductID], [Name], [ListPrice]
from [Production].[Product]
where [ProductID]<=710
select*from MProduct

create table MSalesOrderHeader
(
	MSalesOrderID int not null primary key,
	OrderDate datetime
)
insert MSalesOrderHeader
select [SalesOrderID], [OrderDate]
from [Sales].[SalesOrderHeader]
where [SalesOrderID] in (select [SalesOrderID] from [Sales].[SalesOrderDetail] where [ProductID]<=710)
select*from MSalesOrderHeader

create table MSalesOrderDetail
(
	SalesOrderDetailID int IDENTITY(1,1) primary key,
	ProductID int not null foreign key(ProductID) references MProduct(MProductID),
	SalesOrderID int not null foreign key (SalesOrderID) references MSalesOrderHeader(MSalesOrderID),
	OrderQty int
)
insert MSalesOrderDetail(ProductID, SalesOrderID,OrderQty)
select [ProductID],[SalesOrderID], [OrderQty]
from [Sales].[SalesOrderDetail] where [ProductID] in(select MProductID from MProduct)
--//tao bang MProduct_inventory
create table MProduct_inventory
(
	productID int not null primary key,
	quantity smallint
)

insert MProduct_inventory
select [ProductID],sum([Quantity]) as sumofquatity
	from [Production].[ProductInventory]
	group by [ProductID]
go
----tao trigger
create trigger cau5 on MSalesOrderDetail
for insert
as
	begin
		declare @sldathang int, @sltrongkho int, @masp int
		select @masp =i.ProductID from inserted i   -- gán giá trị cho @masp
		select @sldathang=i.OrderQty from inserted i  -- gán giá trị cho @sldathang
		set @sltrongkho=(select quantity from MProduct_inventory  ---- gán giá trị cho @sltrongkho
						where productID=@masp)
		if @sldathang<@sltrongkho          --- nếu số lượng đặt hàng nhỏ hơn số lượng trong kho thì
			update MProduct_inventory	   --- cập nhập số lượng trong kho còn lại
			set quantity=quantity-@sldathang
			where ProductID=@masp
		else
			begin
				print 'Het hang'    --- ngược lại in ra thông báo hết hàng
				rollback tran 
			end
	end

---Test trigger
delete from [MSalesOrderDetail]
insert [dbo].[MSalesOrderDetail]
values(708, 43661, 300)


--CAU 6:
--Tạo trigger cập nhật tiền thưởng (Bonus) cho nhân viên bán hàng SalesPerson, khi
--người dùng chèn thêm một record mới trên bảng SalesOrderHeader, theo quy định
--như sau: Nếu tổng tiền bán được của nhân viên có hóa đơn mới nhập vào bảng
--SalesOrderHeader có giá trị >10000000 thì tăng tiền thưởng lên 10% của mức
--thưởng hiện tại

-- Tạo 2 bảng M_SalesPerson và M_SalesOrderHear


insert M_SalesPerson
select SalePSID, Territory, BonusPS
from Sales.SalesPerson

create table M_SalesOrderHeader
(
SalesOrdID int not null primary key,

OrderDate date,

SubTotalOrd money,

SalePSID int foreign key references M_SalesPerson(SalePSID)
)
go

-- Tạo trigger tiền thưởng (Bonus) cho nhân viên bán hàng 
CREATE trigger bonus_emp on [dbo].[M_SalesOrderHeader]
for insert
as
begin

declare @tt float, @spersonID int
select @spersonID= i.SalePSID from inserted i
set @tt=(select sum([SubTotalOrd])
from [dbo].[M_SalesOrderHeader]
where SalePSID=@spersonID)

if @tt>10000000

begin

update [dbo].[M_SalesPerson]
set BonusPS=BonusPS*1.1
where SalePSID=@spersonID

end

end

CREATE FUNCTION AddTwoNumbers
    (@Number1 INT, @Number2 INT)
RETURNS INT
AS
BEGIN
    RETURN @Number1 + @Number2
END;

SELECT dbo.AddTwoNumbers(10, 5)