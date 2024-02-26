-- Mid Course Project

-- 1. monthly sessions for gsearch sessions and orders 

SELECT 
     MONTH(w.created_at) AS month_name,
     COUNT(DISTINCT w.website_session_id) AS sessions,
     COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions AS w
LEFT JOIN orders AS o
ON w.website_session_id=o.website_session_id
WHERE w.created_at<'2012-11-27'
AND w.utm_source='gsearch'
GROUP BY 1;

-- 2. breaking above query into brand and non-brand

SELECT 
     MONTH(w.created_at) AS month_name,
     COUNT(CASE WHEN w.utm_campaign='brand' THEN w.website_session_id ELSE NULL END) AS brand_sessions,
     COUNT(CASE WHEN w.utm_campaign='nonbrand' THEN w.website_session_id ELSE NULL END) AS nonbrand_sessions,
     COUNT(CASE WHEN w.utm_campaign='brand' THEN o.order_id ELSE NULL END) AS brand_orders,
     COUNT(CASE WHEN w.utm_campaign='nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders
FROM website_sessions AS w
LEFT JOIN orders AS o
ON w.website_session_id=o.website_session_id
WHERE w.created_at<'2012-11-27'
AND w.utm_source='gsearch'
GROUP BY 1;

-- 3. gsearch nonbrand sessions and orders by device type

SELECT 
     MONTH(w.created_at) AS month_name,
     COUNT(CASE WHEN w.device_type='mobile' THEN w.website_session_id ELSE NULL END) AS mob_sess,
     COUNT(CASE WHEN w.device_type='mobile' THEN o.order_id ELSE NULL END) AS mob_orders,
     COUNT(CASE WHEN w.device_type='desktop' THEN w.website_session_id ELSE NULL END) AS dtop_sess,
     COUNT(CASE WHEN w.device_type='desktop' THEN o.order_id ELSE NULL END) AS dtop_orders
FROM website_sessions AS w
LEFT JOIN orders AS o
ON w.website_session_id=o.website_session_id
WHERE w.created_at<'2012-11-27'
AND w.utm_source='gsearch'
AND w.utm_campaign='nonbrand'
GROUP BY 1;

-- 4. Mothly trend for all utm source

SELECT 
     MONTH(created_at) AS month_name,
     COUNT(CASE WHEN utm_source='gsearch' THEN website_session_id ELSE NULL END) AS g_sess,
     COUNT(CASE WHEN utm_source='bsearch' THEN website_session_id ELSE NULL END) AS b_sess,
	 COUNT(CASE WHEN utm_source='socialbook' THEN website_session_id ELSE NULL END) AS s_sess,
	 COUNT(CASE WHEN utm_source='' THEN website_session_id ELSE NULL END) AS random_sess
FROM website_sessions
WHERE created_at<'2012-11-27'
GROUP BY 1;

-- 5. session to order conv rate by month

SELECT 
     MONTH(w.created_at) AS month_name,
     COUNT(w.website_session_id) AS sessions,
     COUNT(o.order_id) AS orders,
	 (COUNT(o.order_id)/COUNT(w.website_session_id))*100 As conv_rate
FROM website_sessions AS w
LEFT JOIN orders AS o
ON w.website_session_id=o.website_session_id
WHERE w.created_at<'2012-11-27'
GROUP BY 1;

-- 6. estimate revenue through the lander test

CREATE TEMPORARY TABLE land 
SELECT   
      p.website_session_id,
      p.website_pageview_id,
      p.pageview_url
FROM website_pageviews AS p
LEFT JOIN website_sessions AS w
ON w.website_session_id=p.website_session_id
WHERE p.created_at BETWEEN '2012-06-19' AND '2012-07-28'
AND p.website_pageview_id>= 23504
AND p.pageview_url='/lander-1'
AND w.utm_source='gsearch'
AND w.utm_campaign='nonbrand';

SELECT 
      COUNT(l.website_session_id) AS sessions,
      COUNT(o.order_id) AS orders,
      (COUNT(o.order_id)/COUNT(l.website_session_id))*100 AS conv_rate,
      SUM(o.items_purchased*o.price_usd) AS revenue
FROM land AS l
LEFT JOIN orders AS o
ON l.website_session_id=o.website_session_id;

-- 7. full conversion funnel from each of the 2 pages to orders