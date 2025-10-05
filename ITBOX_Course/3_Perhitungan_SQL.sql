--SUM

select 	
	*, 
	total_barang * total_harga  
	from itbox_course.transaksi_header th 

select 
	kode_pelanggan,
	sum(total_harga) as total_harga 
from itbox_course.transaksi_header th 
group by kode_pelanggan 


select 
	date_part('year',tanggal_transaksi) as tahun,
	date_part('month',tanggal_transaksi) as bulan,
	sum(total_harga) as total_harga,
	AVG(total_harga) as avg_harga
from itbox_course.transaksi_header th
group by
	date_part('year',tanggal_transaksi),
	date_part('month',tanggal_transaksi)


-- Agregat dengan Konsdisi
	
-- total harga per pelanggan dimana tahun transaksi 2021
select 
	kode_pelanggan,
	SUM(total_harga) as total_harga	,
	tanggal_transaksi 
from itbox_course.transaksi_header th 
where 
	date_part('Year',tanggal_transaksi) = '2021'
group by
	kode_pelanggan,
	tanggal_transaksi 
	
	
--Total harga per pelanggan 
--dimana tanggal transaksi setelah 31 januari 2021
select 
	kode_pelanggan ,
	tanggal_transaksi ,
	sum(total_harga)
from itbox_course.transaksi_header th 
where tanggal_transaksi > '2021-01-31'
group by
	kode_pelanggan,
	tanggal_transaksi 
	
-- total harga per tanggal
--	dimana total barang diatas 500000

select 
tanggal_transaksi,
 total_barang,  
SUM(total_harga) as total_harga
from itbox_course.transaksi_header th 
where
	total_harga > 500000
group by 
	tanggal_transaksi, 
	total_barang 
	
-- WHERE Dan Having

--where itu dijalankan sebelum fungsi agregat (sebelum group by)
--having setelah fungsi agregat ( setelah group by)
	
--Total harga per pelanggan 
--dimana tanggal transaksi setelah 31 januari 2021
-- dengan total harga setela agregasi adl  sebesar 1 jt
select 
	kode_pelanggan ,
	tanggal_transaksi ,
	sum(total_harga)
from itbox_course.transaksi_header th 
where tanggal_transaksi > '2021-01-31'
group by
	kode_pelanggan,
	tanggal_transaksi 
having
	sum(total_harga) > 1000000
	
	
	
-- tampilkan merek barang selain jenis stilus,
--yang total nilai barang (harga * stock)
--dibawah 5000000

select 
	merk,
	SUM(stok * harga) as nilai_barang 
from itbox_course.barang b 
where
	nama_barang not like '%Stilus%'
group by 
	merk
having SUM(stok *harga) < 5000000


	
	

	
	