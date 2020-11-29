use snet0611;

/*
1. Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем */
set @UserID = 25;
set @Status = 'approved';

select
  F.friend_id,
  concat(U.firstname, ' ', U.lastname) as FIO,
  count(M.id) as Total_Mess
from
(
	select initiator_user_id as friend_id from friend_requests where target_user_id = @UserID and status = @Status
	union
	select target_user_id as friend_id from friend_requests where initiator_user_id = @UserID and status = @Status
) F
inner join messages M on M.from_user_id = F.friend_id and M.to_user_id = @UserID
inner join users U on U.id = F.friend_id
where exists (select * from messages m2 where m2.from_user_id = @UserID and m2.to_user_id = F.friend_id ) /*ответные сообщения*/
group by F.friend_id, U.firstname, U.lastname
order by count(M.id)
limit 1;

/*2.Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей*/
select 
  ifnull(count(lp.post_id), 0) + ifnull(count(ph.photo_id), 0) as count_all_like
from users u
left join like_post lp on lp.user_id = u.id
left join like_photos ph on ph.user_id = u.id
where timestampdiff(year, u.birthday, now()) = (select min(timestampdiff(year, birthday, now())) from users);

/*3.Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
select 
  if(u.gender = 'm', 'Мужчины', 'Женщины') as gender,
  ifnull(count(lp.post_id), 0) + ifnull(count(ph.photo_id), 0) as count_like
from users u
left join like_post lp on lp.user_id = u.id
left join like_photos ph on ph.user_id = u.id
group by u.gender
order by count_like desc
limit 1;


/*Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
 * Критерий антиАктивности: наименьшее кол-во постов и малое кол-во лайков на фото
 * */
select 
  concat(U.firstname, ' ', U.lastname) as FIO
from
(
	select 
	  U.id as user_id,
	  count(P.id) as count_post
	from users U
	inner join posts P on P.user_id = U.id
	group by U.id 
	order by count(P.id)
) c_p	
left join 
(
	select 
	  U.id as user_id,
	  count(ph.photo_id) as count_like_photo
	from users U
	inner join like_photos ph on ph.user_id = u.id
	group by U.id 
	order by count(ph.photo_id)
) c_ph on c_p.user_id = c_ph.user_id and c_p.count_post <= c_ph.count_like_photo
inner join users U on U.id = c_p.user_id
where c_ph.user_id is not null 
order by c_p.count_post, c_ph.count_like_photo
limit 10;


