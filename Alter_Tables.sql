use snet0611;

alter table friend_requests alter status set default('requested');

alter table users change column create_at created_at datetime default now();