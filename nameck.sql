CREATE FUNCTION dbo.ValidateName
(
    @name  NVARCHAR(max)
)
RETURNS BIT
AS
BEGIN
    DECLARE @valid BIT = 1;

    IF LEN(TRIM(@name)) <= 2 OR TRIM(@name) = ''
        SET @valid = 0;

    RETURN @valid;
END;
