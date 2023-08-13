CREATE DATABASE E_Commerce;
use e_commerce;
CREATE TABLE supplier (
SUPP_ID int PRIMARY KEY,
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50) NOT NULL,
SUPP_PHONE varchar(50) NOT NULL);

CREATE TABLE customer(CUS_ID int PRIMARY KEY, CUS_NAME varchar(20) NOT NULL, CUS_PHONE varchar(10) NOT NULL, CUS_CITY varchar(30) NOT NULL, CUS_GENDER char);

CREATE TABLE category(CAT_ID int PRIMARY KEY, CAT_NAME varchar(20) NOT NULL);

CREATE TABLE product(PRO_ID int PRIMARY KEY, PRO_NAME varchar(20) NOT NULL DEFAULT "Dummy", PRO_DESC varchar(60), CAT_ID int, FOREIGN KEY (CAT_ID) REFERENCES category(CAT_ID));

CREATE TABLE supplier_pricing(PRICING_ID int PRIMARY KEY, PRO_ID int references product(PRO_ID), SUPP_ID int references supplier(SUPP_ID), SUPP_PRICE int default 0);

CREATE TABLE `order`(ORD_ID int PRIMARY KEY, ORD_AMOUNT int NOT NULL, ORD_DATE date NOT NULL, CUS_ID int references customer(CUS_ID), PRICING_ID int references supplier_pricing(PRICING_ID));

Create TABLE rating(RAT_ID int PRIMARY KEY, ORD_ID int references `order`(ORD_ID), RAT_RATSTARS int NOT NULL);

INSERT INTO supplier values 
(1,"Rajesh Retails","Delhi","1234567890"),
(2,"Appario Ltd.","Mumbai","2589631470"),
(3,"Knome products","Banglore","9785462315"),
(4,"Bansal Retails","Kochi","8975463285"),
(5,"Mittal Ltd.","Lucknow","7898456532");

INSERT INTO customer values 
(1,"AAKASH","9999999999","DELHI","M"),
(2,"AMAN","9785463215","NOIDA","M"),
(3,"NEHA","9999999999","MUMBAI","F"),
(4,"MEGHA","9994562399","KOLKATA","F"),
(5,"PULKIT","7895999999","LUCKNOW","M");

INSERT INTO category values 
(1,"BOOKS"),
(2,"GAMES"),
(3,"GROCERIES"),
(4,"ELECTRONICS"),
(5,"CLOTHES");

INSERT INTO product values 
(1,"GTA V","Windows 7 and above with i5 processor and 8GB RAM",2),
(2,"TSHIRT","SIZE-L with Black, Blue and White variations",5),
(3,"ROG LAPTOP","Windows 10 with 15inch screen, i7 processor, 1TB SSD",4),
(4,"OATS","Highly Nutritious from Nestle",3),
(5,"HARRY POTTER","Best Collection of all time by J.K Rowling",1),
(6,"MILK","1L Toned MIlk",3),
(7,"Boat Earphones","1.5Meter long Dolby Atmos",4),
(8,"Jeans","Stretchable Denim Jeans with various sizes and color",5),
(9,"Project IGI","compatible with windows 7 and above",2),
(10,"Hoodie","Black GUCCI for 13 yrs and above",5),
(11,"Rich Dad Poor Dad","Written by RObert Kiyosaki",1),
(12,"Train Your Brain","By Shireen Stephen",1);

INSERT INTO supplier_pricing values
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

INSERT INTO `order` values
(101,1500,"2021-10-06",2,1),
(102,1000,"2021-10-12",3,5),
(103,30000,"2021-09-16",5,2),
(104,1500,"2021-10-05",1,1),
(105,3000,"2021-08-16",4,3),
(106,1450,"2021-08-18",1,9),
(107,789,"2021-09-01",3,7),
(108,780,"2021-09-07",5,6),
(109,3000,"2021-09-10",5,3),
(110,2500,"2021-09-10",2,4),
(111,1000,"2021-09-15",4,5),
(112,789,"2021-09-16",4,7),
(113,31000,"2021-09-16",1,8),
(114,1000,"2021-09-16",3,5),
(115,3000,"2021-09-16",5,3),
(116,99,"2021-09-17",2,14);

INSERT INTO rating values
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);

-- 3) Display the total number of customers based on gender who have placed orders of worth at least Rs.3000

Select count(ord.cus_id) as Number_of_Customers, cus.cus_gender as Gender from `order` ord 
INNER JOIN customer cus 
ON ord.cus_id = cus.cus_id 
where ORD_AMOUNT>=3000 
group by cus.cus_gender;

-- 4) Display all the orders along with product name ordered by a customer having Customer_Id=2

Select ord.* , pd.pro_name from `order` ord 
INNER JOIN supplier_pricing sup ON ord.pricing_id=sup.pricing_id 
INNER JOIN product pd ON sup.pro_id=pd.pro_id 
where ord.cus_id=2;

-- 5)	Display the Supplier details who can supply more than one product.

Select count(pro_id) Number_of_products,sup.* from supplier_pricing sup_p 
INNER JOIN supplier sup On sup_p.supp_id=sup.supp_id 
group by supp_id having count(pro_id)>1 ;

-- 6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product

SELECT c.cat_id,c.cat_name,MIN(t1.minPrice) FROM category c
INNER JOIN
(
	SELECT prd.cat_id,prd.pro_name,t2.* FROM product prd
    INNER JOIN(
		SELECT sp.pro_id,MIN(sp.supp_price) as minPrice FROM SUPPLIER_PRICING sp
        group by sp.pro_id
	) as t2 ON prd.pro_id=t2.pro_id
) as t1 ON t1.cat_id=c.cat_id
GROUP BY t1.cat_id;

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”

Select p.pro_id, p.Pro_name from `order`as o INNER JOIN
supplier_pricing as s ON s.pricing_id=o.pricing_id
INNER JOIN product as p ON p.pro_id=s.pro_id
where ord_date>"2021-10-05";

-- 8)	Display customer name and gender whose names start or end with character 'A'.

Select cus_name,cus_gender from customer where cus_name like "A%" OR cus_name like "%A";

-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
--      For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

DELIMITER &&
Create PROCEDURE getSupplierDetails()
BEGIN
(
SELECT report.supp_name, Report.supp_id, report.average_rating
,CASE
	WHEN report.average_rating>4 THEN 'Genuine Supplier'
    WHEN report.average_rating>2 THEN 'Average Supplier'
	ELSE
	'Supplier should not be considered'
END as type_of_supplier from
(
Select s.supp_name, s.supp_id,v.average_rating from supplier as s
INNER JOIN
(Select sp.supp_id,  avg (r.rat_ratstars) as average_rating from rating as r
INNER JOIN `order` o ON o.ord_id=r.ord_id
INNER JOIN supplier_pricing sp ON o.pricing_id=sp.pricing_id
group by sp.supp_id) as v
ON v.supp_id=s.supp_id) as report);
END;

call getSupplierDetails();