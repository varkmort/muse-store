CREATE TRIGGER IncreaseBalanceAmount
ON supplies
AFTER INSERT
AS
BEGIN
    -- Обновление существующих записей
    UPDATE balances
    SET amount = amount + inserted.amount
    FROM balances
    INNER JOIN inserted ON balances.goods_id = inserted.goods_id;

    -- Добавление новой записи в balances, если она отсутствует
    INSERT INTO balances (goods_id, amount)
    SELECT inserted.goods_id, inserted.amount
    FROM inserted
    WHERE NOT EXISTS (
        SELECT 1
        FROM balances
        WHERE balances.goods_id = inserted.goods_id
    );
END;
