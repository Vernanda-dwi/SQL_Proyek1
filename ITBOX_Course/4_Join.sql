select * from itbox_course.barang b 

-- Inner Join
select 
	a.*,
	b.nama_pelanggan
from itbox_course.transaksi_header as a
join  itbox_course.pelanggan as b
	on a.kode_pelanggan = b.kode_pelanggan

	




