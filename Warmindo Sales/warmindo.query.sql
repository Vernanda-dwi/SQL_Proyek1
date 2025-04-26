#Read data
SELECT * FROM db_project.warmindo_data;

# Ubah tipe data date 
ALTER TABLE db_project.warmindo_data
	ADD COLUMN tanggal_transaksi_ DATE;

UPDATE db_project.warmindo_data
SET tanggal_transaksi_ = DATE_ADD('1899-12-30', INTERVAL tanggal_transaksi DAY);

#UPDATE TIPE DATA KOLOM 
ALTER TABLE db_project.warmindo_data
	MODIFY COLUMN total_harga FLOAT;
    
#Delete kolom kategori produk
ALTER TABLE db_project.warmindo_data
	DROP column kategori_produk;

ALTER TABLE db_project.warmindo_data
	DROP column tanggal_transaksi;

#update jenis kelamin
UPDATE db_project.warmindo_data
SET jenis_kelamin = 'Perempuan'
WHERE jenis_kelamin = 'Permpuan';

UPDATE db_project.warmindo_data
SET jenis_kelamin = 'Laki-laki'
WHERE jenis_kelamin = 'Laki';

# Menampilkan data pembayaran CASH dan jenis kelamin laki laki
SELECT * FROM db_project.warmindo_data
	WHERE jenis_pembayaran = "CASH" and jenis_kelamin="Perempuan" and jenis_pesanan="Dine-in"
	Order by total_harga DESC;
    
SELECT * FROM db_project.warmindo_data
	WHERE jenis_pembayaran = "CASH" and jenis_kelamin="Laki-laki" and jenis_pesanan="Dine-in"
	Order by total_harga DESC;

SELECT count(jenis_kelamin) as Perempuan 
FROM db_project.warmindo_data
	WHERE jenis_pembayaran = "CASH" and jenis_kelamin="Perempuan";

SELECT count(jenis_kelamin) as Laki_laki
FROM db_project.warmindo_data
	WHERE jenis_pembayaran = "CASH" and jenis_kelamin="Laki-laki" ;

#total harga perempuan dan laki laki
SELECT jenis_kelamin ,sum(total_harga) as jumlah
FROM db_project.warmindo_data
group by jenis_kelamin;

#persentase total harga perempuan dan laki laki
SELECT jenis_kelamin 
,sum(total_harga) as jumlah
,concat(round(sum(total_harga)  / (select sum(total_harga) from db_project.warmindo_data)*100,2),"%") as persentase
FROM db_project.warmindo_data
group by jenis_kelamin;

#aggregarion query
# Memilih nama produk yang paling banyak terjual
SELECT nama_produk, sum(quantity) as total_terjual,
harga_jual, sum(total_harga) as total_penjualan
FROM db_project.warmindo_data
group by nama_produk
order by sum(quantity) desc;

#DINE IN VS DELIVERY
select jenis_pesanan, count(jenis_pesanan) as jumlah 
FROM db_project.warmindo_data
group by jenis_pesanan;

select * from db_project.warmindo_data;
#DINE IN VS DELIVERY GENDER
select jenis_kelamin,count(jenis_pesanan) as jenis_pesanan 
FROM db_project.warmindo_data
where jenis_pesanan = 'Dine-in'
group by jenis_kelamin;

# Memisahkan tanggal transaksi untuk di visualisasikan
SELECT quantity,total_harga,jenis_kelamin,tanggal_transaksi_,
	CASE
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 1 THEN 'Januari'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 2 THEN 'Februari'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 3 THEN 'Maret'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 4 THEN 'April'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 5 THEN 'Mei'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 6 THEN 'Juni'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 7 THEN 'Juli'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 8 THEN 'Agustus'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 9 THEN 'September'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 10 THEN 'Oktober'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 11 THEN 'November'
		WHEN EXTRACT(MONTH FROM tanggal_transaksi_) = 12 THEN 'Desember'
		ELSE 'Tidak Diketahui'
	END AS Bulan_nama
FROM db_project.warmindo_data
order by bulan_nama asc;
