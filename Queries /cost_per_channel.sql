-- exploration by channel (distribution of time of resolution)
with base as (
SELECT
    created_at::date as creation_day
  , agent_id
  , 8 as agent_hour_per_day
  , count(case when channel = 'email' then touchpoint_id end) as email_touchpoints
  , count(case when channel = 'call' then touchpoint_id end) as call_touchpoints
  , count(case when channel = 'chat' then touchpoint_id end) as chat_touchpoints
  , 8 / nullif(call_touchpoints + chat_touchpoints + email_touchpoints,0) as h_per_channel
  , h_per_channel * email_touchpoints as h_per_email_touchpoint
  , h_per_channel*call_touchpoints as h_per_call_touchpoint
  , h_per_channel*chat_touchpoints as h_per_chat_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2
order by 1 , 3 desc
)

select date_trunc('month', creation_day) as month_of_creation
       ,500000 as cost_per_month
       ,sum(h_per_email_touchpoint) as monthly_h_email
       ,sum(h_per_call_touchpoint)  as monthly_h_call
       ,sum(h_per_chat_touchpoint)  as monthly_h_chat
       , 500000 * monthly_h_email / (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_email
       , 500000 * monthly_h_call /  (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_call
       , 500000 * monthly_h_chat /  (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_chat
from base
group by 1
order by 1;


-- yearly aggregated
with base as (
SELECT
    created_at::date as creation_day
  , agent_id
  , 8 as agent_hour_per_day
  , count(case when channel = 'email' then touchpoint_id end) as email_touchpoints
  , count(case when channel = 'call' then touchpoint_id end) as call_touchpoints
  , count(case when channel = 'chat' then touchpoint_id end) as chat_touchpoints
  , 8 / nullif(call_touchpoints + chat_touchpoints + email_touchpoints,0) as h_per_channel
  , h_per_channel * email_touchpoints as h_per_email_touchpoint
  , h_per_channel*call_touchpoints as h_per_call_touchpoint
  , h_per_channel*chat_touchpoints as h_per_chat_touchpoint
FROM
  "CORE_BUSINESS"."PUBLIC"."TOUCHPOINT_RESOLUTION_FACT"
group by 1,2
order by 1 , 3 desc
),

monthly_split as
(select date_trunc('month', creation_day) as month_of_creation
       ,500000 as cost_per_month
       ,sum(h_per_email_touchpoint) as monthly_h_email
       ,sum(h_per_call_touchpoint)  as monthly_h_call
       ,sum(h_per_chat_touchpoint)  as monthly_h_chat
       , 500000 * monthly_h_email / (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_email
       , 500000 * monthly_h_call /  (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_call
       , 500000 * monthly_h_chat /  (monthly_h_email + monthly_h_call + monthly_h_chat) as cost_per_chat
from base
group by 1
order by 1 desc)

select avg(cost_per_email)as avg_monthly_cost_per_email
       , avg(cost_per_call) as avg_monthly_cost_per_call
       , avg(cost_per_chat) as avg_monthly_cost_per_chat
from monthly_split;
