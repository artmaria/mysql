-- Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.

INSERT INTO book (title, author, price, amount)
    SELECT title, author, price, amount FROM supply
    WHERE author != "Булгаков М.А." and author != "Достоевский Ф.М.";

-- Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.

INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount FROM supply
    WHERE author NOT IN (SELECT author FROM book); 

-- Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы

UPDATE book 
SET price = price * 0.9 
WHERE amount BETWEEN 5 AND 10;

-- В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. А цену тех книг, которые покупатель не заказывал, снизить на 10%.

UPDATE book 
SET buy = IF(buy > amount, amount, buy),
    price = IF(buy = 0, price * 0.9, price); 

SELECT * FROM book; 

-- Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).

UPDATE book, supply
SET book.amount = book.amount + supply.amount, book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title;

SELECT * FROM book; 

-- Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.

DELETE FROM supply
WHERE author IN (SELECT author
                 FROM book 
                 GROUP BY author
                 HAVING SUM(amount) > 10);

SELECT * FROM supply; 

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.

CREATE TABLE ordering AS
SELECT author, title, (SELECT ROUND(AVG(amount)) FROM book) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) FROM book);
    
SELECT * FROM book;

-- Выбрать в таблице book книги, которые не заказали и которых осталось меньше 5 экземпляров. Создать таблицу orders для закупки этих книг в количестве 7 экземпляров каждого наименования.

CREATE TABLE orders AS
SELECT title, author, 7 AS amount
FROM book
WHERE title NOT IN (SELECT title FROM supply) AND amount < 5;

SELECT * FROM orders;

-- Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а», в отсортированном по убыванию даты последнего дня командировки виде. В результат включить столбцы name, city, per_diem, date_first, date_last.

SELECT name, city, per_diem, date_first, date_last FROM trip
WHERE name LIKE "%а %.%."
ORDER BY date_last DESC;

-- Вывести в алфавитном порядке фамилии и инициалы тех сотрудников, которые были в командировке в Москве.

SELECT DISTINCT name FROM trip
WHERE city = "Москва"
ORDER BY name;

-- Для каждого города посчитать, сколько раз сотрудники в нем были.  Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество.

SELECT city, COUNT(city) AS Количество FROM trip
GROUP BY city
ORDER BY city;

-- Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.

SELECT city, COUNT(city) AS Количество FROM trip
GROUP BY city
ORDER BY COUNT(city) DESC
LIMIT 2;
    


