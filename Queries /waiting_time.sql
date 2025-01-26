SELECT
  date_trunc('year',created_at)::date
  , channel
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as resolution_time
  , resolution_time / tot_touchpoint_id as avg_resolution_time
  , sum(queue_waiting_time_seconds) as waiting_time_sec
  , waiting_time_sec / tot_touchpoint_id as avg_waiting_time_sec_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
where channel in ('call','chat')
group by 1,2
order by 1 , 5 desc;
