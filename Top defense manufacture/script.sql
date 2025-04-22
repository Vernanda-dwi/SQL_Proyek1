SELECT * FROM db_project.top_defense_manufacturers;
#update isi data pada kolom
update db_project.top_defense_manufacturers
set 2020_defense_revenue = replace(replace(2020_defense_revenue, '$', ''),",","");

update db_project.top_defense_manufacturers
set 2019_defense_revenue = replace(replace(2019_defense_revenue, '$', ''),",","")

update db_project.top_defense_manufacturers
set 2020_total_revenue = replace(replace(2020_total_revenue, '$', ''),",","")


#Merubah dulu yang colom 2019 revenuenya itu 0 karena datanya baru ada di tahun 2020
UPDATE db_project.top_defense_manufacturers
SET 2019_defense_revenue = 0
WHERE 2019_defense_revenue = 'N/A';

# memilih company yang berasal dari negara yanga kan dipilih beserta revenuenya dari tahun 2019 2020
SELECT 
  company,
  country,
  leadership,
  2019_defense_revenue,
  2020_defense_revenue,
	2020_total_revenue
FROM db_project.top_defense_manufacturers 
where country = 'U.S.' or country = 'China'

SELECT 
  company,
  country,
  leadership,
  2019_defense_revenue,
  2020_defense_revenue,
	2020_total_revenue
FROM db_project.top_defense_manufacturers 
where country = 'Russia'

#mengkategorikan negara ke satu nama
select * from (
	Select company,
	case
	when country in ('Canada', 'France', 'Germany', 'Italy', 
	'Netherlands', 'Norway', 'Spain', 'Sweden', 'Turkey', 'U.K.', 'Netherlands/France')
	then 'NATO'
	ELSE country
	end as Country_Group_Update, 
	leadership,
  2019_defense_revenue,
  2020_defense_revenue,
  2020_total_revenue
	FROM db_project.top_defense_manufacturers) AS SQ_Update1
where Country_Group_Update ='NATO';