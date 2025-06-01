/* Script file for BI I 2021-2022 Project
 * Creation of the Global Terrorism Data Staging Area for use in the ETL solution (with SSIS) - Group 19 */

USE [master]
GO

/* Remove the database, if it already exists, so it's safe to create it and load data in it */
DROP DATABASE IF EXISTS [GROUP19_STG];

/****** Object:  Database [GROUP19_STG] ******/
CREATE DATABASE [GROUP19_STG]
GO
/* The Database name is with upper cases and the tables and variables will have lower cases */

/* Which Database we are going to use */
USE [GROUP19_STG]
GO

/* 
 * We will use 5 data-types:
 *	 1. Text: NVARCHAR(n) 
 *	 2. Dates: DATE
 *	 3. Whole (natural) numbers: INT, BIGINT
 *	 4. Decimal numbers (incl. money): DECIMAL(20,2)
 *   5. Approximate number used to store a floating-point number: FLOAT 
 *   6. Numerical: NUMERIC(29,3)
 */

 /*
  * We will use the original Primary Key for each table, 
  * but we are going to call them a Business Key (BK).
  * The Slowly-Changing-Dimensions (SCD) will be developed in the Date Warehouse (DW),
  * since they are not necessary in the Staging Area (SA).
  */

/****** Object: Table stg_dim_date ******/
/* The Staging dimension table for the date */
CREATE TABLE stg_dim_date(
		bk_date BIGINT PRIMARY KEY, /* The type is BIGINT and not INT because the number is too big */
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

/****** Object: Table stg_dim_perpetrator ******/
/* The Staging dimension table for the perpetrators */
CREATE TABLE stg_dim_perpetrator(
		bk_perpetrator INT PRIMARY KEY,
		group_name NVARCHAR(300) NULL,
		group_subname NVARCHAR(700) NULL,
		number_perpetrators INT NULL,
		number_perpetrators_captured INT NULL,
		motive NVARCHAR(1050) NULL,
		claimed NVARCHAR(10) NULL,
		claim_mode INT NULL,
		claim_mode_txt NVARCHAR(50) NULL
		);

/****** Object: Table stg_dim_location ******/
/* The Staging dimension table for the location */
CREATE TABLE stg_dim_location(
		bk_location INT PRIMARY KEY,
		country INT NULL,
		country_txt NVARCHAR(50) NULL,
		region INT NULL,
		region_txt NVARCHAR(50) NULL,
		province_state NVARCHAR(50) NULL,
		city NVARCHAR(50) NULL,
		localization NVARCHAR(300) NULL
		);

/****** Object: Table stg_dim_weapon ******/
/* The Staging dimension table for the weapons */
CREATE TABLE stg_dim_weapon(
		bk_weapon INT PRIMARY KEY,
		weapon_type INT NULL,
		weapon_type_txt NVARCHAR(100),
		weapon_subtype INT NULL,
		weapon_subtype_txt NVARCHAR(50),
		weapon_detail NVARCHAR(1050),
		weapon_brand NVARCHAR(50)
		);

/****** Object: Table stg_dim_target ******/
/* The Staging dimension table for the targets */
CREATE TABLE stg_dim_target(
		bk_target INT PRIMARY KEY,
		target_type INT NULL,
		target_type_txt NVARCHAR(50) NULL,
		target_subtype INT NULL,
		target_subtype_txt NVARCHAR(150) NULL,
		entity NVARCHAR(300) NULL,
		specific_target NVARCHAR(1050) NULL,
		nationality INT NULL,
		nationality_txt NVARCHAR(50) NULL
		);

/****** Object: Table stg_dim_property_damage ******/
/* The Staging dimension table for the properties that were damaged */
CREATE TABLE stg_dim_property_damage(
		bk_property INT PRIMARY KEY,
		property_damage NVARCHAR(10) NULL,
		extent INT NULL,
		extent_txt NVARCHAR(50) NULL,
		value_damage DECIMAL(20,2) NULL
		);

/****** Object: Table stg_dim_hostages ******/
/* The Staging dimension table for the hostages */
CREATE TABLE stg_dim_hostages(
		bk_hostages INT PRIMARY KEY,
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

/****** Object: Table stg_dim_deaths ******/
/* The Staging dimension table for the people that died */
CREATE TABLE stg_dim_deaths(
		bk_deaths INT PRIMARY KEY,
		number_deaths INT NULL,
		number_deaths_us INT NULL,
		number_deaths_perpetrators INT NULL
		);

/****** Object: Table stg_dim_wounded ******/
/* The Staging dimension table for the people that were wounded */
CREATE TABLE stg_dim_wounded(
		bk_wounded INT PRIMARY KEY,
		number_wounded INT NULL,
		number_wounded_us INT NULL,
		number_wounded_perpetrators INT NULL
		);

/****** Object: Table stg_dim_international ******/
/* The Staging dimension table for the international facts */
CREATE TABLE stg_dim_international(
		bk_international INT PRIMARY KEY,
		international_logistical NVARCHAR(10) NULL,
		international_ideological NVARCHAR(10) NULL,
		international_miscellaneous NVARCHAR(10) NULL,
		international_any NVARCHAR(10) NULL
		);

/****** Object: Table stg_fact_attack ******/
/* The Staging facts table for the attacks */
/*
 * The Primary Key (PK) is the combination of the Foreign Keys (FK), 
 * but in the Staging Area, there are no relationships between the tables.
 */

CREATE TABLE stg_fact_attack(
		fk_date BIGINT,
		fk_perpetrator INT,
		fk_location INT,
		fk_weapon INT,
		fk_target INT,
		fk_property INT,
		fk_hostages INT,
		fk_deaths INT,
		fk_wounded INT,
		fk_international INT,
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


/* *****************************************************************************
 * The Log table for ETL errors.
 *
 * We create a table in the SA that will enable us
 * to save errors from each individual ETL run into
 * Staging Area, so we can investigate at later time.
 *
 * ****************************************************************************/
CREATE TABLE log_stg_errors (
    log_id INT identity(1, 1) PRIMARY KEY,
	etl_name NVARCHAR(50) NULL,
	error NVARCHAR(max) NULL,
	source NVARCHAR(100) NULL
	);


/* *****************************************************************************
 * The Log table for each ETL action.
 *
 * We create a table in the SA that will enable us
 * to save information from each individual ETL
 * run into Staging Area, for historical records.
 *
 * ****************************************************************************/
CREATE TABLE log_stg_etl (
	log_id INT identity(1, 1) PRIMARY KEY,
	etl_name NVARCHAR(50) NULL,
	etl_desc NVARCHAR(50) NULL
	);


USE [master]
GO