SELECT
  *
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
LIMIT
  100;

  SELECT
  min(created_at)::date,
  max(created_at)::date
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT";


  select date_trunc('week',created_at)::date as week_of_touchpoint, country, count(distinct touchpoint_id) as touchpoints
  FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT" 
  group by 1,2
  order by 1, 3 desc

-- same user with multiple touchpoints for the same reason (~82% have just one touchpoint)
  With multiple_touchpoints as 
  (select detailed_reason
  , merchant_id
  , count(distinct touchpoint_id) as touchpoints
  FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT" 
  group by 1,2)

  select touchpoints, count(distinct merchant_id) as inquires, ratio_to_report(inquires) over () as inquires_share
  from multiple_touchpoints
  group by 1
  order by 1;

  -- status of the touchpoints

  select date_trunc('day',created_at)::date as week_of_touchpoint
  , status
  , count(touchpoint_id) as touchpoints
  FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT" 
  group by 1,2
  order by 1, 3 desc;


  select *
   FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"  
  WHERE merchant_id = '-5416209098259056533'
