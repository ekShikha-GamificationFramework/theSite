create database ekshiksha_gamification;
use ekshiksha_gamification;

create table student (
	id int(10) unsigned auto_increment primary key, 
	name varchar(256) not null,
	email varchar(256) not null,
	school_id int(10) unsigned,
	class int(3),
	dob date not null,
	password_hash varchar(256) not null
) auto_increment=0;

create table teacher (
	id int(10) unsigned auto_increment primary key, 
	name varchar(256) not null,
	email varchar(256) not null,
	school_id int(10) unsigned,
	password_hash varchar(256) not null
) auto_increment=0;

create table school(
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null,
	city varchar(256) not null,
	state varchar(256) not null
) auto_increment=0;

create table activity (
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null,
	icon_link varchar(256),
	program_link varchar(256) not null,
	class int(3) not null,
	max_score int not null,
	topic_id int(10) not null,
	creation_date date not null 
) auto_increment=0;

create table game(
	id int(10) unsigned auto_increment primary key,
	icon_link varchar(256),
	teacher_id int(10) not null,
	creation_date date
);

create table gameActivity(
	game_id int(10) unsigned not null,
	activity_id int(10) unsigned not null,
	pair_id int(10) unsigned auto_increment primary key
) auto_increment=0;

create table topic(
	id int(10) unsigned auto_increment primary key,
	name varchar(256) not null
) auto_increment=0;

create table stats(
	student_id int(10) not null,
	pair_id int(10) not null,
	score int not null default 0,
	last_played date not null
);

create table path (
	activity_id_1 int(10) not null,
	activity_id_2 int(10) not null,
	story_scene_id int(10) not null
);

create table story_scene(
	id int(10) unsigned auto_increment primary key,
	image_link varchar(256) not null,
	text varchar(256) not null
) auto_increment=0;