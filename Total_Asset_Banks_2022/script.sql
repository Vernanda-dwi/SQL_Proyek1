SELECT * FROM db_project.`largest-banks`;

# update data pada kolom Bank_name 
UPDATE db_project.`largest-banks`
SET Bank_name = REPLACE(Bank_name, 'Â', '');

# rata rata total asset 2022
SELECT CEIL(AVG(Total_assets_2022_US_Billion)) AS rata_rata_keseluruhan FROM db_project.`largest-banks`;

# karena rata rata keseluruhan 1120 maka jika total asset dibawah 1120 maka kinerjanya buruk dan jika di atas itu maka total assetnya baik
SELECT *,
CASE
 WHEN Total_assets_2022_US_Billion > 1120 THEN 'Good'
 ELSE 'Bad' 
END AS Kategori
FROM db_project.`largest-banks`;

# jumlah keseluruhan asset bank negara USA
SELECT ROUND(SUM(Total_assets_2022_US_Billion),2) AS Total_Asset_Bank_In_USA2022 FROM db_project.`largest-banks`
WHERE 
Country = "United States of America"
	
# perbandingan seluruh negara dari yang terbesar
SELECT Country, ROUND(SUM(Total_assets_2022_US_Billion),2) AS Total_Asset_Bank_In_2022 FROM db_project.`largest-banks`
GROUP BY country
ORDER BY Total_Asset_Bank_In_2022 DESC;

# perbandingan seluruh negara dari yang terkecil
SELECT Country, ROUND(SUM(Total_assets_2022_US_Billion),2) AS Total_Asset_Bank_In_2022 FROM db_project.`largest-banks`
GROUP BY country
ORDER BY Total_Asset_Bank_In_2022 ASC

#nama bank dari amerika keseluruhan
SELECT * FROM db_project.`largest-banks`
WHERE Country = "United States of America"


