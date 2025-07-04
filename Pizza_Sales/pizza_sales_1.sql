SELECT 
	pizza_id, 
	order_id, 
	pizza_name_id, 
	quantity, 
	order_date, 
	order_time, 
	unit_price, 
	total_price, 
	pizza_size, 
	pizza_category,  
	pizza_name
FROM project2.pizza_sales_cln;



-- mengubah tipe data oredr date dan time jadi date dan time
SELECT 
	pizza_id, 
	order_id, 
	pizza_name_id,
	cast(order_date as date) as order_date, 
	extract(month from cast(order_date as date)) as month,
	cast(order_time as time)  as order_time,
	quantity, 
	unit_price as unit_price_$ , 
	total_price as total_price_$ , 
	pizza_size, 
	pizza_category,  
	pizza_name
FROM project2.pizza_sales_cln
order by cast(order_date as date) desc


-- statistik pada data

select 	
	round(avg(total_price_$::numeric),2) as mean_total_price_$ 
from (
	SELECT 
	SUM(total_price) as total_price_$,   
	pizza_name
FROM project2.pizza_sales_cln
group by 
	pizza_name
	) as sub1
	
-- median dan median
select 	
	PERCENTILE_CONT(0.5) within group (order by total_price) as median_total_price,
	round(AVG(total_price)::numeric,2) as mean_total_price,
	PERCENTILE_CONT(0.5) within group (order by quantity) as median_quantity,
	round(AVG(quantity)::numeric,2) as mean_quantity
FROM project2.pizza_sales_cln



-- 1.	Nama pizza dengan total price dengan performa di atas rata rata atau median
-- EDA 1
--  A. DI atas rata rata
SELECT 
	pizza_name,
	ceil(SUM(total_price::numeric)) as total_price_$
FROM project2.pizza_sales_cln
group by 
	pizza_name
having 
	 ceil(SUM(total_price::numeric)) > 
	 		(
			 select 	
			round(avg(total_price_$::numeric),2) as mean_total_price_$ 
		from (
				SELECT 
				SUM(total_price) as total_price_$,   
				pizza_name
			FROM project2.pizza_sales_cln
			group by 
				pizza_name
				) as sub1
			  )
order by
	 ceil(SUM(total_price::numeric)) desc
limit 5

-- 	B. di bawah rata rata 

SELECT 
	pizza_name,
	ceil(SUM(total_price::numeric)) as total_price_$
FROM project2.pizza_sales_cln
group by 
	pizza_name
having 
	 ceil(SUM(total_price::numeric)) < (
			 select 	
			round(avg(total_price_$::numeric),2) as mean_total_price_$ 
		from (
			SELECT 
			SUM(total_price) as total_price_$,   
			pizza_name
		FROM project2.pizza_sales_cln
		group by 
			pizza_name
			) as sub1)
order by
	 ceil(SUM(total_price::numeric)) asc
limit 5


SELECT 
	pizza_id, 
	order_id, 
	pizza_name_id,
	cast(order_date as date) as order_date, 
	extract(month from cast(order_date as date)) as month,
	cast(order_time as time)  as order_time,
	quantity, 
	unit_price as unit_price_$ , 
	total_price as total_price_$ , 
	pizza_size, 
	pizza_category,  
	pizza_name
FROM project2.pizza_sales_cln



-- 2. performa penjualan pizza per bulannya baik dari total penjualannya maupun dari total pricenya keseluruhan
	
select 
	date_part('month',order_date::date) as bulan,
	sum(quantity) as jumlah_penjualan,
	sum(total_price) as total_sales_$
FROM project2.pizza_sales_cln
	group by 	
		date_part('month',order_date::date)
order by
	date_part('month',order_date::date) asc


--3. kategori pizza dengan keuntungan terbesar
select 
pizza_category,
ceil(sum(total_price::numeric)),
sum(total_price::numeric) / (
	select sum(total_price::numeric)
	from project2.pizza_sales_cln
	)*100 as persentase
FROM project2.pizza_sales_cln
group by pizza_category




select * from project2.pizza_sales_cln psc 


--4.laporan bulanan dari jumlah penjualan, total sales
select 
	date_part('MONTH', order_date::date) as month,
	COUNT(distinct order_id) as total_order,
	round(sum(total_price)::numeric,2) as total_sales
from project2.pizza_sales_cln psc 
group by 
	date_part('MONTH', order_date::date)


