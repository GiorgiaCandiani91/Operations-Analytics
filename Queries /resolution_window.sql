with base as (
SELECT
    touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/86400 as total_days_to_resolution
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1
)

select case when round(total_days_to_resolution) = 0 then 1 
       when round(total_days_to_resolution) >= 7 then 7
       else round(total_days_to_resolution) end as total_days_to_resolution   
, count(touchpoint_id) as touchpoint
, ratio_to_report(touchpoint) over () as touchpoint_share
from base
-- where total_days_to_resolution is not null
group by 1
order by 1
