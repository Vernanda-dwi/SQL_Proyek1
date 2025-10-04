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
