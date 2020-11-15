use snet0611;

drop table if exists like_post;
create table like_post(
	user_id bigint unsigned not null,
	post_id bigint unsigned not null,
    like_date_set datetime default now(),
    primary key (user_id, post_id),
	foreign key (user_id) references users(id),
	foreign key (post_id) references posts(id)
);

drop table if exists like_photos;
create table like_photos(
	user_id bigint unsigned not null,
	photo_id bigint unsigned not null,
    like_date_set datetime default now(),
    primary key (user_id, photo_id),
	foreign key (user_id) references users(id),
	foreign key (photo_id) references photos(id)
);