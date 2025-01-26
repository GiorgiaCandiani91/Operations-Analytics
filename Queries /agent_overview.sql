-- exploration by Agent and channel of competence
with base as (
SELECT
    created_at::date as creation_day
  , agent_id
  , 8 as agent_hour_per_day
  , count(case when channel = 'email' then touchpoint_id end) as email_touchpoints
  , count(case when channel = 'call' then touchpoint_id end) as call_touchpoints
  , count(case when channel = 'chat' then touchpoint_id end) as chat_touchpoints
  , sum(case when channel = 'email' then coalesce(total_handling_time_seconds,response_time_seconds) end)/60 as email_total_time_min
  , sum(case when channel = 'call' then coalesce(total_handling_time_seconds,response_time_seconds) end)/60 as call_total_time_min
  , sum(case when channel = 'chat' then coalesce(total_handling_time_seconds,response_time_seconds) end)/60 as chat_total_time_min
  , email_total_time_min / email_touchpoints as avg_min_per_email_touchpoint
  , call_total_time_min / call_touchpoints as avg_min_per_call_touchpoint
  , chat_total_time_min / chat_touchpoints as avg_min_per_chat_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2
order by 1 , 3 desc
)

select creation_day
, count(distinct case when email_touchpoints > 0 and call_touchpoints > 0 and chat_touchpoints > 0 then agent_id end) as all_channel_agents
, count(distinct case when email_touchpoints > 0 and call_touchpoints = 0 and chat_touchpoints = 0 then agent_id end) as only_email_channel_agents
, count(distinct case when email_touchpoints = 0 and call_touchpoints > 0 and chat_touchpoints = 0 then agent_id end) as only_call_agents
, count(distinct case when email_touchpoints = 0 and call_touchpoints = 0 and chat_touchpoints > 0 then agent_id end) as only_chat_agents
, count(distinct case when email_touchpoints = 0 and call_touchpoints > 0 and chat_touchpoints > 0 then agent_id end) as chat_and_call_agents
, count(distinct case when email_touchpoints > 0 and (call_touchpoints > 0 or chat_touchpoints > 0) then agent_id end) as email_and_other_channel_agents
from base
group by 1
order by 1 desc;

SELECT
  date_trunc('year',created_at)::date
  , agent_company
  , channel
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(coalesce(total_handling_time_seconds,response_time_seconds))/60 as total_time_min
  , total_time_min / tot_touchpoint_id as avg_time_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2,3
order by 1 , 3 , 6 desc;

-- Agent Company: touchpoints resolved by channel and avg time of resolution
SELECT
  date_trunc('year',created_at)::date
  , agent_company
  , channel
  , count(touchpoint_id) as tot_touchpoint_id
  , sum(queue_waiting_time_seconds)/60 as waiting_time_min
  , waiting_time_min / tot_touchpoint_id as avg_waiting_time_min_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
where channel in ('call','chat')
group by 1,2,3
order by 1 , 3 , 6 desc;
