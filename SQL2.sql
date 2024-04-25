CREATE DATABASE SQL_TASK2
USE SQL_TASK2
CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(45) NOT NULL UNIQUE
)
CREATE TABLE Tags(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(45) NOT NULL UNIQUE
)
CREATE TABLE Users(
Id INT PRIMARY KEY IDENTITY,
Username NVARCHAR(45) NOT NULL UNIQUE,
Fullname NVARCHAR(45) NOT NULL,
Age INT CHECK(Age > 0 AND Age < 150)
)

CREATE TABLE Blogs(
Id INT PRIMARY KEY IDENTITY,
Title NVARCHAR(45) NOT NULL CHECK(LEN(Title) > 0 AND LEN(Title) < 50),
[Description] NVARCHAR(45) NOT NULL,
UsersId INT REFERENCES Users(Id),
CategoryId INT REFERENCES Categories(Id)
)
CREATE TABLE Comments(
Id INT PRIMARY KEY IDENTITY,
Content NVARCHAR(45) NOT NULL CHECK(LEN(Content) > 0 AND LEN(Content) < 250),
UserId INT REFERENCES Users(Id),
BlogId INT REFERENCES Blogs(Id)
)
CREATE TABLE TagBlog(
TagsId INT REFERENCES Tags(Id),
BlogId INT REFERENCES Blogs(Id)
)

INSERT INTO Categories VALUES ('TEST1'),('TEST2')
INSERT INTO Tags VALUES ('NAME1'),('NAME2')
INSERT INTO Users VALUES ('ramazaan.85','Ramazan Asgerli',20),('ramazannn.75','ramazan asgerov',35) 
INSERT INTO Comments VALUES('SALAM',1,1),('SAGOL',2,2)
INSERT INTO Blogs VALUES('aaaa','aaaaas',1,1),('bbbbb','bbbbb',2,2)
INSERT INTO TagBlog VALUES(1,1),(2,2)

ALTER TABLE Blogs
ADD isDeleted BIT DEFAULT 0;

---1---------------------------------------------------
CREATE VIEW GetFullUser
AS
SELECT b.Title,u.Fullname,u.Username FROM Blogs b
INNER JOIN Users u
ON b.UsersId=u.Id
SELECT * FROM GetFullUser

--2--------------------------------------

CREATE VIEW GetTitName
AS
SELECT b.Title,c.Name FROM Blogs b
INNER JOIN Categories c
ON b.CategoryId=c.Id
SELECT * FROM GetTitName

--3---------------------------------

CREATE PROCEDURE usp_GetComment (@userId INT)
AS
SELECT * FROM Comments
WHERE Comments.UserId=@userId

EXEC usp_GetComment @userId=1

--4---------------------------------

CREATE PROCEDURE usp_GetBlogs (@userId INT)
AS
SELECT * FROM Blogs
WHERE Blogs.UsersId=@userId

EXEC usp_GetBlogs @userId=1

--5---------------------------------
CREATE FUNCTION usp_GetBlogCount (@categoryId INT)
RETURNS INT
AS
BEGIN
DECLARE @COUNTSS INT
SELECT @COUNTSS=COUNT(*) FROM Blogs
WHERE Blogs.CategoryId=@categoryId
return @COUNTSS
END

SELECT dbo.usp_GetBlogCount (1)

--6------------------------------------
CREATE FUNCTION usp_GetUserBlogs (@userId INT)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Blogs
    WHERE Blogs.UsersId = @userId
)

SELECT * FROM dbo.usp_GetUserBlogs(2)

--7-------------------------------------

--CREATE TRIGGER BlogDelete
--ON Blogs
--AFTER DELETE
--AS
--BEGIN
--    UPDATE b
--    SET b.isDeleted = 1
--    FROM deleted d
--    INNER JOIN Blogs b ON d.Id = b.Id;
--END;

