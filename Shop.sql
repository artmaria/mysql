USE shop;

ALTER TABLE Products
DROP
FOREIGN KEY Products_Categories_FK;
ALTER TABLE Orders
DROP
FOREIGN KEY Orders_CustomersId_FK;
ALTER TABLE ProductsOrder
DROP
FOREIGN KEY ProductsOrder_Orders_FK;
ALTER TABLE ProductsOrder
DROP
FOREIGN KEY ProductsOrder_Products_FK;

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS ProductsOrder;

CREATE TABLE Customers
(
    Id        INT NOT NULL PRIMARY KEY,
    Name      VARCHAR(100),
    City      VARCHAR(100),
    Telephone VARCHAR(20),
    Birthday  DATE
);

CREATE TABLE Categories
(
    Id   INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Products
(
    Id          INT NOT NULL PRIMARY KEY,
    Name        VARCHAR(100),
    Description VARCHAR(500),
    CategoryId  INT,
    Price       DECIMAL(19, 2) UNSIGNED,
    CONSTRAINT Products_Categories_FK
        FOREIGN KEY (CategoryId) REFERENCES Categories (Id)
);

CREATE TABLE Orders
(
    Id          INT NOT NULL PRIMARY KEY,
    CustomerId  INT,
    Date        DATE,
    Address     VARCHAR(200),
    TotalAmount DECIMAL(19, 2) UNSIGNED,
    CONSTRAINT Orders_CustomersId_FK
        FOREIGN KEY (CustomerId) REFERENCES Customers (Id)
);

CREATE TABLE ProductsOrder
(
    Id           INT NOT NULL PRIMARY KEY,
    OrderId      INT,
    ProductId    INT,
    ProductCount INT,
    CONSTRAINT ProductsOrder_Orders_FK
        FOREIGN KEY (OrderId) REFERENCES Orders (id),
    CONSTRAINT ProductsOrder_Products_FK
        FOREIGN KEY (ProductId) REFERENCES Products (Id)
);



