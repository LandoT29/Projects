DROP SCHEMA IF EXISTS McDonaldsDatabase;

CREATE SCHEMA McDonaldsDatabase;

USE McdonaldsDatabase;

CREATE TABLE MenuItems (
    ItemID INTEGER PRIMARY KEY,
    ItemName VARCHAR(255),
    ItemType VARCHAR(50),
    Price DECIMAL(10, 2)
);


CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    PaymentType VARCHAR(50),
    OrderDetails VARCHAR(255),
    OrderCost DECIMAL(10, 2)
);


CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Title VARCHAR(50),
    Wage DECIMAL(10, 2),
    Address VARCHAR(255)
);


CREATE TABLE Locations (
    StoreNumber INTEGER PRIMARY KEY,
    Address VARCHAR(255),
    State VARCHAR(50),
    ManagerID INTEGER,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
    );



INSERT INTO MenuItems (ItemID, ItemName, ItemType, Price) 
VALUES 
(1, 'Big Mac', 'Burger', 3.99),
(2, 'McChicken', 'Burger', 2.49),
(3, 'French Fries', 'Side', 1.89),
(4, 'Filet-O-Fish', 'Burger', 4.29),
(5, 'McFlurry', 'Dessert', 2.79),
(6, 'Chicken McNuggets', 'Burger', 5.99),
(7, 'Double Cheeseburger', 'Burger', 2.49),
(8, 'Apple Pie', 'Dessert', 1.29),
(9, 'Sausage McMuffin', 'Breakfast', 1.99),
(10, 'Hash Browns', 'Breakfast', 1.19);


INSERT INTO Customers (CustomerID, PaymentType, OrderDetails, OrderCost) 
VALUES 
(1, 'Credit Card', 'Big Mac, French Fries', 5.88),
(2, 'Cash', 'McChicken, French Fries, Coke', 6.99),
(3, 'Mobile Payment', 'Filet-O-Fish, Large Coke', 5.49),
(4, 'Credit Card', 'Chicken McNuggets, Apple Pie', 7.28),
(5, 'Cash', 'Double Cheeseburger, French Fries', 4.38),
(6, 'Cash', 'McFlurry, Hash Browns', 3.98),
(7, 'Credit Card', 'Sausage McMuffin, Hash Browns, Orange Juice', 4.99),
(8, 'Mobile Payment', 'Big Mac, Apple Pie', 5.28),
(9, 'Cash', 'McChicken, French Fries', 4.38),
(10, 'Credit Card', 'Chicken McNuggets, McFlurry, Large Coke', 10.06);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Title, Wage, Address) 
VALUES 
(1, 'John', 'Doe', 'Cashier', 10.50, '123 Main St'),
(2, 'Jane', 'Smith', 'Manager', 15.75, '456 Elm St'),
(3, 'Michael', 'Johnson', 'Cook', 12.25, '789 Oak St'),
(4, 'Emily', 'Brown', 'Cashier', 10.25, '101 Pine St'),
(5, 'David', 'Davis', 'Janitor', 9.00, '111 Maple St'),
(6, 'Sarah', 'Wilson', 'Manager', 15.75, '222 Cedar St'),
(7, 'Chris', 'Jones', 'Cook', 12.25, '333 Birch St'),
(8, 'Amanda', 'Martinez', 'Cashier', 10.50, '444 Walnut St'),
(9, 'Kevin', 'Anderson', 'Janitor', 9.00, '555 Hickory St'),
(10, 'Michelle', 'Lee', 'Manager', 15.75, '666 Cherry St');


INSERT INTO Locations (StoreNumber, Address, State, ManagerID) 
VALUES 
(1, '123 Main St', 'CA', 2),
(2, '456 Elm St', 'NY', 6),
(3, '789 Oak St', 'TX', 7),
(4, '101 Pine St', 'FL', 4),
(5, '111 Maple St', 'CA', 5),
(6, '222 Cedar St', 'NY', 10),
(7, '333 Birch St', 'TX', 3),
(8, '444 Walnut St', 'FL', 8),
(9, '555 Hickory St', 'CA', 9),
(10, '666 Cherry St', 'NY', 1);

ALTER TABLE Locations
ADD CONSTRAINT fk_ManagerID FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID);

SELECT * FROM MenuItems;
SELECT * FROM Customers;
SELECT * FROM Employees;
SELECT * FROM Locations;

SELECT Locations.*, Employees.FirstName AS ManagerFirstName, Employees.LastName AS ManagerLastName
FROM Locations
JOIN Employees ON Locations.ManagerID = Employees.EmployeeID;

-- Task 10.2

ALTER TABLE MenuItems
ADD CONSTRAINT uc_ItemName UNIQUE (ItemName), 
ADD CONSTRAINT chk_Price_nonnegative CHECK (Price >= 0); 

ALTER TABLE Customers
ADD CONSTRAINT pk_CustomerID PRIMARY KEY (CustomerID), 
ADD CONSTRAINT chk_OrderCost_nonnegative CHECK (OrderCost >= 0); 

ALTER TABLE Employees
ADD CONSTRAINT uc_FirstName_LastName UNIQUE (FirstName, LastName), 
ADD CONSTRAINT chk_Wage_positive CHECK (Wage > 0); 

ALTER TABLE Locations
ADD CONSTRAINT pk_StoreNumber PRIMARY KEY (StoreNumber), 
ADD CONSTRAINT chk_State_abbreviation CHECK (State IN ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY')); -- Ensure State contains valid state abbreviations

UPDATE Customers
SET OrderDetails = 'John Doe'
WHERE CustomerID = 1;

UPDATE Customers
SET OrderCost = '7.99'
WHERE CustomerID = 2;

UPDATE Customers
SET OrderCost = OrderCost * 1.1
WHERE CustomerID = 3;

DELETE FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Customers
    WHERE PaymentType = 'Credit Card'
);

DELETE FROM Customers
WHERE CAST(OrderDate AS DATE) = '2023-01-01';

DELETE FROM MenuItems
WHERE Price BETWEEN 2.00 AND 3.00;

-- Create a table using data from two separate tables
CREATE TABLE CustomerOrders (
    OrderID INTEGER PRIMARY KEY AUTO_INCREMENT,
    CustomerID INTEGER,
    ItemName VARCHAR(255),
    OrderCost DECIMAL(10, 2),
    PaymentType VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ItemName) REFERENCES MenuItems(ItemName)
);

INSERT INTO CustomerOrders (CustomerID, ItemName, OrderCost, PaymentType)
SELECT c.CustomerID, c.OrderDetails, c.OrderCost, c.PaymentType
FROM Customers c;

-- Create a table using data from one table
CREATE TABLE EmployeeLocations (
    EmployeeID INTEGER,
    StoreNumber INTEGER,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Title VARCHAR(50),
    Address VARCHAR(255),
    State VARCHAR(50),
    Wage DECIMAL(10, 2),
    PRIMARY KEY (EmployeeID, StoreNumber),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (StoreNumber) REFERENCES Locations(StoreNumber)
);

INSERT INTO EmployeeLocations (EmployeeID, StoreNumber, FirstName, LastName, Title, Address, State, Wage)
SELECT e.EmployeeID, l.StoreNumber, e.FirstName, e.LastName, e.Title, e.Address, l.State, e.Wage
FROM Employees e
JOIN Locations l ON e.EmployeeID = l.ManagerID;
