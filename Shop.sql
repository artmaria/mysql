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
    Id        INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Name      VARCHAR(100),
    City      VARCHAR(100),
    Telephone VARCHAR(20),
    Birthday  DATE
);

CREATE TABLE Categories
(
    Id   INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Products
(
    Id          INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Name        VARCHAR(200),
    Description VARCHAR(2000),
    CategoryId  INT,
    Price       DECIMAL(19, 2),
    CONSTRAINT Products_Categories_FK
        FOREIGN KEY (CategoryId) REFERENCES Categories (Id)
);

CREATE TABLE Orders
(
    Id          INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CustomerId  INT,
    Date        DATE,
    Address     VARCHAR(200),
    CONSTRAINT Orders_CustomersId_FK
        FOREIGN KEY (CustomerId) REFERENCES Customers (Id)
);

CREATE TABLE ProductsOrder
(
    Id           INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    OrderId      INT,
    ProductId    INT,
    ProductCount INT,
    CONSTRAINT ProductsOrder_Orders_FK
        FOREIGN KEY (OrderId) REFERENCES Orders (id),
    CONSTRAINT ProductsOrder_Products_FK
        FOREIGN KEY (ProductId) REFERENCES Products (Id)
);

INSERT Customers(Name, City, Telephone, Birthday)
VALUES 
    ("Samuel Adamson", "London", "802036574563", "1983-12-05"),
    ("Jack Aldridge", "Manchester", "802056324812", "1999-12-31"),
    ("Kate Stivel", "Edinburgh", "802054732656", "1995-03-05"),
    ("Alex Barkut", "London", "802045618529", "2002-11-19"),
    ("George Wilson", "Belfast", "802083659642", "1989-05-12");
    
INSERT Categories (Name)
VALUES
    ("Gaming accessories"),
    ("Home & kitchen essentials"),
    ("Shop Pet supplies"),
    ("Computers & Accessories"),
    ("Health & Personal Care");
    
INSERT Products(Name, Description, CategoryId, Price)
VALUES
    ("Xbox Series X", "Introducing Xbox Series X, the fastest, most powerful Xbox ever. Play thousands of titles from four Generations of Consoles - all games look and play best on Xbox Series X. At the heart of Series X is the Xbox Velocity architecture, which pairs a custom SSD with integrated software for faster, streamlined gameplay with significantly reduced load times. Seamlessly move between multiple games in a Flash with quick resume. Explore rich new worlds and enjoy the action like never before with the unmatched 12 Teraflops of raw graphic processing power. Enjoy 4K gaming at up to 120 frames per second, advanced 3D spatial sound, and more. Get started with an instant library of 100+ high-quality games, including all new Xbox Game Studios titles the day they launch like Halo Infinite, with Xbox Game Pass ultimate (membership sold separately). If you purchased Xbox All Access at Amazon, please visit the Xbox website directly for steps on how to upgrade at a participating Xbox All Access retailer. Amazon is not an Xbox All Access participating retailer for Xbox Series X|S. For financing related questions, contact Citizens One.",  1, 520),
    ("Sony PlayStation Classic Console Holiday 20 Games Bonus Bundle", "Put your gaming hats on and immerse yourself into a fantastical world. The Sony PlayStation is just what you need for a gaming night with your friends. This classic edition console lets you play 20 pre-loaded games. It comes with two wired controllers and a virtual memory card.This PlayStation from Sony is smaller than the original PlayStation and big on fun! Launch yourself in a virtual world of fun and experience the all-new PlayStation like never before. This classic PlayStation is lightweight and sleek and will provide you with years of fun expriences. Any time is game time! Show your enthusiasm as a gamer and jump in on your PlayStation!", 1, 120),
    ("Breville BES870XL Barista Express Espresso Machine, Brushed Stainless Steel", "The Breville Barista Express delivers third wave specialty coffee at home using the 4 keys formula and is part of the Barista Series that offers all in one espresso machines with integrated grinder to go from beans to espresso in under one minute", 2, 599),
    ("Ninja AF101 Air Fryer, 4 Qt, Black/gray", "Now enjoy guilt free food; Air fry with up to 75 percent less fat than traditional frying methods; Tested against hand cut, deep fried French fries", 2, 95),
    ("WYFDP Pet Climbing Frame Multi-function Cat Climbing Shelf Cat Scratching Board Funny Cat Supplies (Color : Gray, Size : One size)", "After raising a cat, the cat becomes the soul of the home. To let the cat play comfortably, we choose three elements: the stars, the moon, and the cat hole.", 3, 50),
    ("Apple Pencil (2nd Generation), White", "Apple Pencil (2nd generation) brings your work to life. With imperceptible lag, pixel-perfect precision, and tilt and pressure sensitivity, it transforms into your favorite creative instrument, your paint brush, your charcoal, or your pencil", 4, 25),
    ("Roku Streaming Stick 4K 2021 | Streaming Device 4K/HDR/Dolby Vision with Roku Voice Remote and TV Controls", "Hides behind your TV: The all-new design plugs right into your TV with a simple setup", 4, 49),
    ("CeraVe AM Facial Moisturizing Lotion SPF 30 | Oil-Free Face Moisturizer with Sunscreen | Non-Comedogenic | 3 Ounce", "A micro-fine zinc oxide sunscreen for UVA/UVB protection. This CeraVe moisturizer with SPF is a hydrating facial lotion that spreads easily, is absorbed quickly, and leaves a non-greasy finish", 5, 19);

INSERT Orders(CustomerId, Date, Address)
VALUES 
    (1, "2022-08-07", "44 Cedar Avenu, London"),
    (2, "2022-08-06", "15 Iner St, Manchester"),
    (3, "2022-08-07", "452 Sweetsun St, Edinburgh"),
    (4, "2022-08-02", "12 Asoul Avenu, London"),
    (5, "2022-08-05", "18 Framenet St, Belfast");
    
INSERT ProductsOrder(OrderId, ProductId, ProductCount)
VALUES
    (1, 2, 1),
    (2, 1, 2),
    (3, 3, 1),
    (3, 4, 3),
    (4, 5, 4),
    (4, 6, 1),
    (5, 8, 1);
    
-- Просмотреть все данные в таблицах.
 
SELECT * FROM Customers;
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM ProductsOrder;

-- Вывести  название продукта, категорию и цену, отсортировать по убыванию цены. Оставить только те, у которых цена больше или равна 100.

SELECT Products.Name AS "Product Name", Categories.Name AS "Category", Products.Price FROM Products
JOIN Categories ON CategoryId = Categories.Id
WHERE Price >= 100
ORDER BY Price DESC;

-- Вывести OrderId, название товара, цену, количество и общую сумму.

SELECT  ProductsOrder.OrderId, Products.Name, Products.Price, ProductCount, ProductCount * Products.price AS TotalAmount FROM ProductsOrder
JOIN Products ON ProductId = Products.Id;

 -- Вывести OrderId и общую сумму всего заказа. 
 
SELECT  ProductsOrder.OrderId, SUM(ProductCount * Products.price) AS TotalAmount FROM ProductsOrder
JOIN Products ON ProductId = Products.Id
GROUP BY OrderId;

-- Вывести таблицу с именем покупателя, телефоном, датой и суммой заказа, отсортировать по дате заказа.

SELECT Orders.Id, Customers.Name, Customers.Telephone, Orders.Date, 
    (SELECT SUM(Products.Price * ProductCount) FROM Products
    JOIN ProductsOrder ON Products.Id = ProductId
    WHERE Orders.Id = OrderId
    GROUP BY OrderId) AS TotalAmount
FROM Customers
JOIN Orders ON Customers.Id = CustomerId
ORDER BY Orders.Date;

-- Вывести сымый дорогой продукт из каждой категории, указав название продукта, цену и категорию

SELECT  Products.Name, max(Price), Categories.Name FROM Products
JOIN Categories ON CategoryId = Categories.Id
GROUP BY CategoryId;

-- Вывести категорию и количество продуктов

SELECT Categories.Name, COUNT(*) AS ProductsCount FROM Categories
Join Products ON CategoryId = Categories.Id
GROUP BY CategoryId;







    







    
    