
USE [QuanLyThuVien]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckBooksQuantity]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CheckBooksQuantity](@id int)
returns bit
as
begin
	declare @SL int
	select @SL=quantity
	from books
	where id=@id
	if (@SL>0)
		return 1
	return 0
end

GO
/****** Object:  UserDefinedFunction [dbo].[checkUserCodeExist]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[checkUserCodeExist](@code varchar(150))
returns bit
as
begin
declare @id int
	select @id = id from users where code = @code
	if(@id > 0)
		return 1
	return 0
end

GO
/****** Object:  UserDefinedFunction [dbo].[checkUsernameExist]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[checkUsernameExist](@username varchar(150))
returns bit
as
begin
declare @id int
	select @id = id from users where 
	username = @username
	if(@id > 0)
		return 1
	return 0
end
GO
/****** Object:  Table [dbo].[book_type]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[book_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[typename] [nvarchar](150) NOT NULL,
	[status] [varchar](10) NOT NULL,
	[created_time] [datetime] NULL,
	[modified_time] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[typename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[books]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[books](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bookname] [nvarchar](150) NOT NULL,
	[authorname] [nvarchar](150) NULL,
	[booktype] [int] NOT NULL,
	[price] [float] NULL,
	[quantity] [int] NOT NULL,
	[description] [text] NULL,
	[status] [varchar](10) NOT NULL,
	[images] [image] NULL,
	[created_time] [datetime] NULL,
	[modified_time] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[listBook]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[listBook] as
	SELECT books.id AS book_id, bookname, authorname, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type 
WHERE books.booktype = book_type.id
GO
/****** Object:  Table [dbo].[users]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](150) NULL,
	[username] [nvarchar](150) NOT NULL,
	[password] [varchar](150) NOT NULL,
	[gender] [varchar](10) NULL,
	[birthdate] [datetime] NULL,
	[role] [varchar](10) NOT NULL,
	[status] [varchar](10) NOT NULL,
	[images] [image] NULL,
	[created_time] [datetime] NULL,
	[modified_time] [datetime] NULL,
	[code] [nvarchar](10) NULL,
	[email] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[listUser]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[listUser] as
SELECT * FROM users
GO
/****** Object:  UserDefinedFunction [dbo].[getInfoBookWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getInfoBookWithID](@id int)
returns table
as
	return SELECT books.id AS book_id, bookname, authorname, book_type.id AS type_id, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type WHERE books.booktype = book_type.id AND books.id = @id


GO
/****** Object:  UserDefinedFunction [dbo].[getInfoUserWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getInfoUserWithID](@id int)
returns table
as
	return SELECT * FROM users WHERE id = @id
GO
/****** Object:  UserDefinedFunction [dbo].[getInfoBookTypeWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getInfoBookTypeWithID](@id int)
returns table
as
	return SELECT * FROM book_type WHERE id = @id
GO
/****** Object:  UserDefinedFunction [dbo].[getInfoBookWithBookName]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getInfoBookWithBookName](@name nvarchar(150))
returns table
as
	return SELECT books.id AS book_id, bookname, authorname, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type WHERE books.booktype = book_type.id AND books.bookname LIKE @name

GO
/****** Object:  UserDefinedFunction [dbo].[getInfoUserWithFullName]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getInfoUserWithFullName](@fullname nvarchar(150))
returns table
as
	return SELECT * FROM users WHERE fullname LIKE @fullname
GO
/****** Object:  Table [dbo].[borrows]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[borrows](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[book_id] [int] NULL,
	[user_code] [nvarchar](10) NULL,
	[status] [nvarchar](10) NOT NULL,
	[borrow_time] [datetime] NOT NULL,
	[return_time] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[employee]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](150) NULL,
	[working] [nvarchar](150) NOT NULL,
	[images] [image] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[notification_user]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[notification_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[title] [nvarchar](300) NULL,
	[content] [nvarchar](4000) NULL,
	[status] [nvarchar](10) NULL,
	[created_time] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[recover_code]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recover_code](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[code_recover] [nvarchar](10) NOT NULL,
	[expiry_date] [datetime] NOT NULL,
	[status] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[settings]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[settings](
	[keys] [nvarchar](30) NOT NULL,
	[value] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[keys] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD FOREIGN KEY([booktype])
REFERENCES [dbo].[book_type] ([id])
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD FOREIGN KEY([booktype])
REFERENCES [dbo].[book_type] ([id])
GO
ALTER TABLE [dbo].[borrows]  WITH CHECK ADD FOREIGN KEY([book_id])
REFERENCES [dbo].[books] ([id])
GO
ALTER TABLE [dbo].[borrows]  WITH CHECK ADD FOREIGN KEY([book_id])
REFERENCES [dbo].[books] ([id])
GO
ALTER TABLE [dbo].[borrows]  WITH CHECK ADD FOREIGN KEY([user_code])
REFERENCES [dbo].[users] ([code])
GO
ALTER TABLE [dbo].[borrows]  WITH CHECK ADD FOREIGN KEY([user_code])
REFERENCES [dbo].[users] ([code])
GO
ALTER TABLE [dbo].[recover_code]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[recover_code]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD CHECK  (([quantity]>=(0)))
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD CHECK  (([quantity]>=(0)))
GO
/****** Object:  StoredProcedure [dbo].[deleteAllBookWithBookTypeID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteAllBookWithBookTypeID]
(       
    @bookTypeID int 
)
AS
    SET NOCOUNT OFF;
BEGIN
 DELETE FROM books 
 WHERE
 (booktype = @bookTypeID)
 SELECT @@ROWCOUNT AS rowsDelete
END


GO
/****** Object:  StoredProcedure [dbo].[deleteBookTypeWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteBookTypeWithID]
(       
    @bookTypeID int 
)
AS
    SET NOCOUNT OFF;
BEGIN
 DELETE FROM book_type 
 WHERE
 (id = @bookTypeID)
 SELECT @@ROWCOUNT AS rowsDelete
END


GO
/****** Object:  StoredProcedure [dbo].[deleteBookWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteBookWithID]
(       
@bookID int 
)
AS
    SET NOCOUNT OFF;
BEGIN
 DELETE FROM books 
 WHERE
 (id = @bookID)
 SELECT @@ROWCOUNT AS rowsDelete
END


GO
/****** Object:  StoredProcedure [dbo].[deleteUserWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteUserWithID]
(       
    @userID int
)
AS
    SET NOCOUNT OFF;
BEGIN
 DELETE FROM users 
 WHERE
 (id = @userID)
 SELECT @@ROWCOUNT AS rowsDelete
END



GO
/****** Object:  StoredProcedure [dbo].[TakeOneBookWithID]    Script Date: 6/15/2022 12:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[TakeOneBookWithID](@BookID int)
as
SET NOCOUNT OFF;
begin
	declare @check bit
	SELECT @check = dbo.CheckBooksQuantity(@BookID)
	if (@check=0)
	begin
		print'Out of book'
	end
	else
	begin
		BEGIN TRANSACTION UpdateQuantityBook
		update books 
		SET quantity=quantity - 1
		where id=@BookID
		IF(@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
		ELSE
			BEGIN
			COMMIT TRANSACTION UpdateQuantityBook
			END
	end
end



GO
USE [master]
GO
ALTER DATABASE [QuanLyThuVien] SET  READ_WRITE 
GO
