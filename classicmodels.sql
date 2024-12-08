use classicmodels;

show tables;
select * from customers;

-- A procedure is a subroutine (like a subprogram) in a regular scripting language, stored in a database. 
-- In the case of MySQL, procedures are written in MySQL and stored in the MySQL database/server. 
-- A MySQL procedure has a name, a parameter list, and SQL statement(s). 



# Procedure without parameters
delimiter //
create procedure display_customers() 
	begin 
		select *from customers; 
	end //
    
call display_customers(); //


# Procedure with IN parameter
delimiter //
create procedure getCustomer(IN pcustNo INT)
Begin
	Select *
    from customers
    where customerNumber = pcustNo;
End//

call getCustomer(121);//



# Using IF

DELIMITER $$
CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;
    
    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    END IF;
END$$

DELIMITER ;

SELECT customerNumber, creditLimit
FROM customers
WHERE creditLimit < 50000
ORDER BY creditLimit DESC;

CALL GetCustomerLevel(298, @level);
SELECT @level;

call getcustomerlevel(173,@level);
select @level;

drop procedure GetCustomerLevel;


# Using IF-ELSE

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
	ELSE 
		SET pCustomerLevel = 'NOT PLATINUM';
    END IF;
END$$

DELIMITER ;

SELECT customerNumber, creditLimit
FROM customers
WHERE creditLimit <= 50000
ORDER BY creditLimit DESC;

CALL GetCustomerLevel(219, @level);
SELECT @level;

drop procedure GetCustomerLevel;


# Using IF-THEN-ELSEIF-ELSE

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END$$

DELIMITER ;


CALL GetCustomerLevel(447, @level);
SELECT @level;


# CASE -WHEN
DELIMITER $$

CREATE PROCEDURE GetCustomerShipping(
	IN  pCustomerNUmber INT, 
	OUT pShipping       VARCHAR(50)
)
BEGIN
    DECLARE customerCountry VARCHAR(100);

SELECT country
INTO customerCountry 
FROM customers
WHERE customerNumber = pCustomerNUmber;

    CASE customerCountry
		WHEN  'USA' THEN
		   SET pShipping = '2-day Shipping';
		WHEN 'Canada' THEN
		   SET pShipping = '3-day Shipping';
		ELSE
		   SET pShipping = '5-day Shipping';
	END CASE;
END$$

DELIMITER ;

CALL GetCustomerShipping(112,@shipping);
SELECT @shipping;


