USE Project;
GO

select * from Amazon_Review
select* from category_data
select* from Own_Rating_Table
select * from R_table

--the average rating for each product 
SELECT ar.Unique_ID, AVG(r.Rating) AS Avg_Rating
FROM amazon_review ar
JOIN r_table r ON ar.Rating_ID = r.Rating_ID
GROUP BY ar.Unique_ID 
ORDER BY Avg_Rating DESC;

-- Recognizing the number of reviews with positive sentiment for each category
SELECT c.category, COUNT(*) AS Positive_Review_Count
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN Own_Rating_Table ort ON ar.Own_Rating_ID = ort.Own_Rating_ID
WHERE ort.Own_Rating = 'Positive'
GROUP BY c.category
ORDER BY Positive_Review_Count;

-- Rank Reviews Within Each Category by Rating
SELECT ar.Category_ID, ar.Review_Header, ar.Review_text, r.Rating,
ROW_NUMBER() OVER(PARTITION BY ar.Category_ID ORDER BY r.Rating DESC) AS Review_Rank
FROM amazon_review ar
JOIN r_table r ON ar.Rating_ID = r.Rating_ID;

-- Identifying all reviews containing the word "battery" in the review text
SELECT ar.Review_Header, ar.Review_text, c.category
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
WHERE ar.Review_text LIKE '%battery%';

-- Identifying Top-Rated Amazon Products with Average Rating of Higher than 3
SELECT ar.category_ID, c.category, AVG(r.Rating) AS Avg_Rating
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN r_table r ON ar.Rating_ID = r.Rating_ID
GROUP BY ar.category_ID, c.category
HAVING AVG(r.Rating) > 3
ORDER BY Avg_Rating DESC;

-- Find the Most Reviewed Category
SELECT c.category, COUNT(*) AS Review_Count
FROM amazon_review ar
JOIN category_data c ON ar.Category_ID = c.Category_ID
GROUP BY c.Category
ORDER BY Review_Count;

-- Count the Number of Reviews per Year
SELECT YEAR(Rating_Date) AS Review_Year, COUNT(*) AS Review_Count
FROM Own_Rating_table
GROUP BY YEAR(Rating_Date)
ORDER BY Review_Year;

-- Find the Products with Ratings Greater Than 4
SELECT c.category, ar.Review_Header, r.Rating
FROM amazon_review ar
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN R_table r ON ar.Rating_ID = r.Rating_ID
WHERE r.Rating > 4
order by c.category;

-- Identify Most Common Complaints Across Categories
SELECT ar.Category_ID, ar.Review_text, COUNT(*) AS Complaint_Count
FROM amazon_review ar
WHERE ar.Own_Rating_ID IN (SELECT Own_Rating_ID FROM Own_Rating_table WHERE Own_Rating = 'Negative')
GROUP BY ar.Category_ID, ar.Review_text
ORDER BY Complaint_Count DESC;

-- Show the 10 most recent reviews with their corresponding ratings and categories and rating date
SELECT TOP 10 ar.Review_Header, r.Rating, c.category, ort.Rating_Date
FROM amazon_review ar
JOIN r_table r ON ar.Rating_ID = r.Rating_ID
JOIN category_data c ON ar.category_ID = c.category_ID
JOIN Own_Rating_Table ort ON ar.Own_Rating_ID = ort.Own_Rating_ID
ORDER BY ort.Rating_Date DESC;









