-- 1. Total Number of deals in pipeline
SELECT COUNT(*) AS total_deals FROM deals;


-- 2. Pipeline Value by stage
select stage, sum(deal_value) AS pipeline_value
from deals
group by stage
order by pipeline_value desc;


-- 3. Number of Deals by stage.
select stage, count(*) as deal_count
from deals
group by stage
order by deal_count desc;


--4. Overall Win Rate
SELECT 
    COUNT(CASE WHEN stage = 'Closed Won' THEN 1 END) * 100.0 / COUNT(*) AS win_rate_percent
FROM deals;


-- 5. Revenue by region
select region, sum(deal_value) as revenue
from deals
where stage = 'Closed Won'
group by region
order by revenue desc;

-- 6. Revenue by Sales Rep
select s.rep_name, sum(d.deal_value) as revenue
from deals d join sales_rep s on d.rep_id = s.rep_id
where d.stage = 'Closed Won'
group by s.rep_name
order by revenue desc;


-- 7. Rank Sales Rep By Revenue
WITH rep_revenue AS (
    SELECT
        s.rep_name,
        COUNT(*) AS deals_closed,
        SUM(d.deal_value) AS revenue
    FROM deals d
    JOIN sales_rep s
        ON d.rep_id = s.rep_id
    WHERE d.stage = 'Closed Won'
    GROUP BY s.rep_name
)
SELECT
    rep_name,
    deals_closed,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM rep_revenue
ORDER BY revenue_rank;


-- 8. Lead Source Performance
SELECT 
    lead_source,
    COUNT(*) AS total_deals,
    SUM(CASE WHEN stage = 'Closed Won' THEN deal_value ELSE 0 END) AS revenue
FROM deals
GROUP BY lead_source
ORDER BY revenue DESC;


-- 9. Compare lead sources by win rate
SELECT
    lead_source,
    COUNT(*) AS total_deals,
    COUNT(CASE WHEN stage = 'Closed Won' THEN 1 END) AS won_deals,
    ROUND(
        COUNT(CASE WHEN stage = 'Closed Won' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS win_rate_percent
FROM deals
GROUP BY lead_source
ORDER BY win_rate_percent DESC;


-- 10. Stages with most average deal value
SELECT
    stage,
    COUNT(*) AS deal_count,
    ROUND(AVG(deal_value), 2) AS avg_deal_value,
    SUM(deal_value) AS total_pipeline_value
FROM deals
GROUP BY stage
ORDER BY avg_deal_value DESC;


-- 11. Average Time to Close Deals
select round(avg(closed_date - created_date),2) AS avg_days_to_close
from deals
where stage = 'Closed Won';
