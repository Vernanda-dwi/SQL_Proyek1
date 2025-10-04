-- Perintah IN

select * from itbox_course.barang b 
where merk in ('Samsung','Apple')
and stok > 10

select * from itbox_course.barang b 
where merk in ('Samsung','Apple')
or stok > 10



select * from itbox_course.barang b 
where merk not in ('Samsung','Apple')


-- Perintah Like
select * from itbox_course.pelanggan p 
where alamat like '%No%'
-- Kolom alamat yang mengandung kata No

select * from itbox_course.pelanggan p 
where alamat like '%Pondok Indah%'

-- Between
-- menarik data hanya untuk rentang menimum samai maksimum. Dpaat digunakan pada data numerik,teks dan tanggal
-- and nya dianggap bukan operator logika
select* from itbox_course.transaksi_header th 
where total_harga  between 800000 and 1000000

select* from itbox_course.transaksi_header th 
where total_barang  between 2 and 3
	and total_harga > 800000
	

-- Order By
-- mengurutkan data baik numerik , tek, tanggal

select* from itbox_course.transaksi_header th 
order by 
 tanggal_transaksi desc
 ,total_barang desc
 

