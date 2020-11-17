use snet0611;

alter table like_post add index IX_Like_Post_UserID (user_id);
alter table like_post add index IX_Like_Post_PostID (post_id);

alter table like_photos add index IX_Like_Photos_UserID (user_id);