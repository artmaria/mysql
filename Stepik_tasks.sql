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

-- Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город ,  длительность командировки в днях, при этом первый и последний день относится к периоду командировки). Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию названий городов (в обратном алфавитном порядке).

SELECT name, city, DATEDIFF(date_last,  date_first)+1 AS Длительность FROM trip
WHERE city NOT IN ("Москва","Санкт-Петербург")
ORDER BY Длительность DESC, city DESC;
 
-- Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить столбцы name, city, date_first, date_last.
 
SELECT name, city, date_first, date_last FROM trip
WHERE DATEDIFF(date_last, date_first) = (SELECT MIN(DATEDIFF(date_last, date_first)) FROM trip);

-- Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). В результат включить столбцы name, city, date_first, date_last. Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .

SELECT name, city, date_first, date_last FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city, name;

-- Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. Название столбцов – Месяц и Количество.

SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество FROM trip
GROUP BY Месяц
ORDER BY Количество DESC, Месяц;

-- Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма

SElECT name, SUM(per_diem * (DATEDIFF(date_last, date_first)+1)) AS Сумма FROM trip
GROUP BY name
HAVING COUNT(name)>3
ORDER BY Сумма DESC;

-- Создать таблицу fine

CREATE TABLE fine (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE,
    date_payment DATE
);

-- В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)
VALUES
("Баранов П.Е.", "Р523ВТ", "Превышение скорости(от 40 до 60)", NULL, "2020-02-14", NULL),
("Абрамова К.А.", "О111АВ", "Проезд на запрещающий сигнал", NULL, "2020-02-23", NULL),
("Яковлев Г.Р.", "Т330ТТ", "Проезд на запрещающий сигнал", NULL, "2020-03-03", NULL);

-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.

UPDATE fine, traffic_violation AS tv
SET fine.sum_fine=tv.sum_fine
WHERE (fine.sum_fine IS NULL) AND fine.violation=tv.violation;

SELECT * FROM fine

-- Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз. При этом учитывать все нарушения, независимо от того,  оплачены они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.

SELECT name, number_plate, violation FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation)>=2
ORDER BY name, number_plate, violation;

-- в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE 
    fine f, payment p 
SET 
    f.date_payment = p.date_payment,
    f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation) <= 20, f.sum_fine / 2, f.sum_fine)
WHERE f.name = p.name
    AND f.number_plate = p.number_plate
    AND f.violation = p.violation
    AND f.date_payment is null;
    
SELECT * FROM fine;

-- Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.

CREATE TABLE back_payment (
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8, 2),
    date_violation DATE
);
INSERT INTO back_payment(name, number_plate, violation, sum_fine, date_violation)
SELECT name, number_plate, violation, sum_fine, date_violation FROM fine 
WHERE fine.date_payment is null;

-- Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 

DELETE FROM fine 
WHERE date_violation < "2020-02-01";
 

   


    


