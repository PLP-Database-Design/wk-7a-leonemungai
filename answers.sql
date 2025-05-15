-- Question 1: Achieving 1NF (First Normal Form)
SELECT 
    OrderID,
         CustomerName,
       SUBSTRING_INDEX(Products, ',', 1) AS Product,
        SUBSTRING(Products, LOCATE(',', Products) + 1) AS Remaining
    FROM ProductDetail
    UNION ALL
       SELECT 
         OrderID,
         CustomerName,
                  SUBSTRING_INDEX(Remaining, ',', 1),
         SUBSTRING(Remaining, LOCATE(',', Remaining) + 1)
     FROM product_split
     WHERE Remaining IS NOT NULL AND LOCATE(',', Remaining) > 0
     UNION ALL
     SELECT 
         OrderID,
         CustomerName,
         Remaining,
         NULL
     FROM product_split
     WHERE Remaining IS NOT NULL AND LOCATE(',', Remaining) = 0
 SELECT 
     OrderID,
     CustomerName,
     TRIM(Product) AS Product
 FROM product_split;

 --Question 2: Achieving 2NF (Second Normal Form)
 -- Creating the Orders table (removes partial dependency of CustomerName on OrderID)

CREATE TABLE Orders AS
SELECT DISTINCT 
    OrderID,
    CustomerName
FROM OrderDetails;

-- Creating the OrderItems table (each item fully depends on the entire key: OrderID + Product)

CREATE TABLE OrderItems AS
SELECT 
    OrderID,
    Product,
    Quantity
FROM OrderDetails;