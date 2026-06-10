/*
 Navicat Premium Data Transfer

 Source Server         : SQL_Admin
 Source Server Type    : SQL Server
 Source Server Version : 16001000 (16.00.1000)
 Source Host           : .\SQLEXPRESS:1433
 Source Catalog        : ShopQuanAo
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 16001000 (16.00.1000)
 File Encoding         : 65001

 Date: 10/06/2026 06:45:13
*/


-- ----------------------------
-- Table structure for CartItems
-- ----------------------------
CREATE TABLE [dbo].[CartItems] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [user_id] int  NOT NULL,
  [variant_id] int  NOT NULL,
  [quantity] int DEFAULT 1 NOT NULL
)
GO

ALTER TABLE [dbo].[CartItems] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of CartItems
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[CartItems] ON
GO

SET IDENTITY_INSERT [dbo].[CartItems] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for OrderItems
-- ----------------------------
CREATE TABLE [dbo].[OrderItems] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [orderId] int  NOT NULL,
  [productId] int  NOT NULL,
  [productName] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [price] decimal(18,2)  NOT NULL,
  [quantity] int  NOT NULL,
  [subtotal] decimal(18,2)  NOT NULL
)
GO

ALTER TABLE [dbo].[OrderItems] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of OrderItems
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[OrderItems] ON
GO

INSERT INTO [dbo].[OrderItems] ([id], [orderId], [productId], [productName], [price], [quantity], [subtotal]) VALUES (N'1', N'1', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00'), (N'2', N'2', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'2', N'518000.00'), (N'3', N'3', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'2', N'518000.00'), (N'4', N'4', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'3', N'777000.00'), (N'5', N'5', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00'), (N'6', N'5', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00'), (N'7', N'5', N'1', N'Áo polo nam trắng phối xanh', N'279000.00', N'1', N'279000.00'), (N'8', N'6', N'3', N'Áo thun Delicious form basic', N'189000.00', N'1', N'189000.00'), (N'9', N'7', N'3', N'Áo thun Delicious form basic', N'189000.00', N'1', N'189000.00'), (N'10', N'8', N'3', N'Áo thun Delicious form basic', N'189000.00', N'1', N'189000.00'), (N'11', N'9', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00'), (N'12', N'10', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00'), (N'13', N'11', N'2', N'Áo polo nam sọc ngang', N'259000.00', N'1', N'259000.00')
GO

SET IDENTITY_INSERT [dbo].[OrderItems] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for Orders
-- ----------------------------
CREATE TABLE [dbo].[Orders] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [orderCode] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [userId] int  NOT NULL,
  [fullname] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [address] nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [phone] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [total] decimal(18,2)  NOT NULL,
  [createdAt] datetime DEFAULT getdate() NOT NULL,
  [paymentMethod] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'COD' NULL,
  [isPaid] bit DEFAULT 0 NULL,
  [signature] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [digitalSignature] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [keyId] int  NULL,
  [signedAt] datetime  NULL,
  [verifyStatus] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[Orders] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Orders
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[Orders] ON
GO

INSERT INTO [dbo].[Orders] ([id], [orderCode], [userId], [fullname], [address], [phone], [email], [total], [createdAt], [paymentMethod], [isPaid], [signature], [digitalSignature], [keyId], [signedAt], [verifyStatus]) VALUES (N'1', N'DH20260112-1', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'truongphucnen2012@gmail.com', N'259000.00', N'2026-01-12 22:53:34.647', N'COD', N'0', NULL, NULL, NULL, NULL, NULL), (N'2', N'DH20260112-2', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'nentruong18@gmail.com', N'518000.00', N'2026-01-12 22:58:27.130', N'COD', N'0', NULL, NULL, NULL, NULL, NULL), (N'3', N'DH20260112-3', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'nentruong18@gmail.com', N'518000.00', N'2026-01-12 22:58:54.043', N'COD', N'0', NULL, NULL, NULL, NULL, NULL), (N'4', N'DH20260112-4', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'nentruong18@gmail.com', N'777000.00', N'2026-01-12 23:03:31.463', N'COD', N'0', NULL, NULL, NULL, NULL, NULL), (N'5', N'DH20260113-5', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'23130276@st.hcmuaf.edu.vn', N'797000.00', N'2026-01-13 02:13:45.037', N'COD', N'0', NULL, NULL, NULL, NULL, NULL), (N'6', N'DH20260113-6', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'nentruong18@gmail.com', N'189000.00', N'2026-01-13 02:16:24.373', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL), (N'7', N'DH20260113-7', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'nentruong18@gmail.com', N'189000.00', N'2026-01-13 02:18:12.707', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL), (N'8', N'DH20260113-8', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'76p24q3oue6@nguyenbaoanh94750.click', N'189000.00', N'2026-01-13 02:19:59.643', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL), (N'9', N'DH20260113-9', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'76p24q3oue6@nguyenbaoanh94750.click', N'259000.00', N'2026-01-13 02:21:55.590', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL), (N'10', N'DH20260113-10', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'76p24q3oue6@nguyenbaoanh94750.click', N'259000.00', N'2026-01-13 02:24:08.160', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL), (N'11', N'DH20260113-11', N'3', N'Trương Phúc Nên', N'An Phúc, Đông Hải, Bạc Liêu', N'0836098040', N'76p24q3oue6@nguyenbaoanh94750.click', N'259000.00', N'2026-01-13 02:36:35.327', N'TRANSFER', N'1', NULL, NULL, NULL, NULL, NULL)
GO

SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for ProductImages
-- ----------------------------
CREATE TABLE [dbo].[ProductImages] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [product_id] int  NOT NULL,
  [color] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [image] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [is_main] bit DEFAULT 0 NOT NULL,
  [sort_order] int DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[ProductImages] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ProductImages
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[ProductImages] ON
GO

INSERT INTO [dbo].[ProductImages] ([id], [product_id], [color], [image], [is_main], [sort_order]) VALUES (N'1', N'1', N'Trắng xanh', N'm8.jpg', N'1', N'1'), (N'2', N'2', N'Đen trắng', N'm9-a.jpg', N'1', N'1'), (N'3', N'2', N'Xanh trắng', N'm9-b.jpg', N'1', N'1'), (N'4', N'2', N'Vàng nâu', N'm9-c.jpg', N'1', N'1'), (N'5', N'2', N'Đỏ đen', N'm9.jpg', N'1', N'1'), (N'6', N'2', N'Đỏ đen', N'm9-d.jpg', N'0', N'2'), (N'7', N'3', N'Xanh rêu', N'w1.jpg', N'1', N'1'), (N'8', N'3', N'Vàng', N'w1-a.jpg', N'1', N'1'), (N'9', N'3', N'Kem', N'w1-b.jpg', N'1', N'1'), (N'10', N'3', N'Xám', N'w1-c.jpg', N'1', N'1'), (N'11', N'3', N'Xanh dương', N'w1-d.jpg', N'1', N'1'), (N'12', N'3', N'Xanh rêu', N'w1-e.jpg', N'0', N'2'), (N'13', N'3', N'Tím nhạt', N'w1-f.jpg', N'1', N'1'), (N'14', N'4', N'Trắng cổ tím', N'w2.jpg', N'1', N'1'), (N'15', N'4', N'Trắng cổ hồng', N'w2-a.jpg', N'1', N'1'), (N'16', N'4', N'Trắng cổ vàng', N'w2-b.jpg', N'1', N'1'), (N'17', N'4', N'Trắng cổ cam', N'w2-c.jpg', N'1', N'1'), (N'18', N'5', N'Xanh dương', N'w3.jpg', N'1', N'1'), (N'19', N'5', N'Xanh dương nhạt', N'w3-a.jpg', N'1', N'1'), (N'20', N'6', N'Trắng', N'w4.jpg', N'1', N'1'), (N'21', N'6', N'Hồng', N'w4-a.jpg', N'1', N'1'), (N'22', N'6', N'Kem', N'w4-b.jpg', N'1', N'1'), (N'23', N'6', N'Đen', N'w4-c.jpg', N'1', N'1'), (N'24', N'6', N'Xanh dương', N'w4-d.jpg', N'1', N'1'), (N'25', N'6', N'Vàng', N'w4-e.jpg', N'1', N'1'), (N'26', N'7', N'Trắng', N'w5.jpg', N'1', N'1'), (N'27', N'7', N'Đen', N'w5-a.jpg', N'1', N'1'), (N'28', N'7', N'Nâu', N'w5-b.jpg', N'1', N'1'), (N'29', N'7', N'Trắng', N'w5-c.jpg', N'0', N'2'), (N'30', N'1', N'Trắng xanh', N'm8-b.jpg', N'0', N'2'), (N'31', N'1', N'Trắng tay xanh', N'm8-a.jpg', N'1', N'1'), (N'32', N'1', N'Trắng tay hồng', N'm8-c.jpg', N'1', N'1'), (N'33', N'1', N'Trắng tay vàng', N'm8-d.jpg', N'1', N'1')
GO

SET IDENTITY_INSERT [dbo].[ProductImages] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for Products
-- ----------------------------
CREATE TABLE [dbo].[Products] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [name] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [price] decimal(18,2)  NOT NULL,
  [image] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [description] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [quantity] int DEFAULT 0 NOT NULL,
  [category] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[Products] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Products
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[Products] ON
GO

INSERT INTO [dbo].[Products] ([id], [name], [price], [image], [type], [description], [quantity], [category]) VALUES (N'1', N'Áo polo nam trắng phối xanh', N'279000.00', N'm8.jpg', N'new', N'Áo polo nam trẻ trung, phối tay xanh', N'0', N'Polo'), (N'2', N'Áo polo nam sọc ngang', N'259000.00', N'm9.jpg', N'hot', N'Áo polo nam sọc ngang nhiều màu', N'0', N'Polo'), (N'3', N'Áo thun Delicious form basic', N'189000.00', N'w1.jpg', N'new', N'Áo thun in chữ DELICIOUS, form basic dễ mặc', N'0', N'Áo thun'), (N'4', N'Áo thun Price Less cổ phối màu', N'199000.00', N'w2.jpg', N'new', N'Áo thun in chữ Price Less, cổ phối màu trẻ trung', N'0', N'Áo thun'), (N'5', N'Áo thun trơn form basic', N'179000.00', N'w3.jpg', N'new', N'Áo thun trơn form basic, dễ mặc hằng ngày', N'0', N'Áo thun'), (N'6', N'Áo thun in hình Studio Seven', N'189000.00', N'w4.jpg', N'hot', N'Áo thun in hình Studio Seven phong cách trẻ trung', N'0', N'Áo thun'), (N'7', N'Áo thun in logo MAB UDI', N'209000.00', N'w5.jpg', N'new', N'Áo thun form rộng in logo MAB UDI', N'0', N'Áo thun'), (N'8', N'Áo thun trắng thêu logo nhỏ', N'169000.00', N'w6.jpg', N'new', N'Áo thun trắng form basic, thêu logo nhỏ trước ngực.', N'0', N'Áo thun'), (N'9', N'Áo thun trắng hình gấu dễ thương', N'179000.00', N'w7.jpg', N'new', N'Áo thun trắng form rộng, điểm nhấn hình gấu nhỏ trước ngực.', N'0', N'Áo thun'), (N'10', N'Áo thun đen thêu chữ nhỏ', N'179000.00', N'w8.jpg', N'new', N'Áo thun đen form basic, thêu chữ nhỏ tối giản.', N'0', N'Áo thun'), (N'11', N'Áo thun đen in chữ Clueless', N'189000.00', N'w9.jpg', N'hot', N'Áo thun đen form rộng, in chữ nổi bật phong cách streetwear.', N'0', N'Áo thun'), (N'12', N'Áo croptop trắng in chữ Berlin', N'159000.00', N'w10.jpg', N'new', N'Áo croptop trắng trẻ trung, in chữ "Berlin." trước ngực.', N'0', N'Áo thun'), (N'13', N'Áo croptop hồng in số', N'159000.00', N'w11.jpg', N'new', N'Áo croptop màu hồng pastel, in dãy số phong cách cá tính.', N'0', N'Áo thun'), (N'14', N'Áo croptop đen in Chargers', N'169000.00', N'w12.jpg', N'hot', N'Áo croptop đen, in chữ "Chargers" nổi bật.', N'0', N'Áo thun'), (N'15', N'Áo len tăm màu be basic', N'199000.00', N'w13.jpg', N'new', N'Áo len tăm màu be, dáng ôm nhẹ, dễ phối chân váy/quần.', N'0', N'Áo len'), (N'16', N'Áo sweater hồng in số 1987', N'249000.00', N'w14.jpg', N'hot', N'Áo sweater màu hồng, in số 1987 phong cách năng động.', N'0', N'Áo nỉ'), (N'17', N'Áo sweater hồng Yurina Kimai 15', N'259000.00', N'w15.jpg', N'hot', N'Áo sweater màu hồng, in chữ và số 15 phong cách thể thao.', N'0', N'Áo nỉ'), (N'18', N'Áo sơ mi caro đen trắng form rộng', N'259000.00', N'w21.jpg', N'new', N'Áo sơ mi caro đen trắng form rộng, phong cách unisex.', N'50', N'Áo sơ mi'), (N'19', N'Áo sơ mi caro hồng Today', N'269000.00', N'w22.jpg', N'new', N'Áo sơ mi caro màu hồng, điểm nhấn chữ Today trẻ trung.', N'50', N'Áo sơ mi'), (N'20', N'Áo sơ mi caro xám basic', N'259000.00', N'w23.jpg', N'new', N'Áo sơ mi caro xám form rộng, dễ phối đồ.', N'50', N'Áo sơ mi'), (N'21', N'Áo sơ mi xanh lá croptop', N'279000.00', N'w24.jpg', N'hot', N'Áo sơ mi xanh lá dáng croptop cá tính.', N'50', N'Áo sơ mi'), (N'22', N'Áo sơ mi caro xanh thắt eo', N'269000.00', N'w25.jpg', N'new', N'Áo sơ mi caro xanh form rộng, có thể thắt eo.', N'50', N'Áo sơ mi'), (N'23', N'Áo sơ mi trắng buộc vạt', N'249000.00', N'w26.jpg', N'new', N'Áo sơ mi trắng form rộng, thiết kế buộc vạt thời trang.', N'50', N'Áo sơ mi'), (N'24', N'Áo sơ mi caro nâu phối corset', N'289000.00', N'w27.jpg', N'hot', N'Áo sơ mi caro nâu phối corset nổi bật cá tính.', N'50', N'Áo sơ mi'), (N'25', N'Áo sơ mi trắng croptop tay ngắn', N'239000.00', N'w28.jpg', N'new', N'Áo sơ mi trắng croptop tay ngắn, phong phong cách trẻ trung.', N'50', N'Áo sơ mi'), (N'26', N'Quần short đen xếp ly', N'219000.00', N'w29.jpg', N'new', N'Quần short đen xếp ly, dễ phối áo croptop.', N'50', N'Quần short'), (N'27', N'Chân váy quần đen basic', N'229000.00', N'w30.jpg', N'hot', N'Chân váy quần đen dáng basic, năng động tiện lợi.', N'50', N'Chân váy'), (N'28', N'Quần short jean xanh basic lưng cao', N'229000.00', N'w31.jpg', N'like', N'Quần short jean xanh basic, dễ phối đồ.', N'0', N'Quần short'), (N'29', N'Chân váy jean xanh dáng chữ A', N'239000.00', N'w32.jpg', N'like', N'Chân váy jean xanh dáng chữ A, trẻ trung.', N'0', N'Chân váy'), (N'30', N'Quần short đen dáng rộng', N'219000.00', N'w33.jpg', N'like', N'Quần short màu đen, form rộng thoải mái.', N'0', N'Quần short'), (N'31', N'Quần short jean đen rách gấu cá tính', N'239000.00', N'w34.jpg', N'like', N'Quần short jean đen rách gấu, phong cách cá tính.', N'0', N'Quần short'), (N'32', N'Quần short jean xanh ống rộng', N'239000.00', N'w35.jpg', N'like', N'Quần short jean xanh ống rộng, năng động.', N'0', N'Quần short'), (N'33', N'Quần short jean xanh wash sáng', N'239000.00', N'w36.jpg', N'like', N'Quần short jean xanh wash sáng, dễ phối.', N'0', N'Quần short'), (N'34', N'Quần short jean đen form ôm cá tính', N'239000.00', N'w37.jpg', N'like', N'Quần short jean đen form ôm, cá tính.', N'0', N'Quần short'), (N'35', N'Quần short đen dáng suông basic', N'219000.00', N'w38.jpg', N'like', N'Quần short đen dáng suông, mặc hằng ngày.', N'0', N'Quần short'), (N'36', N'Quần short jean xanh đậm basic', N'229000.00', N'w39.jpg', N'like', N'Quần short jean xanh đậm, bền đẹp dễ mặc.', N'0', N'Quần short'), (N'37', N'Quần short jean xanh nhạt ống rộng', N'239000.00', N'w40.jpg', N'like', N'Quần short jean xanh nhạt ống rộng, thoải mái.', N'0', N'Quần short'), (N'38', N'Áo len sọc xanh trắng', N'329000.00', N'm1.jpg', N'like', N'Áo len sọc ngang phối màu xanh trắng', N'0', N'Áo len'), (N'39', N'Áo len phối nâu đen', N'339000.00', N'm2.jpg', N'like', N'Áo len phối màu nâu đen cá tính', N'0', N'Áo len'), (N'40', N'Áo len họa tiết retro', N'359000.00', N'm3.jpg', N'like', N'Áo len họa tiết retro nổi bật', N'0', N'Áo len'), (N'41', N'Áo len trắng đen basic', N'319000.00', N'm4.jpg', N'like', N'Áo len trắng đen form basic', N'0', N'Áo len'), (N'42', N'Áo nỉ cổ zip chữ UP', N'349000.00', N'm6.jpg', N'like', N'Áo nỉ cổ kéo khóa phong cách streetwear', N'0', N'Áo len'), (N'43', N'Áo polo nỉ tay dài', N'339000.00', N'm7.jpg', N'like', N'Áo polo nỉ tay dài năng động', N'0', N'Áo len'), (N'44', N'Áo len form rộng casual', N'329000.00', N'm10.jpg', N'like', N'Áo len form rộng phong cách casual', N'0', N'Áo len'), (N'45', N'Chân váy nhung gân basic', N'219000.00', N'w66.jpg', N'like', N'Chân váy nhung gân dáng basic, dễ phối đồ.', N'0', N'Chân váy'), (N'46', N'Chân váy xếp ly ngắn', N'229000.00', N'w67.jpg', N'like', N'Chân váy xếp ly trẻ trung, năng động.', N'0', N'Chân váy'), (N'47', N'Áo polo nam cổ phối viền', N'259000.00', N'm11.jpg', N'like', N'Áo polo nam basic, cổ phối viền.', N'0', N'Polo'), (N'48', N'Áo sơ mi hoạ tiết đen trắng', N'269000.00', N'm20.jpg', N'like', N'Áo sơ mi hoạ tiết đen trắng nổi bật.', N'0', N'Áo sơ mi'), (N'49', N'Áo sơ mi hoạ tiết graffiti nhiều màu', N'279000.00', N'm30.jpg', N'like', N'Áo sơ mi hoạ tiết graffiti cá tính.', N'0', N'Áo sơ mi'), (N'50', N'Chân váy xếp ly màu xám', N'239000.00', N'w70.jpg', N'like', N'Chân váy xếp ly màu xám, dễ phối.', N'0', N'Chân váy'), (N'51', N'Yếm quần short jean rách', N'299000.00', N'w72.jpg', N'like', N'Yếm quần short jean rách cá tính.', N'0', N'Quần short'), (N'52', N'Áo sơ mi caro vàng buộc eo', N'249000.00', N'ao-1.jpg', N'like', N'Áo sơ mi caro vàng, có thể buộc eo.', N'0', N'Áo sơ mi'), (N'53', N'Quần jean ống rộng xanh nhạt', N'319000.00', N'ao-2.jpg', N'like', N'Quần jean ống rộng xanh nhạt, thoải mái.', N'0', N'Quần jean'), (N'54', N'Quần jean xanh nhạt dáng suông', N'319000.00', N'w46.jpg', N'like', N'Quần jean xanh nhạt dáng suông.', N'0', N'Quần jean'), (N'55', N'Quần jean xanh nhạt phối đường may', N'329000.00', N'w47.jpg', N'like', N'Quần jean xanh nhạt có đường may nổi.', N'0', N'Quần jean')
GO

SET IDENTITY_INSERT [dbo].[Products] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for ProductVariants
-- ----------------------------
CREATE TABLE [dbo].[ProductVariants] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [product_id] int  NOT NULL,
  [color] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [size] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [price] decimal(18,2)  NULL,
  [stock] int DEFAULT 0 NOT NULL
)
GO

ALTER TABLE [dbo].[ProductVariants] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ProductVariants
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[ProductVariants] ON
GO

INSERT INTO [dbo].[ProductVariants] ([id], [product_id], [color], [size], [price], [stock]) VALUES (N'1', N'1', N'Trắng xanh', N'S', NULL, N'10'), (N'2', N'1', N'Trắng xanh', N'M', NULL, N'12'), (N'3', N'1', N'Trắng xanh', N'L', NULL, N'15'), (N'4', N'2', N'Đen trắng', N'S', NULL, N'10'), (N'5', N'2', N'Đen trắng', N'M', NULL, N'12'), (N'6', N'2', N'Đen trắng', N'L', NULL, N'15'), (N'7', N'2', N'Xanh trắng', N'S', NULL, N'8'), (N'8', N'2', N'Xanh trắng', N'M', NULL, N'10'), (N'9', N'2', N'Xanh trắng', N'L', NULL, N'12'), (N'10', N'2', N'Vàng nâu', N'S', NULL, N'6'), (N'11', N'2', N'Vàng nâu', N'M', NULL, N'8'), (N'12', N'2', N'Vàng nâu', N'L', NULL, N'10'), (N'13', N'2', N'Đỏ đen', N'S', NULL, N'7'), (N'14', N'2', N'Đỏ đen', N'M', NULL, N'9'), (N'15', N'2', N'Đỏ đen', N'L', NULL, N'11'), (N'16', N'3', N'Xanh rêu', N'S', NULL, N'10'), (N'17', N'3', N'Xanh rêu', N'M', NULL, N'12'), (N'18', N'3', N'Xanh rêu', N'L', NULL, N'14'), (N'19', N'3', N'Vàng', N'S', NULL, N'8'), (N'20', N'3', N'Vàng', N'M', NULL, N'10'), (N'21', N'3', N'Vàng', N'L', NULL, N'12'), (N'22', N'3', N'Kem', N'S', NULL, N'9'), (N'23', N'3', N'Kem', N'M', NULL, N'11'), (N'24', N'3', N'Kem', N'L', NULL, N'13'), (N'25', N'3', N'Xám', N'S', NULL, N'7'), (N'26', N'3', N'Xám', N'M', NULL, N'9'), (N'27', N'3', N'Xám', N'L', NULL, N'11'), (N'28', N'3', N'Xanh dương', N'S', NULL, N'8'), (N'29', N'3', N'Xanh dương', N'M', NULL, N'10'), (N'30', N'3', N'Xanh dương', N'L', NULL, N'12'), (N'31', N'3', N'Tím nhạt', N'S', NULL, N'6'), (N'32', N'3', N'Tím nhạt', N'M', NULL, N'8'), (N'33', N'3', N'Tím nhạt', N'L', NULL, N'10'), (N'34', N'4', N'Trắng cổ tím', N'S', NULL, N'8'), (N'35', N'4', N'Trắng cổ tím', N'M', NULL, N'10'), (N'36', N'4', N'Trắng cổ tím', N'L', NULL, N'12'), (N'37', N'4', N'Trắng cổ hồng', N'S', NULL, N'8'), (N'38', N'4', N'Trắng cổ hồng', N'M', NULL, N'10'), (N'39', N'4', N'Trắng cổ hồng', N'L', NULL, N'12'), (N'40', N'4', N'Trắng cổ vàng', N'S', NULL, N'8'), (N'41', N'4', N'Trắng cổ vàng', N'M', NULL, N'10'), (N'42', N'4', N'Trắng cổ vàng', N'L', NULL, N'12'), (N'43', N'4', N'Trắng cổ cam', N'S', NULL, N'8'), (N'44', N'4', N'Trắng cổ cam', N'M', NULL, N'10'), (N'45', N'4', N'Trắng cổ cam', N'L', NULL, N'12'), (N'46', N'5', N'Xanh dương', N'S', NULL, N'10'), (N'47', N'5', N'Xanh dương', N'M', NULL, N'12'), (N'48', N'5', N'Xanh dương', N'L', NULL, N'14'), (N'49', N'5', N'Xanh dương nhạt', N'S', NULL, N'10'), (N'50', N'5', N'Xanh dương nhạt', N'M', NULL, N'12'), (N'51', N'5', N'Xanh dương nhạt', N'L', NULL, N'14'), (N'52', N'6', N'Trắng', N'S', NULL, N'8'), (N'53', N'6', N'Trắng', N'M', NULL, N'10'), (N'54', N'6', N'Trắng', N'L', NULL, N'12'), (N'55', N'6', N'Hồng', N'S', NULL, N'8'), (N'56', N'6', N'Hồng', N'M', NULL, N'10'), (N'57', N'6', N'Hồng', N'L', NULL, N'12'), (N'58', N'6', N'Kem', N'S', NULL, N'8'), (N'59', N'6', N'Kem', N'M', NULL, N'10'), (N'60', N'6', N'Kem', N'L', NULL, N'12'), (N'61', N'6', N'Đen', N'S', NULL, N'8'), (N'62', N'6', N'Đen', N'M', NULL, N'10'), (N'63', N'6', N'Đen', N'L', NULL, N'12'), (N'64', N'6', N'Xanh dương', N'S', NULL, N'8'), (N'65', N'6', N'Xanh dương', N'M', NULL, N'10'), (N'66', N'6', N'Xanh dương', N'L', NULL, N'12'), (N'67', N'6', N'Vàng', N'S', NULL, N'8'), (N'68', N'6', N'Vàng', N'M', NULL, N'10'), (N'69', N'6', N'Vàng', N'L', NULL, N'12'), (N'70', N'7', N'Trắng', N'S', NULL, N'14'), (N'71', N'7', N'Trắng', N'M', NULL, N'16'), (N'72', N'7', N'Trắng', N'L', NULL, N'18'), (N'73', N'7', N'Đen', N'S', NULL, N'12'), (N'74', N'7', N'Đen', N'M', NULL, N'14'), (N'75', N'7', N'Đen', N'L', NULL, N'16'), (N'76', N'7', N'Nâu', N'S', NULL, N'10'), (N'77', N'7', N'Nâu', N'M', NULL, N'12'), (N'78', N'7', N'Nâu', N'L', NULL, N'14'), (N'79', N'1', N'Trắng tay xanh', N'S', NULL, N'10'), (N'80', N'1', N'Trắng tay xanh', N'M', NULL, N'12'), (N'81', N'1', N'Trắng tay xanh', N'L', NULL, N'15'), (N'82', N'1', N'Trắng tay hồng', N'S', NULL, N'10'), (N'83', N'1', N'Trắng tay hồng', N'M', NULL, N'12'), (N'84', N'1', N'Trắng tay hồng', N'L', NULL, N'15'), (N'85', N'1', N'Trắng tay vàng', N'S', NULL, N'10'), (N'86', N'1', N'Trắng tay vàng', N'M', NULL, N'12'), (N'87', N'1', N'Trắng tay vàng', N'L', NULL, N'15')
GO

SET IDENTITY_INSERT [dbo].[ProductVariants] OFF
GO

COMMIT
GO


-- ----------------------------
-- Table structure for Users
-- ----------------------------
CREATE TABLE [dbo].[Users] (
  [id] int  IDENTITY(1,1) NOT NULL,
  [username] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [password] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [fullname] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NOT NULL,
  [email] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL,
  [role] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'user' NOT NULL,
  [publicKey] nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[Users] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of Users
-- ----------------------------
BEGIN TRANSACTION
GO

SET IDENTITY_INSERT [dbo].[Users] ON
GO

INSERT INTO [dbo].[Users] ([id], [username], [password], [fullname], [email], [role], [publicKey]) VALUES (N'1', N'admin', N'admin123', N'Administrator', N'admin@shopquanao.com', N'admin', NULL), (N'2', N'user', N'123456', N'Vũ Thiên Sinh', N'user@example.com', N'user', NULL), (N'3', N'0836098040', N'Phucnen2012', N'Trương Phúc Nên', NULL, N'user', NULL)
GO

SET IDENTITY_INSERT [dbo].[Users] OFF
GO

COMMIT
GO


-- ----------------------------
-- Auto increment value for CartItems
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[CartItems]', RESEED, 1)
GO


-- ----------------------------
-- Uniques structure for table CartItems
-- ----------------------------
ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [UQ_CartItems_User_Variant] UNIQUE NONCLUSTERED ([user_id] ASC, [variant_id] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table CartItems
-- ----------------------------
ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [PK__CartItem__3213E83FF53BEEAA] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for OrderItems
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[OrderItems]', RESEED, 13)
GO


-- ----------------------------
-- Primary Key structure for table OrderItems
-- ----------------------------
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [PK__OrderIte__3213E83FB5245F2A] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for Orders
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[Orders]', RESEED, 11)
GO


-- ----------------------------
-- Primary Key structure for table Orders
-- ----------------------------
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [PK__Orders__3213E83F466DD761] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for ProductImages
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[ProductImages]', RESEED, 33)
GO


-- ----------------------------
-- Primary Key structure for table ProductImages
-- ----------------------------
ALTER TABLE [dbo].[ProductImages] ADD CONSTRAINT [PK__ProductI__3213E83FA9910F1D] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for Products
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[Products]', RESEED, 55)
GO


-- ----------------------------
-- Primary Key structure for table Products
-- ----------------------------
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [PK__Products__3213E83FB903764A] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for ProductVariants
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[ProductVariants]', RESEED, 87)
GO


-- ----------------------------
-- Uniques structure for table ProductVariants
-- ----------------------------
ALTER TABLE [dbo].[ProductVariants] ADD CONSTRAINT [UQ_ProductVariants] UNIQUE NONCLUSTERED ([product_id] ASC, [color] ASC, [size] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table ProductVariants
-- ----------------------------
ALTER TABLE [dbo].[ProductVariants] ADD CONSTRAINT [PK__ProductV__3213E83FC5416B85] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Auto increment value for Users
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[Users]', RESEED, 3)
GO


-- ----------------------------
-- Uniques structure for table Users
-- ----------------------------
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [UQ__Users__F3DBC5722C43B8A4] UNIQUE NONCLUSTERED ([username] ASC)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Primary Key structure for table Users
-- ----------------------------
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK__Users__3213E83FBE7A50E6] PRIMARY KEY CLUSTERED ([id])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO


-- ----------------------------
-- Foreign Keys structure for table CartItems
-- ----------------------------
ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [FK_CartItems_Users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[CartItems] ADD CONSTRAINT [FK_CartItems_ProductVariants] FOREIGN KEY ([variant_id]) REFERENCES [dbo].[ProductVariants] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table OrderItems
-- ----------------------------
ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Orders] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Orders] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO

ALTER TABLE [dbo].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Products] FOREIGN KEY ([productId]) REFERENCES [dbo].[Products] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table Orders
-- ----------------------------
ALTER TABLE [dbo].[Orders] ADD CONSTRAINT [FK_Orders_Users] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([id]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table ProductImages
-- ----------------------------
ALTER TABLE [dbo].[ProductImages] ADD CONSTRAINT [FK_ProductImages_Products] FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO


-- ----------------------------
-- Foreign Keys structure for table ProductVariants
-- ----------------------------
ALTER TABLE [dbo].[ProductVariants] ADD CONSTRAINT [FK_ProductVariants_Products] FOREIGN KEY ([product_id]) REFERENCES [dbo].[Products] ([id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO

