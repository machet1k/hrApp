create table candidates(id int not null generated always as identity(start with 1, increment by 1),surname varchar(20) not null,name varchar(20) not null,patronymic varchar(20) not null,phonenumber varchar(10) not null,status varchar(20) not null,dates date not null,times time not null);

create table statuses(id int not null generated always as identity(start with 1, increment by 1),phonenumber varchar(10) not null,status varchar(20) not null,dates date not null,times time not null);
