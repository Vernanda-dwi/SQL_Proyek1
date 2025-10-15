
-- Mengubah tipe data pada kolom Date yang awalnya varchar
-- menambah kolom baru
alter table project2.hotel_book 
add column tanggal date;

-- memasukkan data ke tabel baru dengan tipe data date
update project2.hotel_book 
set tanggal = to_date("Date",'DD/MM/YYYY');

-- lalu menghapus kolom lama dan mengganti nama kolom baru
ALTER TABLE project2.hotel_book DROP COLUMN "Date";

ALTER TABLE project2.hotel_book  RENAME COLUMN tanggal TO "Date";

-- Lalu disini akan memilih kolom mana yang relevan untuk di analisis  
select from project2.hotel_book;
  
-- Memasukkan tabel terbaru dari kolom yang telah dipilih
create table project2.Hotel_Profit AS
	SELECT 
		"Date", 
		"Month", 
		"Weekday", 
		"Season", 
		"Holiday", 
		"Booking_Channel", 
		"Guest_Type", 
		"Guest_Country", 
		"Revenue",
		"Room_Revenue",
		"Revenue" - "Room_Revenue" as "Food_&_Baverage_Revenue",
		"Marketing_Spend",
		"Operating_Expenses", 
		"Fixed_Costs", 
		"Variable_Costs", 
		"Fixed_Costs"+ "Variable_Costs" as "Total_costs",
		"Revenue" - "Marketing_Spend"- "Operating_Expenses" as "Profit"
	FROM project2.hotel_book;

 -- merapikan data yang ada

	SELECT 
		"Date", 
		case 
			when "Month" = 1 then 'Januari'
			when "Month" = 2 then 'Februari'
			when "Month" = 3 then 'Maret'
		end as "Month", 
		"Weekday", 
		"Season", 
		case 
			when "Holiday"= 1 then 'Yes'
			else 'No'
		end as "Holiday", 
		"Booking_Channel", 
		"Guest_Type", 
		"Guest_Country", 
		"Revenue",
		"Room_Revenue",
		"Revenue" - "Room_Revenue" as "Food_&_Baverage_Revenue",
		"Marketing_Spend",
		"Operating_Expenses", 
		"Fixed_Costs", 
		"Variable_Costs", 
		"Fixed_Costs"+ "Variable_Costs" as "Total_costs",
		"Revenue" - "Marketing_Spend"- "Operating_Expenses" as "Profit"
	FROM project2.hotel_book
	where
		"Month" <= 3
		