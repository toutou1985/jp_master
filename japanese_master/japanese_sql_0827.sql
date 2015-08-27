/* game_status>>>0:未解锁 1:通关中 2:通关完成*/

/********所有关卡************/
/*各mission状态*/
select mission_no,game_status from mission;

/*各mission的word个数*/
select  allcnt.mission_id,allcnt,rightcnt
from 
(select mission_id,count(id) as allcnt from word group by mission_id) allcnt
left join 
(select mission_id,count(id)  as rightcnt from word where right_num>0 group by mission_id) rightcnt
on allcnt.mission_id=rightcnt.mission_id
;


/********某个大关卡(下例为1号大关卡)************/
/*mission的各level状态*/
select level_no,game_status from level where mission_id=1;

/*各level中的word个数*/
select allcnt.level_id,allcnt,rightcnt 
from 
(select level_id,count(id) as allcnt from word where mission_id=1 group by level_id) allcnt
left join 
(select level_id,count(id) as rightcnt from word where mission_id=1 and right_num>0 group by level_id) rightcnt 
on allcnt.level_id=rightcnt.level_id
;


/*某个小关卡(下例为1号大关卡的1号小关卡)*/
select id,kanji,kana,chinese_means,right_num from word where mission_id=1 and level_id=1;

/*某个小关卡第一个不正确的word。如果都正确，直接按上面sql的id顺序显示*/
select id,kanji,kana,chinese_means,right_num from word where mission_id=1 and level_id=1 and right_num=0 order by right_num,id limit 1;



/*更新当前关卡的各word的对错次数*/
update word set right_num=1,wrong_num=1 where id=1;

/*若当前小关卡的word都正确*/
select count(id) as allcnt from word where mission_id=1 and level_id=1;
select count(id) as rightcnt from word where mission_id=1 and level_id=1 and right_num>0;
/*更新当前小关卡的状态*/
update level set game_status=2 where mission_id=1 and level_no=1; 
/*更新下一个小关卡的状态*/
update level set game_status=1 where mission_id=1 and level_no=1+1; 


/*若当前大关卡的word都正确*/
select count(id) as allcnt from word where mission_id=1;
select count(id) as rightcnt from word where mission_id=1 and right_num>0;
/*更新当前大关卡的状态*/
update mission set game_status=2 where mission_id=1; 
/*更新下一个大关卡的状态*/
update mission set game_status=1 where mission_id=1+1; 




