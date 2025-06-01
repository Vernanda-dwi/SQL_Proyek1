--Membuat tabel akun
create table akun (
	akun_id SERIAL primary key,
	nama_akun VARCHAR,
	tipe_akun VARCHAR
	)

-- Membuat tabel jurnal umum
create table jurnalumum (
	jurnal_id SERIAL primary key,
	akun_id INT,
	tanggal date,
	keterangan VARCHAR,
	debit DECIMAL,
	kredit DECIMAL,
	foreign key (akun_id) references akun(akun_id)
	
) 

-- Membuat Tabel Bukubesar

create table bukubesar (
 	bukubesar_id SERIAL PRIMARY KEY, 
    akun_id INT, 
    saldo_awal DECIMAL(10,2),  
	saldo_akhir DECIMAL(10,2),
	foreign key (akun_id) references akun(akun_id)
    );



-- Memasukkan data ke tabel akun
insert into akun (nama_akun,tipe_akun) VALUES
	('Kas','Aset'),
	('Piutang Usaha','Aset'),
	('Hutang Usaha','Kewajiban'),
	('Modal Pemilik','Ekuitas'),
	('Pendapatan Jasa','Pendapatan'),
	('Beban Gaji','Beban');
select * from akun


-- Memasukkan data ke tabel jurnalumum
insert into jurnalumum (akun_id,tanggal,keterangan,debit,kredit) values 
	(1,'2024-04-01','Kas Masuk',10000,0),
	(2,'2024-04-02','Piutang Masuk',5000,0),
	(5,'2024-04-03','Pendapatan Atas Jasa',0,15000),
	(6,'2024-04-04','Beban Atas Gaji',3000,0),
	(3,'2024-04-05','Hutang Usaha',0,4000);
select * from jurnalumum 


-- Memasukkan data ke tabel bukubesar

insert into bukubesar (akun_id,saldo_awal,saldo_akhir) values 
	(1,0,10000),
	(2,0,5000),
	(3,0,-4000),
	(4,0,0),
	(5,0,-15000),
	(6,0,3000);




-- Membuat saldo akhir dari akun
select 
	a.akun_id ,
	a.nama_akun,
	coalesce(sum(j.debit),0) - coalesce(sum(j.kredit),0) as saldo_akhir
from akun as a 
left join jurnalumum as j
	on a.akun_id = j.akun_id
group by
	a.akun_id
order by
	a.akun_id asc
	
	
	
-- Membuat  laporan Laba rugi
	with 
		pend as (
		select 
			coalesce(sum(j.kredit) - sum(j.debit),0) as total_pendapatan
		from akun as a 
		left join jurnalumum as j
			on a.akun_id = j.akun_id
		where
			tipe_akun ='Pendapatan'
	), beban as(
		select 
			coalesce(sum(j.debit) - sum(j.kredit),0) as total_beban
		from akun as a 
		left join jurnalumum as j
			on a.akun_id = j.akun_id
		where
			tipe_akun ='Beban'
	)
	
	select 
		total_pendapatan,
		total_beban,
		total_pendapatan-total_beban as laba_bersih
		from pend,beban
	
	
	



-- membuat neraca
with 
	aset as(
	select 
		coalesce(sum(j.debit) - sum(j.kredit),0) as total_aset
	from akun as a 
	left join jurnalumum as j
		on a.akun_id = j.akun_id
	where
		tipe_akun ='Aset'
		
), kewajiban as(
	select 
		coalesce(sum(j.debit) - sum(j.kredit),0) as total_kewajiban
	from akun as a 
	left join jurnalumum as j
		on a.akun_id = j.akun_id
	where
		tipe_akun ='Kewajiban'
		
), ekuitas as(
	select 
	coalesce(sum(j.debit) - sum(j.kredit),0) as total_ekuitas
	from akun as a 
	left join jurnalumum as j
		on a.akun_id = j.akun_id
	where
		tipe_akun ='Ekuitas'		
	)
	

select 
	total_aset,
	total_kewajiban,
	total_ekuitas
from aset,kewajiban,ekuitas











