
               /* ANALISIS TENTANG SERANGAN TERORISME */


Select count(*)
from PortfolioProject..GlobalTerrorism;

Select top 10 *
	from PortfolioProject..GlobalTerrorism;

Select len(attacktype1_txt) as lens
	from PortfolioProject..GlobalTerrorism 
	order by lens desc;


---------- Cek nama kolom dan jenis datanya

SELECT COLUMN_NAME, DATA_TYPE
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'GlobalTerrorism';


---------- Membuat tabel baru dengan data yang kita butuhkan saja

Create table GlobalTerrorism_2
	(Year float, 
	 Month float,
	 Day float,
	 Country nvarchar(300),
	 Region nvarchar(300),
	 City nvarchar(300),
	 Latitude float,
	 Longitude float,
	 Attack_Type nvarchar(300),
	 Targets nvarchar(300),
	 Killed float,
	 Wounded float,
	 Summary nvarchar(3000),
	 Group_Terrorist nvarchar(300),
	 Target_Type nvarchar(300),
	 Weapon_Type nvarchar(300),
	 Motive nvarchar(300));

Insert into GlobalTerrorism_2 
	(Year, 
	 Month,
	 Day,
	 Country,
	 Region,
	 City,
	 Latitude,
	 Longitude,
	 Attack_Type,
	 Targets,
	 Killed,
	 Wounded,
	 Summary,
	 Group_Terrorist,
	 Target_Type,
	 Weapon_Type,
	 Motive)
	select 
	iyear, imonth, iday, country_txt, region_txt, city, latitude, longitude,
	attacktype1_txt, target1, nkill, nwound, summary, gname, targtype1_txt,
	weaptype1_txt, motive
	from GlobalTerrorism;

Update GlobalTerrorism_2
	set Killed = 0
	where Killed is null;

Update GlobalTerrorism_2
	set Wounded = 0
	where Wounded is null;
	
Alter table GlobalTerrorism_2
	add Casualties float;

Update GlobalTerrorism_2
	set Casualties = Killed + Wounded;

Select Top 10 *
	from PortfolioProject..GlobalTerrorism_2;


---------- Analisis secara global

--- Total serangan terorisme di dunia yang pernah terjadi
Select count(*) as total_serangan, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2;

--- Negara paling banyak mengalami serangan teroris
Select country, count(*) as num_terror
	from GlobalTerrorism_2 
	group by Country order by num_terror desc;

--- WIlayah paling banyak mengalami serangan terroris
Select region, count(*) as num_terror
	from GlobalTerrorism_2 
	group by region order by num_terror desc;

--- Serangan teroris top 10 paling banyak korban yang meninggal dunia
Select top 10 * 
	from GlobalTerrorism_2
	order by Killed desc;

--- Serangan terroris yang paling banyak korban yang meninggal dunia
Select * 
	from GlobalTerrorism_2 
	where killed = (select max(killed) from GlobalTerrorism_2);

--- Serangan teroris top 10 paling banyak korban jiwa (korban yang meninggal dan korban terluka)
Select top 10 * 
	from GlobalTerrorism_2
	order by Casualties DESC;

--- Serangan teroris yang paling banyak korban jiwa (korban meninggal & korban terluka)
Select *
	from GlobalTerrorism_2
	where Casualties = (select max(Casualities) from GlobalTerrorism_2);

--- Total serangan teroris per tahun di dunia
Select year, count(*) as num_terror
	from GlobalTerrorism_2 
	group by year order by year;

--- Total serangan teroris berdasakan metode penyerangannya
Select Attack_Type, count(*) as total
	from GlobalTerrorism_2
	group by Attack_Type order by total desc;

--- Total serangan teroris berdasarkan jenis senjatanya
Select Weapon_Type, count(*) as total
	from GlobalTerrorism_2
	group by Weapon_Type order by total desc;

--- Total serangan teroris berdasarkan target serangan
Select Target_Type, count(*) as total
	from GlobalTerrorism_2
	group by Target_Type order by total desc;

--- Total serangan teroris berdasarkan grup teroris
Select Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	group by Group_Terrorist order by total desc;

--- Total serangan per tahun dan total korbannya
Select Year, count(*) as total_terror, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2
	group by Year
	order by Year, casualties, total_terror;


---------- Analisis secara Region

--- Wilayah paling banyak mengalami serangan terroris
Select region, count(*) as num_terror, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2 
	group by region order by num_terror desc;

--- Total serangan berdasarkan wilayah dan negara
Select Region, Country, count(*) as total
	from GlobalTerrorism_2
	group by Region, Country
	order by Region, total desc, Country;

--- Total serangan teroris berdasakan wilayah dan tahun
Select Year, Region, count(*) as total
	from GlobalTerrorism_2
	group by Year, Region order by Year, Region;

--- Total serangan berdasarkan wilayah dan attack type
Select Region, Attack_Type, count(*) as total
	from GlobalTerrorism_2
	group by Region, Attack_Type order by Region, total desc, Attack_Type;

--- Total serangan berdasakan wilayah dan weapon type
Select Region, Weapon_Type, count(*) as total
	from GlobalTerrorism_2
	group by Region, Weapon_Type order by Region, total desc, Weapon_Type;

--- Total serangan berdasakan wilayah dan target attack
Select Region, Target_Type, count(*) as total
	from GlobalTerrorism_2
	group by Region, Target_Type order by Region, total desc, Target_Type;

--- Total serangan berdasarkan wilayah dan grup teroris
Select Region, Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	where Group_Terrorist != 'Unknown'
	group by Region, Group_Terrorist order by Region, total desc, Group_Terrorist;

--- Total serangan berdasarkan wilayah dan total korban
Select Region, count(*) as total_teror, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2
	group by Region
	order by casualties desc, total_teror desc;

--- Total serangan berdasarkan wilayah, negara, dan total korban
Select Region, country, count(*) as total_teror, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2
	group by Region, Country
	order by region, casualties desc, total_teror desc;


---------- Analisis secara Group Terrrorist

--- Grub teroris yang paling banyak melakukan serangan teroris
Select Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	group by Group_Terrorist order by total desc;

--- Serangan teroris per tahun berdasarkan grup teroris
Select Year, Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	group by Year, Group_Terrorist order by Year, Group_Terrorist;

--- Total serangan berdasarkan wilayah dan grup teroris
Select Region, Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	group by Region, Group_Terrorist order by Region, total desc, Group_Terrorist;

--- Total serangan berdasarkan negara dan grup teroris
Select Country, Group_Terrorist, count(*) as total
	from GlobalTerrorism_2
	group by Country, Group_Terrorist order by Country, total desc, Group_Terrorist;

--- Total serangan berdasarkan grub dan attack type
Select Group_terrorist, Attack_Type, count(*) as total
	from GlobalTerrorism_2
	group by Group_terrorist, Attack_Type
	order by Group_terrorist, total desc;

--- Total serangan berdasarkan grub dan weapon type
Select Group_terrorist, Weapon_Type, count(*) as total
	from GlobalTerrorism_2
	group by Group_terrorist, Weapon_Type
	order by Group_terrorist, total desc;

--- Total serangan berdasarkan grub dan target type
Select Group_terrorist, Target_Type, count(*) as total
	from GlobalTerrorism_2
	group by Group_terrorist, Target_Type
	order by Group_terrorist, total desc;

--- Total serangan berdasarkan grub dan korbannya
Select Group_Terrorist, count(*) as total_terror, sum(Killed) as killed, sum(Wounded) as wounded, sum(Casualties) as casualties
	from GlobalTerrorism_2
	Group by Group_Terrorist
	order by casualties desc, total_terror desc;


---------- Serangan teroris di Indonesia

--- Total serangan teroris di Indonesia yang pernah tercatat
Select count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia';

--- Kota di Indonesia yang paling banyak mengalami serangan teroris
Select City, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by city order by total_terror desc;

--- Serangan teroris di Indonesia yang paling banyak menyebabkan orang meninggal dunia
Select * 
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	order by Killed Desc;

--- Serangan teroris di Indonesia yang paling banyak korban meninggal dan terluka
Select * 
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	order by Casualties Desc;

--- Total serangan teroris per tahunnya di Indonesia
Select Year, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by Year Order by Year;

--- Tahun paling banyak serangan Teroris di Indonesia
Select Year, count(*) as total_terror
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by Year order by total_terror desc;

--- Group teroris yang paling banyak menyerang di Indonesia
Select Group_Terrorist, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia' 
	group by Group_Terrorist order by total_terror desc;

--- Jenis serangan teroris yang paling banyak di Indonesia 
Select Attack_Type, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by Attack_Type order by total_terror desc;

--- Target yang paling banyak diserang teroris di Indonesia
Select Target_Type, count(*) as total_terror,sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by Target_Type order by total_terror desc;

--- Jenis senjata yang paling banyak dipakai teroris di Indonesia 
Select Weapon_Type, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Country = 'Indonesia'
	group by Weapon_Type order by total_terror desc;


---------- Serangan teroris di Asia Tenggara

--- Total serangan teroris di Asia Tenggara yang pernah tercatat
Select count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia';

--- Negara di Asia Tenggara yang paling banyak mengalami serangan teroris
Select Country, count(*) as total, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Country order by total desc;

--- Serangan teroris di Asia Tenggara yang paling banyak menyebabkan orang meninggal dunia
Select top 50 * 
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	order by Killed Desc;

--- Serangan teroris di Asia Tenggara yang paling banyak korban meninggal dan terluka
Select top 50 * 
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	order by Casualties Desc;

--- Total serangan teroris per tahunnya di Asia tenggara
Select Year, count(*) as total_terror, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Year Order by Year;

--- Tahun paling banyak serangan Teroris di Asia Tenggara
Select Year, count(*) as total
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Year order by total desc;

--- Group teroris yang paling banyak menyerang di Asia Tenggara
Select Group_Terrorist, count(*) as total, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia' 
	group by Group_Terrorist order by total desc;

--- Jenis serangan teroris yang paling banyak di Asia Tenggara
Select Attack_Type, count(*) as total, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Attack_Type order by total desc;

--- Target yang paling banyak diserang teroris di Asia Tenggara
Select Target_Type, count(*) as total, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Target_Type order by total desc;

--- Jenis senjata yang paling banyak dipakai teroris di Asia Tenggara
Select Weapon_Type, count(*) as total, sum(Killed) as killed, sum(Casualties) as casualties
	from GlobalTerrorism_2
	where Region = 'Southeast Asia'
	group by Weapon_Type order by total desc;


