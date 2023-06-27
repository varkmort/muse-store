CREATE FUNCTION dbo.ValidatePassword
(
    @password NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @valid BIT = 1;
    
    -- Проверка длины пароля
    IF LEN(@password) < 8
        SET @valid = 0;
    
    -- Проверка наличия символов разных регистров
    IF UPPER(@password) = @password OR LOWER(@password) = @password
        SET @valid = 0;
    
    -- Проверка наличия цифр
    IF @valid = 1 AND @password NOT LIKE '%[0-9]%'
        SET @valid = 0;
    
    -- Проверка наличия символов
    IF @valid = 1 AND @password NOT LIKE '%[^a-zA-Z0-9]%'
        SET @valid = 0;
    
    RETURN @valid;
END;
