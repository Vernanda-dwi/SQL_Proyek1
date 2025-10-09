-- Union 
--Menggabungkan data dan menghapus data duplikatnya

-- Union All
--Menggabungkan data tapi data duplikatnya tidak dihapus/ dibiarkan


-- Latihan union dengan menggabungkan tabel barang dan pelanggan

select b.kode_barang ,b.nama_barang  
from itbox_course.barang b 
union all
select p.kode_pelanggan ,p.nama_pelanggan 
from itbox_course.pelanggan p 

-- union beda tipe
select b.merk  
from itbox_course.barang b 
union all
select cast(p.tanggal_lahir as varchar)
from itbox_course.pelanggan p 

 
select * 
from itbox_course.barang b 
union 
select * 
from itbox_course.barang b 
