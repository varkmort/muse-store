-- Создание таблицы "types"
CREATE TABLE muse_store.types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_TypeName CHECK (dbo.ValidateName([name])),
    license BIT
);
go

-- Создание таблицы "goods"
CREATE TABLE muse_store.goods (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_GoodsName CHECK (dbo.ValidateName([name])),
    price MONEY,
    article NVARCHAR(100) CONSTRAINT CHK_Art CHECK (dbo.ValidateName(article)),
    type_id INT REFERENCES muse_store.types(id),
    age_limit INT CHECK (age_limit >= 0)
);
go

-- Создание таблицы "positions"
CREATE TABLE muse_store.positions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_Name CHECK (dbo.ValidateName([name]))
);

-- Создание таблицы "employees"
CREATE TABLE muse_store.employees (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_EmployeesName CHECK (dbo.ValidateName([name])),
    surename NVARCHAR(100) CONSTRAINT CHK_EmployeesSurename CHECK (dbo.ValidateName([surename])),
    position_id INT REFERENCES positions(id),
    [password] NVARCHAR(100) CONSTRAINT CHK_EmployeesPassword CHECK (dbo.ValidateName([password])),
    username NVARCHAR(100) CONSTRAINT CHK_EmployeesUsername CHECK (dbo.ValidateName([username])),
    inner_id INT NOT NULL
);


-- Создание таблицы "clients"
CREATE TABLE muse_store.clients (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_ClientName CHECK (dbo.ValidateName([name])),
    surename NVARCHAR(100) CONSTRAINT CHK_ClientSurename CHECK (dbo.ValidateName(surename)),
    bank_card NVARCHAR(100)
);

-- Создание таблицы "suppliers"
CREATE TABLE muse_store.suppliers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_SupplierName CHECK (dbo.ValidateName([name])),
    inn NVARCHAR(100)
);

-- Создание таблицы "supplies"
CREATE TABLE supplies (
    id INT IDENTITY(1,1) PRIMARY KEY,
    goods_id INT  REFERENCES muse_store.goods(id),
    amount INT,
    in_price MONEY,
    supplier_id INT REFERENCES muse_store.suppliers(id),
    [date] DATE
);

-- Создание таблицы "balances"
CREATE TABLE balances (
    id INT IDENTITY(1,1) PRIMARY KEY,
    goods_id INT REFERENCES muse_store.goods(id),
    amount INT
);

-- Создание таблицы "sale_types"
CREATE TABLE sale_types (
    id INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(100) CONSTRAINT CHK_SaleTypeName CHECK (dbo.ValidateName([name]))
);

-- Создание таблицы "sales"
CREATE TABLE sales (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employe_id INT REFERENCES muse_store.employees(id),
    client_id INT REFERENCES muse_store.clients(id),
    [date] DATE,
    sale_type_id INT REFERENCES muse_store.sale_types(id)
);

-- Создание таблицы "tickets"
CREATE TABLE tickets (
    id INT IDENTITY(1,1) PRIMARY KEY,
    goods_id INT REFERENCES muse_store.goods(id),
    amount INT,
    sale_id INT REFERENCES muse_store.sales(id),
    discount DECIMAL(5,2)
);
