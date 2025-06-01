/* Script file for BI I 2021-2022 Project
 * Creation of the Global Terrorism Data Warehouse - Group 19 */

USE [master]
GO

/* Remove the database, if it already exists, so it's safe to create it and load data in it */
DROP DATABASE IF EXISTS [GROUP19_DW]

/****** Object:  Database [GROUP19_DW] ******/
CREATE DATABASE [GROUP19_DW]
GO
/* The Data Warehouse name is with upper cases and the tables and variables will have lower cases */

/* Which Date Warehouse we are going to use */
USE [GROUP19_DW]
GO

/* 
 * We will use 5 data-types:
 *	 1. Text: NVARCHAR(n) 
 *	 2. Dates: DATE
 *	 3. Whole (natural) numbers: INT, BIGINT
 *	 4. Decimal numbers (incl. money): DECIMAL(n,p)
 *   5. Approximate number used to store a floating-point number: FLOAT 
 *   6. Numerical: NUMERIC(29,3)
 */

 /*
  * We are going to keep the Business Keys (BK), for each table,
  * that will be used in the Staging Area (SA), and we will create
  * Surrogate Keys (SK) (IDENTITY(1,1)), for each table, that are typical of Date Warehouse (DW) designs.
  * This way we will be able to use Slowly-Changing-Dimensions (SCD) in the Data Warehouse (DW) ETL.
  */

/****** Object: Table dim_date ******/
/* The dimension table for the date */
CREATE TABLE dim_date(
		sk_date INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_date BIGINT NOT NULL, /* The type is BIGINT and not INT because the number is too big */
		month INT NULL,
		day INT NULL,
		year INT NULL,
		proper_date DATE NULL,
		weekday_name NVARCHAR(50) NULL,
		day_name_short NVARCHAR(50) NULL,
		weekday_type NVARCHAR(10) NULL,
		weekday_number INT NULL,
		month_name NVARCHAR(50) NULL,
		month_name_short NVARCHAR(50) NULL,
		quarter_number INT NULL,
		quarter_name_short NVARCHAR(10) NULL,
		quarter_name NVARCHAR(50) NULL,
		semester_number INT NULL,
		semester_name_short NVARCHAR(10) NULL,
		semester_name NVARCHAR(50) NULL
		);

/****** Object: Table dim_perpetrator ******/
/* The dimension table for the perpetrators */
CREATE TABLE dim_perpetrator(
		sk_perpetrator INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_perpetrator INT NOT NULL,
		group_name NVARCHAR(300) NULL,
		group_subname NVARCHAR(700) NULL,
		number_perpetrators INT NULL,
		number_perpetrators_captured INT NULL,
		motive NVARCHAR(1050) NULL,
		claimed NVARCHAR(10) NULL,
		claim_mode INT NULL,
		claim_mode_txt NVARCHAR(50) NULL,
		perpetrator_scd_start_date DATETIME NULL, /* Slowly-Changing-Dimensions - More terrorists involved in the attack may be discovered or captured in the future */
		perpetrator_scd_end_date DATETIME NULL
		);

/****** Object: Table dim_location ******/
/* The dimension table for the location */
CREATE TABLE dim_location(
		sk_location INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_location INT NOT NULL,
		country INT NULL,
		country_txt NVARCHAR(50) NULL,
		region INT NULL,
		region_txt NVARCHAR(50) NULL,
		province_state NVARCHAR(50) NULL,
		city NVARCHAR(50) NULL,
		localization NVARCHAR(300) NULL
		);

/****** Object: Table dim_weapon ******/
/* The dimension table for the weapons */
CREATE TABLE dim_weapon(
		sk_weapon INT IDENTITY(1,1) PRIMARY KEY,
		bk_weapon INT NOT NULL,
		weapon_type INT NULL,
		weapon_type_txt NVARCHAR(100),
		weapon_subtype INT NULL,
		weapon_subtype_txt NVARCHAR(50),
		weapon_detail NVARCHAR(1050),
		weapon_brand NVARCHAR(50)
		);

/****** Object: Table dim_target ******/
/* The dimension table for the targets */
CREATE TABLE dim_target(
		sk_target INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_target INT NOT NULL,
		target_type INT NULL,
		target_type_txt NVARCHAR(50) NULL,
		target_subtype INT NULL,
		target_subtype_txt NVARCHAR(150) NULL,
		entity NVARCHAR(300) NULL,
		specific_target NVARCHAR(1050) NULL,
		nationality INT NULL,
		nationality_txt NVARCHAR(50) NULL
		);

/****** Object: Table dim_property_damage ******/
/* The dimension table for the properties that were damaged */
CREATE TABLE dim_property_damage(
		sk_property INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_property INT NOT NULL,
		property_damage NVARCHAR(10) NULL,
		extent INT NULL,
		extent_txt NVARCHAR(50) NULL,
		value_damage DECIMAL(20,2) NULL
		);

/****** Object: Table dim_hostages ******/
/* The dimension table for the hostages */
CREATE TABLE dim_hostages(
		sk_hostages INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_hostages INT NOT NULL,
		existance_hostages NVARCHAR(10) NULL,
		number_hostages INT NULL,
		number_hostages_us INT NULL,
		country_diverted NVARCHAR(50) NULL,
		country_resolution NVARCHAR(50) NULL,
		hostages_outcome INT NULL,
		hostages_outcome_txt NVARCHAR(300) NULL,
		number_released INT NULL,
		ransom_request NVARCHAR(10) NULL,
		amount DECIMAL(20,2),
		amount_us DECIMAL(20,2),
		paid DECIMAL(20,2),
		paid_us DECIMAL(20,2)
		);

/****** Object: Table dim_deaths ******/
/* The dimension table for the people that died */
CREATE TABLE dim_deaths(
		sk_deaths INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_deaths INT NOT NULL,
		number_deaths INT NULL,
		number_deaths_us INT NULL,
		number_deaths_perpetrators INT NULL,
		deaths_scd_start_date DATETIME NULL, /* Slowly-Changing-Dimensions - With time, more deaths can be discovered */
		deaths_scd_end_date DATETIME NULL
		);

/****** Object: Table dim_wounded ******/
/* The dimension table for the people that were wounded */
CREATE TABLE dim_wounded(
		sk_wounded INT IDENTITY(1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_wounded INT NOT NULL,
		number_wounded INT NULL,
		number_wounded_us INT NULL,
		number_wounded_perpetrators INT NULL,
		wounded_scd_start_date DATETIME NULL, /* Slowly-Changing-Dimensions - With time, more wounded people can be discovered */
		wounded_scd_end_date DATETIME NULL
		);

/****** Object: Table dim_international ******/
/* The dimension table for the international facts */
CREATE TABLE dim_international(
		sk_international INT IDENTITY (1,1) PRIMARY KEY, /* Identity generates the ID key, starts with 1 and increases 1 (1,1) */
		bk_international INT NOT NULL,
		international_logistical NVARCHAR(10) NULL,
		international_ideological NVARCHAR(10) NULL,
		international_miscellaneous NVARCHAR(10) NULL,
		international_any NVARCHAR(10) NULL
		);

/****** Object: Table fact_attack ******/
/* The facts table for the attacks */
/*
 * The Primary Key (PK) is the combination of the Foreign Keys (FK) 
 * (Surrogate Key (SK) of each dimension),
 * and we reference the Foreign Keys (FK) back to the parent table.
 */

CREATE TABLE fact_attack(
		fk_date INT FOREIGN KEY REFERENCES dim_date(sk_date),
		fk_perpetrator INT FOREIGN KEY REFERENCES dim_perpetrator(sk_perpetrator),
		fk_location INT FOREIGN KEY REFERENCES dim_location(sk_location),
		fk_weapon INT FOREIGN KEY REFERENCES dim_weapon(sk_weapon),
		fk_target INT FOREIGN KEY REFERENCES dim_target(sk_target),
		fk_property INT FOREIGN KEY REFERENCES dim_property_damage(sk_property),
		fk_hostages INT FOREIGN KEY REFERENCES dim_hostages(sk_hostages),
		fk_deaths INT FOREIGN KEY REFERENCES dim_deaths(sk_deaths),
		fk_wounded INT FOREIGN KEY REFERENCES dim_wounded(sk_wounded),
		fk_international INT FOREIGN KEY REFERENCES dim_international(sk_international),
		criteria_1 INT NULL,
		criteria_2 INT NULL,
		criteria_3 INT NULL,
		attack_type INT NULL,
		attack_type_txt NVARCHAR(50) NULL,
		success INT NULL,
		suicide INT NULL,
		percentage_perpetrators_captured NUMERIC(29,3) NULL,
		percentage_hostages_free NUMERIC(29,3) NULL
		CONSTRAINT pk_fact_attack PRIMARY KEY (
				fk_date ASC,
				fk_perpetrator ASC,
				fk_location ASC,
				fk_weapon ASC,
				fk_target ASC,
				fk_property ASC,
				fk_hostages ASC,
				fk_deaths ASC,
				fk_wounded ASC,
				fk_international ASC
				)
		);

USE [master]
GO