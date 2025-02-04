/* Hypothesis: 
From my background knowledge in the US and car enthusiast, I believe the Brand will have 
the most influence on the price. I want to create multiple tables separating the brands and to analyze the models
themselves from each brand to notice any trends. */

Use sold_cars;

SELECT * FROM sold_cars.car_price_dataset;


Create Table DistinctBrandsTable As
SELECT DISTINCT Brand FROM car_price_dataset
ORDER BY Brand ASC;


/*Although I can automate the process of creating the tables(which I tried, I commented out the code below this section of code)
I ran into too many issues and figure for this instance I'll create them manually since there's not too many tables to create.
*/

Use sold_cars;
Create Table Audi_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Audi';

Use sold_cars;
Create Table BMW_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'BMW';

Use sold_cars;
Create Table Chevrolet_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Chevrolet';

Use sold_cars;
Create Table Ford_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Ford';

Use sold_cars;
Create Table Honda_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Honda';

Use sold_cars;
Create Table Hyundai_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Hyundai';

Use sold_cars;
Create Table Kia_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Kia';

Use sold_cars;
Create Table Mercedes_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Mercedes';

Use sold_cars;
Create Table Toyota_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Toyota';

Use sold_cars;
Create Table Volkswagen_Cars As
SELECT * FROM car_price_dataset
WHERE Brand = 'Volkswagen';


/* Attempt at creating a cursor and automating tables being created by brand. */
/*
Use sold_cars;
Create Procedure curdemo()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    Declare brandie VARCHAR(50);

    Declare BrandCursor CURSOR FOR (Select Brand from sold_cars.DistinctBrandsTable);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    Open BrandCursor

/* Beginning the cursor loops 
    read_loop: Loop
        Fetch BrandCursor INTO brandie;
        If done Then
            LEAVE read_loop;
        End If;
        While (@@FETCH_STATUS = 0)
            BEGIN
                Use sold_cars;
                Create Table brandie As
                SELECT * FROM car_price_dataset
                WHERE Brand = brandie;
            Fetch next from BrandCursor into brandie
            End;
    End loop;
    END While;
    Close BrandCursor
End;
*/

/* Other brands that would be in the price range of 4k-5k, 5k-6k, 6k-7k, 7k-8k */

Use sold_cars;
Select count(Brand) As 'Number of Cars sold per Brand', Brand, avg(price) As 'Avg Sold Price' FroM car_price_dataset
Where (price BETWEEN 4000 and 5000)
GROUP BY brand
Order By count(Brand) DESC;

Use sold_cars;
Select count(Brand) As 'Number of Cars sold per Brand', Brand, avg(price) As 'Avg Sold Price' FroM car_price_dataset
Where (price BETWEEN 5000 and 6000)
GROUP BY brand
Order By count(Brand) DESC;

Use sold_cars;
Select count(Brand) As 'Number of Cars sold per Brand', Brand, avg(price) As 'Avg Sold Price' FroM car_price_dataset
Where (price BETWEEN 6000 and 7000)
GROUP BY brand
Order By count(Brand) DESC;

Use sold_cars;
Select count(Brand) As 'Number of Cars sold per Brand', Brand, avg(price) As 'Avg Sold Price' FroM car_price_dataset
Where (price BETWEEN 7000 and 8000)
GROUP BY brand
Order By count(Brand) DESC;


/*Checking the difference of cars sold in total by brands. */
Select count(Brand) AS 'Number of Cars from a Brand' , Brand As 'Distinct Brand'
From sold_cars.car_price_dataset
GROUP BY Brand
ORDER BY count(Brand) DESC;


/* I want to compare the difference between the mileage and the price of
Toyota's and Audi's. I would think Toyota's would have a higher mileage since 
most of there line up is economical while Audi's is more luxurious. */

Select Brand, Avg(Mileage), Avg(Price) from sold_cars.car_price_dataset
Where (Brand Like 'T%') OR (Brand Like 'A%')
Group By Brand
;

/*A customer may only be interested in Honda's and BMW's, although I can
filter out from the main dataset these two brands. I want to try another way
by using inner-joins */

Drop table Honda_vs_BMW;
Drop table Kia_vs_Hyundai;

Create Table Honda_vs_BMW
Select Honda_Cars.Year,Honda_Cars.Price - BMW_Cars.Price As 'Difference in Price', 
ABS(Honda_Cars.Price - BMW_Cars.Price) As 'Absolute_Difference_in_Price',
 Honda_Cars.Price AS 'Price of Sold Honda', BMW_Cars.Price As 'Price of Sold BMW' 
From Honda_Cars
INNER JOIN BMW_Cars On Honda_Cars.Year = BMW_Cars.Year;

Select Avg(Absolute_Difference_in_Price) As 'Average Difference of Prices between Honda and BMW' From sold_cars.Honda_vs_BMW;


Create Table Kia_vs_Hyundai
Select Kia_Cars.Year,Kia_Cars.Price - Hyundai_Cars.Price As 'Difference in Price', 
ABS(Kia_Cars.Price - Hyundai_Cars.Price) As 'Absolute_Difference_in_Price',
 Kia_Cars.Price AS 'Price of Sold Honda', Hyundai_Cars.Price As 'Price of Sold BMW' 
From Kia_Cars
Inner JOIN Hyundai_Cars On Kia_Cars.Year = Hyundai_Cars.Year;


Select Avg(Absolute_Difference_in_Price) As 'Average Difference of Prices between Kia and BMW' From sold_cars.Kia_vs_Hyundai;



/*Bonus:*/
/* Observing which transmission in a car is sold the most each year. */

Select Transmission, Count(*) from sold_cars.car_price_dataset
group by transmission;

Select Transmission, Count(*), Year from sold_cars.car_price_dataset
group by transmission, Year
ORDER BY Year ASC;

/* It appears there is no significant difference between the number of cars sold
with differing transmissions.

Which fuel types seem to be the most popular fuel type among the brands?
*/
Select Fuel_Type, Brand, count(*) from sold_cars.car_price_dataset
group by Brand, Fuel_Type
ORDER BY Brand;

/* Which brand has the cleanest cars by fuel type? */
Select Fuel_Type As 'Fuel Type', Brand, count(*) As 'Count of Cars' from sold_cars.car_price_dataset
Where Fuel_Type Like 'E%'
group by Brand, Fuel_Type
ORDER BY count(*) DESC;

/* Let's checkout the number of owners*/

Select Owner_Count As 'Owner Count', count(*) As 'Count of Cars' from sold_cars.car_price_dataset
group by Owner_Count
ORDER BY count(*) DESC;


