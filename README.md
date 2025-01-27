# Operations-Analytics

## Main Delivarables

1. Task - Candiani SumUp
2. Strategy Paper - Candiani SumUp
3. Insights folder

**Task - Candiani SumUp** 

Contains the answers to the first set of questions structured in the following way:
1.Executive Summary
2.Behind the Summary
3.Supporting Charts

In this paper I provide the results of my analysis and some recommendations based on those.

**Strategy Paper - Candiani SumUp**

Contains the questions, recommendations and management framework to be discussed with the VP of Operations.
It is structured in the following way:
1. Strategy for Support Teams 
2. 2024 Channel Strategy (based on Cost)
3. Quarterly Performance Management Framework

**Insights folder**

Contains the SQL files that I use to generate insights and a mockup dashboard screenshot.
1. Resolution_overview.sql and email_overview_resolution.sql to suggest a new resolution timeframe
2. channel_overview.sql to explore which channel performed the best / worst
3. agent_overview.sql to explore which agent performed the best 
4. cost_overview.sql to allocate costs to the channels
5. waiting_time.sql to explore waiting time for Calls and Chats
6. random_exploration.sql to explore the Dataset

## Main Assumptions

Here are some assumptions / decisions that I took while resolving the task

1. 'Resolution' is given by both 'Resolved' and 'Serviced' status, assuming that 'Serviced' implies that everything was done on the Support side
2. The time of Resolution is given by the combination of 'Total Handling Time Seconds' for Chats and Calls and 'Response Time Seconds' for Email
3. I assumed that the 'Total Handling Time Seconds' for Chats and Calls is already inclusive of the waiting time to compute the time to resolution
4. I decided to leave the Touchpoints with null Time to Resolution in for the count of touchpoints received
5. I treated each touchpoint as a new request for semplicity, each request has its own time of resolution. 82% of the touchpoints have just one entry for the same detailed reason.

## Choices in Production

1. Leave the Date Timestamps for when the touchpoint is assigned to a status and when the Agent starts working on it
2. Create an aggregated version in DBT for reporting on a daily level with the main KPIs already computed
3. Implement a DBT test to spot missing values for fields that shouldn't be empty (i.e. resolution time)
4. Display the trend of main KPIs in a dashboard shared with the main Stakeholders
5. Use Dashboard filters to select a specific channel / country and other key relevant dimensions

