-- exploration by channel 
SELECT
  date_trunc('week',created_at)::date
  , channel
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
  , total_time_min / tot_touchpoint_id as avg_time_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2
order by 1 , 3 desc;

-- exploration by channel (distribution of time of resolution)
with base as (
SELECT
  date_trunc('week',created_at)::date
  , channel
  , touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2,3
)

select channel
, case when round(total_time_min) <= 10 then '1-10_minute'
       when round(total_time_min) <= 30 then '10-30_minute'
       when round(total_time_min) <= 60 then '30-60_minute'
       when round(total_time_min) <= 480 then'60-480_minute' 
       else '480+_minute' end as total_time_min_bucketed     
, count(touchpoint_id) as touchpoint
from base
group by 1,2
order by 2 desc;

-- exploration by channel / IT
SELECT
  date_trunc('week',created_at)::date
  , channel
  , country
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
  , total_time_min / tot_touchpoint_id as avg_time_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
where country = 'IT'
group by 1,2,3
order by 1 , 4 desc

-- exploration by channel / FR
SELECT
  date_trunc('week',created_at)::date
  , channel
  , country
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
  , total_time_min / tot_touchpoint_id as avg_time_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
where country = 'FR'
group by 1,2,3
order by 1 , 4 desc;

-- yearly summary per channel and country
SELECT
  date_trunc('year',created_at)::date
  , channel
  , country
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
  , total_time_min / tot_touchpoint_id as avg_time_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2,3
order by 1 , 3 , 6 desc;

-- drilldown on reason group
with base as (
SELECT
    reason_group
  , touchpoint_id
  , channel
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/86400 as total_days_to_resolution
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2,3
)

select reason_group
, channel
, count(touchpoint_id) as touchpoints
, ratio_to_report(touchpoints) over (partition by channel) as touchpoint_share
from base
group by 1,2
order by  touchpoints desc;
