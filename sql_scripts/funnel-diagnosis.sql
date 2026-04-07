SELECT created_at::DATE FROM website_sessions LIMIT 5
--===============--

WITH session_level AS (
    SELECT
        website_session_id,
        MAX(products_page) AS to_products,
        MAX(product_detail_page) AS to_details,
        MAX(cart_page) AS to_cart,
        MAX(shipping_page) AS to_shipping,
        MAX(billing_page) AS to_billing,
        MAX(thankyou_page) AS to_thankyou
    FROM (
        SELECT
			created_at,
            website_session_id,
            CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
            CASE WHEN pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') THEN 1 ELSE 0 END AS product_detail_page,
            CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
            CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
            CASE WHEN pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END AS billing_page,
            CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
        FROM website_pageviews
    ) AS pageview_flags 
    GROUP BY website_session_id
)
SELECT
    COUNT(DISTINCT website_session_id) AS total_sessions,
    SUM(to_products) AS reached_products,
    SUM(to_details) AS reached_details,
    SUM(to_cart) AS reached_cart,
    SUM(to_shipping) AS reached_shipping,
    SUM(to_billing) AS reached_billing,
    SUM(to_thankyou) AS reached_thankyou,
    CAST(SUM(to_products) AS FLOAT) / COUNT(DISTINCT website_session_id) AS lander_to_prod_rt,
    CAST(SUM(to_cart) AS FLOAT) / SUM(to_details) AS detail_to_cart_rt,
    CAST(SUM(to_thankyou) AS FLOAT) / SUM(to_cart) AS cart_to_success_rt
FROM session_level;

--=======================================--
-- Bottleneck 1: Home/landing to Product --
--=======================================--

WITH landing_page_behavior AS (
    SELECT 
        website_session_id,
        MAX(CASE WHEN pageview_url IN ('/home', '/lander-1', '/lander-2', '/lander-3', '/lander-4', '/lander-5') THEN 1 ELSE 0 END) AS saw_landing_page,
        MAX(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END) AS clicked_to_products
    FROM website_pageviews
    GROUP BY website_session_id
)
SELECT 
    EXTRACT(YEAR FROM s.created_at) AS year,
    EXTRACT(MONTH FROM s.created_at) AS month,
    COALESCE(s.utm_source, 'direct') AS source,
    COALESCE(s.utm_campaign, 'direct') AS campaign,
    s.device_type,
    COUNT(l.website_session_id) AS total_sessions,
    SUM(l.clicked_to_products) AS sessions_to_products,
    ROUND(SUM(l.clicked_to_products) * 100.0 / COUNT(l.website_session_id), 2) AS clickthrough_rate_pct,
    COUNT(l.website_session_id) - SUM(l.clicked_to_products) AS dropped_sessions
FROM landing_page_behavior l
JOIN website_sessions s ON l.website_session_id = s.website_session_id
WHERE l.saw_landing_page = 1 
GROUP BY 
    EXTRACT(YEAR FROM s.created_at),
    EXTRACT(MONTH FROM s.created_at),
    COALESCE(s.utm_source, 'direct'),
    COALESCE(s.utm_campaign, 'direct'),
    s.device_type
ORDER BY 
    source, campaign, device_type, year, month;

 
-- View with landing page

CREATE OR REPLACE VIEW master_home_ctr_with_dim AS
WITH landing_page_ident AS (
    SELECT 
        website_session_id,
        MIN(website_pageview_id) AS min_pageview_id
    FROM website_pageviews
    GROUP BY website_session_id
),
session_landing_page AS (
    SELECT 
        l.website_session_id,
        p.pageview_url AS landing_page
    FROM landing_page_ident l
    JOIN website_pageviews p ON l.min_pageview_id = p.website_pageview_id
),
session_behavior AS (
    SELECT 
        website_session_id,
        MAX(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END) AS clicked_to_products
    FROM website_pageviews
    GROUP BY website_session_id
)
SELECT 
    EXTRACT(YEAR FROM s.created_at) AS year,
    EXTRACT(MONTH FROM s.created_at) AS month,
    slp.landing_page,
    CASE WHEN s.is_repeat_session = 1 THEN 'Repeat Customer' ELSE 'New Customer' END AS customer_type,
    COALESCE(s.utm_source, 'direct') AS source,
    COALESCE(s.utm_campaign, 'direct') AS campaign,
    s.device_type,
    COUNT(s.website_session_id) AS total_sessions,
    SUM(sb.clicked_to_products) AS sessions_to_products,
    ROUND(SUM(sb.clicked_to_products) * 100.0 / COUNT(s.website_session_id), 2) AS clickthrough_rate_pct
FROM website_sessions s
JOIN session_landing_page slp ON s.website_session_id = slp.website_session_id
JOIN session_behavior sb ON s.website_session_id = sb.website_session_id
WHERE slp.landing_page IN ('/home', '/lander-1', '/lander-2', '/lander-3', '/lander-4', '/lander-5')
GROUP BY 
    EXTRACT(YEAR FROM s.created_at),
    EXTRACT(MONTH FROM s.created_at),
    slp.landing_page,
    CASE WHEN s.is_repeat_session = 1 THEN 'Repeat Customer' ELSE 'New Customer' END,
    COALESCE(s.utm_source, 'direct'),
    COALESCE(s.utm_campaign, 'direct'),
    s.device_type
ORDER BY 
    year, month, total_sessions DESC;

WITH avg_ctr_of_each_landing_by_time AS( 
	SELECT 
		year, month, landing_page, customer_type,
		SUM(sessions_to_products) AS total_session_to_products,
		AVG(clickthrough_rate_pct) AS avg_ctr
	FROM master_home_ctr_with_dim
	WHERE device_type = 'desktop'
	GROUP BY year, month, landing_page, customer_type
)
SELECT 
	year, month, landing_page, customer_type,
	total_session_to_products, avg_ctr, 
	SUM(total_session_to_products) OVER(PARTITION BY year, month) AS total_session_by_month,
	AVG(avg_ctr) OVER(PARTITION BY year, month) AS avg_ctr_by_month
FROM avg_ctr_of_each_landing_by_time;

--=============================================--
-- Bottleneck 2: Product Detail to Add-to-cart --
--=============================================--

CREATE OR REPLACE VIEW master_pdp_cart AS
WITH detail_page_ident AS (
    SELECT 
        website_session_id,
        website_pageview_id
    FROM website_pageviews
	WHERE pageview_url LIKE '%the%'
),
session_cart_page AS (
    SELECT 
        d.website_session_id,
        p.pageview_url AS landing_page
    FROM detail_page_ident d
    JOIN website_pageviews p ON d.website_pageview_id = p.website_pageview_id
),
session_behavior AS (
    SELECT 
        website_session_id,
        MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END) AS added_to_cart
    FROM website_pageviews
    GROUP BY website_session_id
)
SELECT 
    EXTRACT(YEAR FROM s.created_at) AS year,
    EXTRACT(MONTH FROM s.created_at) AS month,
    scp.landing_page,
    CASE WHEN s.is_repeat_session = 1 THEN 'Repeat Customer' ELSE 'New Customer' END AS customer_type,
    COALESCE(s.utm_source, 'direct') AS source,
    COALESCE(s.utm_campaign, 'direct') AS campaign,
    s.device_type,
    COUNT(s.website_session_id) AS total_sessions,
    SUM(sb.added_to_cart) AS sessions_to_products,
    ROUND(SUM(sb.added_to_cart) * 100.0 / COUNT(s.website_session_id), 2) AS clickthrough_rate_pct
FROM website_sessions s
JOIN session_cart_page scp ON s.website_session_id = scp.website_session_id
JOIN session_behavior sb ON s.website_session_id = sb.website_session_id
GROUP BY 
    EXTRACT(YEAR FROM s.created_at),
    EXTRACT(MONTH FROM s.created_at),
    scp.landing_page,
    CASE WHEN s.is_repeat_session = 1 THEN 'Repeat Customer' ELSE 'New Customer' END,
    COALESCE(s.utm_source, 'direct'),
    COALESCE(s.utm_campaign, 'direct'),
    s.device_type
ORDER BY 
    year, month, total_sessions DESC; 

SELECT *
FROM public.master_pdp_cart

-- Main Finding 2 --
WITH mr_fuzzy_views AS (
    SELECT 
        website_session_id,
        website_pageview_id AS fuzzy_pageview_id
    FROM website_pageviews
    WHERE pageview_url = '/the-original-mr-fuzzy'
),
next_pageviews AS (
    SELECT 
        m.website_session_id,
        MIN(p.website_pageview_id) AS next_pageview_id
    FROM mr_fuzzy_views m
    LEFT JOIN website_pageviews p 
        ON m.website_session_id = p.website_session_id 
        AND p.website_pageview_id > m.fuzzy_pageview_id
    GROUP BY m.website_session_id
)
SELECT
    CASE 
        WHEN n.next_pageview_id IS NULL THEN '1. Bounced / Exited completely'
        WHEN p.pageview_url = '/cart' THEN '2. Added to Cart (Converted)'
        WHEN p.pageview_url IN ('/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') THEN '3. Cross-sold to alternative products'
        ELSE '4. Went back to catalog/home'
    END AS next_action,
    COUNT(DISTINCT n.website_session_id) AS total_sessions,
    ROUND(COUNT(DISTINCT n.website_session_id) * 100.0 / SUM(COUNT(DISTINCT n.website_session_id)) OVER(), 2) AS pct_of_fuzzy_traffic
FROM next_pageviews n
LEFT JOIN website_pageviews p ON n.next_pageview_id = p.website_pageview_id
GROUP BY 
    1
ORDER BY 
    1;

--==================================================--
-- Bottleneck 3: Add-to-cart to Successful Purchase --
--==================================================--

WITH cart_sessions AS (
    SELECT DISTINCT website_session_id
    FROM website_pageviews
    WHERE pageview_url = '/cart'
),
funnel_steps AS (
    SELECT 
        c.website_session_id,
		device_type,
        MAX(CASE WHEN p.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS reached_shipping,
        MAX(CASE WHEN p.pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS reached_billing,
		MAX(CASE WHEN p.pageview_url LIKE('%thank%') THEN 1 ELSE 0 END) AS reached_thank_you
    FROM cart_sessions c
    LEFT JOIN website_pageviews p 
        ON c.website_session_id = p.website_session_id
	LEFT JOIN website_sessions ws
		ON ws.website_session_id = c.website_session_id 
    GROUP BY 1,2
)
SELECT 
	device_type,
    COUNT(website_session_id) AS total_cart_sessions,
    SUM(reached_shipping) AS total_shipping_sessions,
    ROUND(SUM(reached_shipping) * 100.0 / COUNT(website_session_id), 2) AS cart_to_shipping_cvr,
    SUM(reached_billing) AS total_billing_sessions,
    ROUND(SUM(reached_billing) * 100.0 / NULLIF(SUM(reached_shipping), 0), 2) AS shipping_to_billing_cvr,
	SUM(reached_thank_you) AS total_success_purchase,
	ROUND(SUM(reached_thank_you) * 100.0 / NULLIF(SUM(reached_billing), 0), 2) AS billing_to_purchased_cvr,
	100 - ROUND(SUM(reached_thank_you) * 100.0 / COUNT(website_session_id), 2) AS cart_abandonment_rate
FROM funnel_steps
GROUP BY 1;

-- Số lượng khách hàng rời đi khi từ add-to-cart -> shipping, chỉ có 12,426(19.67%) drop sau khi thấy phí ship 
-- -> giá ship hợp lý

-- Số lượng khách hàng rời đi khi từ shipping -> billing là 19,745 (~32.09%) --> Cần xem xét



--=================--
-- Billing A/B test--
--=================--

-- When billing page launching
WITH billing_page_launch AS(
	SELECT 
		pageview_url, 
		MIN(created_at) AS create_time, 
		MAX(created_at) AS end_time
	FROM website_pageviews
	WHERE pageview_url LIKE '%bill%'
	GROUP BY pageview_url
) 
SELECT 
	pageview_url, 
	EXTRACT(YEAR FROM create_time) AS year_created, 
	EXTRACT(MONTH FROM create_time) AS month_created,
	EXTRACT(YEAR FROM end_time) AS year_ended, 
	EXTRACT(MONTH FROM end_time) AS month_ended
FROM billing_page_launch

--"pageview_url"	"year_created"	"month_created"	"year_ended"	"month_ended"
--"/billing"		2012			3				2013			1
--"/billing-2"		2012			9				2015			3

-- Billing page conversion
WITH billing_sessions AS (
    SELECT 
        website_session_id,
		EXTRACT(YEAR FROM created_at) AS year,
		EXTRACT(MONTH FROM created_at) AS month,
        pageview_url AS billing_version
    FROM website_pageviews
    WHERE pageview_url IN ('/billing', '/billing-2')
),
purchase_sessions AS (
    SELECT DISTINCT website_session_id
    FROM website_pageviews
    WHERE pageview_url = '/thank-you-for-your-order'
)
SELECT 
	year, month,
    b.billing_version,
    COUNT(DISTINCT b.website_session_id) AS total_billing_sessions,
    COUNT(DISTINCT p.website_session_id) AS successful_purchases,
    ROUND(COUNT(DISTINCT p.website_session_id) * 100.0 / COUNT(DISTINCT b.website_session_id), 2) AS billing_to_success_cvr
FROM billing_sessions b
LEFT JOIN purchase_sessions p 
    ON b.website_session_id = p.website_session_id
LEFT JOIN website_sessions ws
	ON ws.website_session_id = b.website_session_id 
GROUP BY year, month, b.billing_version;

WITH billing_sessions AS (
    SELECT 
        website_session_id,
        pageview_url AS billing_version
    FROM website_pageviews
    WHERE pageview_url IN ('/billing', '/billing-2')
),
purchase_sessions AS (
    SELECT DISTINCT website_session_id
    FROM website_pageviews
    WHERE pageview_url = '/thank-you-for-your-order'
)
SELECT 
    device_type,
	b.billing_version,
    COUNT(DISTINCT b.website_session_id) AS total_billing_sessions,
    COUNT(DISTINCT p.website_session_id) AS successful_purchases,
    ROUND(COUNT(DISTINCT p.website_session_id) * 100.0 / COUNT(DISTINCT b.website_session_id), 2) AS billing_to_success_cvr
FROM billing_sessions b
LEFT JOIN purchase_sessions p 
    ON b.website_session_id = p.website_session_id
LEFT JOIN website_sessions ws
	ON ws.website_session_id = b.website_session_id 
GROUP BY 1,2;
