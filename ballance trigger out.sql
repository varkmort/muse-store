CREATE TRIGGER CheckTicketAvailability
ON tickets
INSTEAD OF INSERT
AS
BEGIN
    -- Проверка наличия достаточного количества товара
    IF EXISTS (
        SELECT balances.goods_id
        FROM balances
        INNER JOIN inserted ON balances.goods_id = inserted.goods_id
        WHERE balances.amount >= inserted.amount
    )
    BEGIN
        -- Вычитание количества товара из таблицы balances
        UPDATE balances
        SET amount = amount - inserted.amount
        FROM balances
        INNER JOIN inserted ON balances.goods_id = inserted.goods_id
        WHERE balances.amount >= inserted.amount;
        
        -- Вставка записи в таблицу tickets
        INSERT INTO tickets (goods_id, amount, sale_id, discount)
        SELECT goods_id, amount, sale_id, discount
        FROM inserted;
    END
    ELSE
    BEGIN
        -- Отмена операции и сообщение пользователю
        RAISERROR('Недостаточное количество товара или отсутствие записи с указанным goods_id.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
/*
В этом примере мы создаем триггер с именем "CheckTicketAvailability" на таблице "tickets". 
Триггер срабатывает перед операцией вставки (INSTEAD OF INSERT), что позволяет нам контролировать и изменять результат вставки.

Внутри триггера мы сначала проверяем наличие достаточного количества товара 
в таблице "balances" для каждой вставленной записи. Это делается с помощью оператора EXISTS, 
который выполняет запрос на проверку наличия записей, где количество товара (amount) 
в таблице "balances" больше или равно значению inserted.amount для соответствующего "goods_id".

Если условие проверки выполняется (IF EXISTS), то мы вычитаем количество товара 
из таблицы "balances" с помощью оператора UPDATE, используя соединение INNER JOIN 
между таблицами "balances" и "inserted". Затем мы вставляем записи в таблицу "tickets" 
из inserted, чтобы сохранить исходные значения.

Если условие проверки не выполняется (ELSE), мы вызываем ошибку с помощью RAISERROR 
и откатываем транзакцию (ROLLBACK TRANSACTION), чтобы отменить операцию вставки. 
Сообщение об ошибке будет указывать на недостаточное количество товара 
или отсутствие записи с указанным "goods_id".
*/
