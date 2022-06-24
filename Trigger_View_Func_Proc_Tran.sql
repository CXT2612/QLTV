--Tạo các VIEW

-- View ALL ListBook
create view listBook as
	SELECT books.id AS book_id, bookname, authorname, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type WHERE books.booktype = book_type.id

-- View ALL ListUser
create view listUser as
	SELECT * FROM users


-- Tạo các Trigger
--KIểm tra số lượng cuốn sách thêm vào có < 0 hay không
create trigger trigger_CheckQuantityBook on books
after insert, update as
declare @sl int
select @sl = quantity 
from inserted
if(@sl<0)
begin 
	print('Quantity is not valid ')
	rollback
end

--Kiểm tra người dùng có đang mượn cuốn sách đó hay chưa
create trigger trigger_CheckBorrow on borrows
after insert as
declare @count int
select @count= count(b.id)
from borrows b,inserted i
where i.user_code=b.user_code and i.book_id=b.book_id and b.status='Borrowing'
group by b.book_id
if (@count>1)
begin 
	print 'error'
	rollback
end

-- Kiểm tra người dùng có mượn quá số sách quy định không
create trigger trigger_BorrowQuantity on borrows
after insert as
declare @SL int
select @Sl= count(b.id)
from borrows b,inserted i
where i.user_code=b.user_code and b.status='Borrowing'
group by b.user_code
if (@SL>=15)
begin 
	print 'Over Quantity'
	rollback
end


-- Tạo các function

-- Function kiểm tra username tồn tại chưa, tồn tại 1 , không có thì 0
create function checkUsernameExist(@username varchar(150))
returns bit
as
begin
declare @id int
	select @id = id from users where username = @username
	if(@id > 0)
		return 1
	return 0
end


-- Function kiểm tra Code của bảng user tồn tại chưa, tồn tại 1 , không có thì 0
create function checkUserCodeExist(@code varchar(150))
returns bit
as
begin
declare @id int
	select @id = id from users where code = @code
	if(@id > 0)
		return 1
	return 0
end



-- get info book với id sách truyền vào, trả về bảng thông tin của sách đó
create function getInfoBookWithID(@id int)
returns table
as
	return SELECT books.id AS book_id, bookname, authorname, book_type.id AS type_id, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type WHERE books.booktype = book_type.id AND books.id = @id


-- get info user với id user truyền vào, trả về bảng thông tin của user đó
create function getInfoUserWithID(@id int)
returns table
as
	return SELECT * FROM users WHERE id = @id


-- get info book type với id sách truyền vào, trả về bảng thông tin của loại sách đó
create function getInfoBookTypeWithID(@id int)
returns table
as
	return SELECT * FROM book_type WHERE id = @id


-- Tìm kiếm thông tin sách với tên sách truyền vào, trả về bảng thông tin của những cuốn sách đó
create function getInfoBookWithBookName(@name nvarchar(150))
returns table
as
	return SELECT books.id AS book_id, bookname, authorname, typename, price, quantity, description, books.status, images, books.created_time, books.modified_time FROM books, book_type WHERE books.booktype = book_type.id AND books.bookname LIKE @name

select * from getInfoBookWithBookName('toan')
-- Tìm kiếm thông tin user với fullname truyền vào, trả về bảng thông tin của những user đó
create function getInfoUserWithFullName(@fullname nvarchar(150))
returns table
as
	return SELECT * FROM users WHERE fullname LIKE @fullname



-- Tạo các Procedure

-- Thủ tục xóa book với ID Book truyền vào, trả về số lượng row được xóa
CREATE PROCEDURE deleteBookWithID
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


-- end

-- Thủ tục xóa User với ID User truyền vào, trả về số lượng row được xóa
CREATE PROCEDURE deleteUserWithID
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


-- end

-- Thủ tục xóa tất cả book với ID Book Type truyền vào, trả về số lượng row được xóa
CREATE PROCEDURE deleteAllBookWithBookTypeID
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


-- end


-- Thủ tục xóa book type với ID truyền vào, trả về số lượng row được xóa
CREATE PROCEDURE deleteBookTypeWithID
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


-- end

-- Hàm kiểm tra sách đó có còn hay không
create function CheckBooksQuantity(@id int)
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


-- Thủ tục lấy một quyền sách ra khỏi kho, nếu hết sách thì print'Out of book' ngược lại lấy sách ra và giảm quantity 1 đơn vị
create Procedure TakeOneBookWithID(@BookID int)
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
