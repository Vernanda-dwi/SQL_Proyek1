--Data definition language
SELECT * from project.clean_dqinventory
where stock_on_hand is null;

-- Melakukan CRUD pada tabel 
select * from project.dqinventory_upd

-- Create tabel baru 
create table project.dqinventory_upd as
SELECT 
	sale_id,
	date,
	product_name,
	product_category,
	replace(replace (product_cost,'Rp.',''),' ','') as product_cost_Rp,
	replace(replace(product_price,'Rp.',''),' ','') as product_price_Rp,
	units,
	store_name,
	store_city,
	store_location,
	store_open_date,
	stock_on_hand
from dqinventory.clean_dqinventory;


-- mengubah tipe data kolom productu_cost_rp jadi float
ALTER TABLE project.dqinventory_upd 
ALTER COLUMN product_cost_rp TYPE FLOAT
USING product_cost_rp::FLOAT;

UPDATE project.dqinventory_upd 
SET product_price_rp = 0
WHERE TRIM(product_price_rp ) = '' OR product_price_rp IS NULL;

-- Update type data jadi float
ALTER TABLE project.dqinventory_upd 
ALTER COLUMN product_price_rp TYPE FLOAT
USING product_price_rp::FLOAT;



-- menjadikan data null ke pada tabel stock on hand = 0
UPDATE dqinventory.dqinventory_upd 
SET stock_on_hand = 0
where stock_on_hand IS NULL;



-- EDA bisnis 1

-- 1. Berapa total revenue dari produk per kategori yang ada?
-- Menggelompokkan productnya berdasarkan kategori untuk mencari total revenue dan persentasenya(done)
select 
	product_category,
	sum(product_price_rp) as harga_product_rp, 
	SUM (units) as unit_terjual,
	sum (product_price_rp * units) as revenue,
	concat(sum(product_price_rp * units) / (select sum(product_price_rp * units) from project.dqinventory_upd) * 100,'%') as persentase
from project.dqinventory_upd
group by product_category

-- unit terjual per date nya dari tahun 2017 (DONE)
select 
	date,
	initcap(store_city) as store_city,
	stock_on_hand as total_persediaan,
	units as unit_terjual
from project.dqinventory_upd



-- Rata rata penjualan
select 
	sum(product_price_rp) as harga_produk,
	sum(units)  as produk_terjual,
	sum(product_price_rp) * sum(units) as revenue_total, 
	sum(product_price_rp) / sum(units) as rata_rata_penjualan_keseluruhan  
from project.dqinventory_upd



-- 2.Nama Produk apa yang memiliki Total Revenue dan Laba yang tinggi dan sebaliknya?
-- menghitung laba rugi nama produk
create table project.laba_rugi_produk as
select 
	product_name ,
	sum(product_cost_rp) as cost,
	sum (product_price_rp) as price,
	sum(units) as unit_terjual,
	sum (product_price_rp)*sum(units) as revenue,
	SUM(product_cost_rp)*sum(units) as expenses,
	round(sum(product_price_rp)*sum(units)) - (sum(product_cost_rp)*sum(units)) as laba_rugi
from project.dqinventory_upd
group by product_name 

-- select query
select * from project.laba_rugi_produk 

-- menghitung nilai statistika dari tabel laba rugi produk
-- mean dan median
select 
	ROUND(AVG(revenue)) as avg_revenue,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue)) AS median_revenue,
	ROUND(AVG(expenses)) as avg_expenses,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER by expenses )) AS median_expenses,
	ROUND(AVG(laba_rugi)) as avg_laba_rugi,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi)) AS median_laba_rugi
from project.laba_rugi_produk

-- karena mean > median maka ini terlihat bahwa ada oulier yang besar sehingga patokan saya akan lebih ke mediannya

-- EDA 2
-- Analisi laba rugi yang dibawah standar dari mediannya bagi city

select 
*
from project.laba_rugi_produk
where
 laba_rugi < (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi)) from project.laba_rugi_produk lrp )



-- 3.Kota mana yang memiliki nilai laba rugi yang memiliki performa yang baik (diatas rata rata sesuai ketapan) dan yang buruk
-- membuat tabel baru laba rugi berdasark store city
create table project.laba_rugi_city as
select 
	initcap(store_city) as store_city,
	sum(product_cost_rp) as cost,
	sum (product_price_rp) as price,
	sum(units) as unit_terjual,
	sum (product_price_rp)*sum(units) as revenue,
	SUM(product_cost_rp)*sum(units) as expenses,
	round(sum(product_price_rp)*sum(units)) - (sum(product_cost_rp)*sum(units)) as laba_rugi
from project.dqinventory_upd
group by store_city

-- hitung mean mediannya
select *
from project.laba_rugi_city 


select 
	round(AVG(unit_terjual)) as avg_unit_terjual,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY unit_terjual)) AS median_unit_terjual,
	ROUND(AVG(revenue)) as avg_revenue,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue)) AS median_revenue,
	ROUND(AVG(expenses)) as avg_expenses,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER by expenses )) AS median_expenses,
	ROUND(AVG(laba_rugi)) as avg_laba_rugi,
	ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi)) AS median_laba_rugi
from project.laba_rugi_city 

-- berdasarkan temuan mean dan median maka akan digunakan median untuk melihat performa unit terjual dan laba rugi dari city 

-- performa unit terjual di bawah median
select 
*
from project.laba_rugi_city
where
 unit_terjual < (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY unit_terjual )) from project.laba_rugi_city ) and
order by unit_terjual  desc 
 
-- performa laba rugi di bawah median
 
select 
*
from project.laba_rugi_city
where
 laba_rugi < (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi )) from project.laba_rugi_city )
 order by laba_rugi desc 
 
 -- performa laba rugi di bawah median
select 
*
from project.laba_rugi_city
where
 laba_rugi > (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi )) from project.laba_rugi_city )
 order by laba_rugi desc 
 
 
-- 4 kota dengan penjualan dan laba dengan performa yang buruk dengan unit terjual dan laba ruginya lebih kecil dari median
create table project.city_dq as
select 
*
from project.laba_rugi_city
where
 unit_terjual < (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY unit_terjual )) from project.laba_rugi_city )
 and   
 laba_rugi < (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi )) from project.laba_rugi_city )

 
-- 5.Kota denga unit terjual terbanyak dan memiliki stok barang tersisa terbanyak
 select 
 store_city,
 sum(stock_on_hand) + sum(units) as stok_awal,
 sum(units) as unit_terjual,
 sum(stock_on_hand) as stok_tersisa
 from project.dqinventory_upd
  where 
 	units > 1
 group by 
 	store_city 
 order by 
	sum(stock_on_hand) desc
	
--6. performa aba rugi produk yang tinggi
create table project.nama_produk 
select 
 	product_name,
 	sum(units) as unit_terjual,
 	SUM(product_price_rp*units ) as pendapatan,
 	sum(product_cost_rp * units) as biaya,
 	SUM(product_price_rp*units ) - sum(product_cost_rp * units) as laba_rugi
  from project.dqinventory_upd
 group by
	 	product_name 
	 	
-- membandingkan performa dengan median laba rugi keseluruhan untuk menilia performa laba rugi apakah tinggi
select *
from project.nama_produk np 
where	
  laba_rugi > (select ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY laba_rugi )) from project.nama_produk)
 order by 
 	laba_rugi desc