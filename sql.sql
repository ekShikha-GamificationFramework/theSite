-- create database iitb;
-- use iitb;

create database gamification;
use gamification;

create table student (
	id varchar(30) primary key, 
	name varchar(256) not null,
	email varchar(256) not null,
	school_id int(10) unsigned,
	class int(3),
	dob date not null,
	password_hash varchar(256) not null,
	level varchar(20)
) auto_increment=0;

create table teacher (
	id varchar(30) primary key, 
	name varchar(256) not null,
	email varchar(256) not null,
	school_id int(10) unsigned,
	password_hash varchar(256) not null
) auto_increment=0;

create table school(
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null,
	city varchar(50) not null,
	state varchar(50) not null
) auto_increment=0;

create table activity (
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null,
	icon_link varchar(256),
	program_link varchar(256) not null,
	class int(3) not null,
	max_score int not null,
	creation_date date not null ,
	level varchar(20)
) auto_increment=0;

create table game(
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null,
	icon_link varchar(256),
	teacher_id int(10) not null,
	creation_date date
) auto_increment=0;

create table gameactivity(
	game_id int(10) unsigned not null,
	activity_id int(10) unsigned not null,
	pair_id int(10) auto_increment primary key,
	topic_id int(10) not null
) auto_increment=0;

create table topic(
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null
) auto_increment=0;

create table stats(
	student_id varchar(30) primary key,
	pair_id int(10) not null,
	score int not null default 0,
	last_played date not null
);

create table path (
	activity_id_1 varchar(50) not null,
	activity_id_2 varchar(50) not null,
	story_scene_id int(10) not null,
	score int(5),
	game_id int(10)
);

create table story_scene(
	id int(10) unsigned auto_increment primary key,
	name varchar(50) not null,
	link varchar(256)
) auto_increment=0;


-- >>>>>>>> CHANGES <<<<<<<-----
alter table stats
add column times_played int default 0;

alter table stats
add column category_id int ;

create table category(
	id int auto_increment primary key,
	name varchar(50) not null
) auto_increment=0;

create table gamecategory(
	game_id int,
	category_id int,
	max_score int 
);

alter table gameactivity
add column contri int default 0;

alter table gameactivity
add category_id int ;

-- create table contribution(
-- 	pair_id int not null,
-- 	percentcontri int(4) not null
-- );

create table loggedinusers(
	id varchar(50) primary key
);