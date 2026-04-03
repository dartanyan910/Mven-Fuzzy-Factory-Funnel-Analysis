WITH session_level_made_it_flags AS (
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
    -- Tỷ lệ chuyển đổi giữa các bước (Click-through rate)
    CAST(SUM(to_products) AS FLOAT) / COUNT(DISTINCT website_session_id) AS lander_to_prod_rt,
    CAST(SUM(to_cart) AS FLOAT) / SUM(to_details) AS detail_to_cart_rt,
    CAST(SUM(to_thankyou) AS FLOAT) / SUM(to_cart) AS cart_to_success_rt
FROM session_level_made_it_flags;

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
        MAX(CASE WHEN p.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS reached_shipping,
        MAX(CASE WHEN p.pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS reached_billing,
		MAX(CASE WHEN p.pageview_url LIKE('%thank%') THEN 1 ELSE 0 END) AS reached_thank_you
    FROM cart_sessions c
    LEFT JOIN website_pageviews p 
        ON c.website_session_id = p.website_session_id
    GROUP BY c.website_session_id
)
SELECT 
    COUNT(website_session_id) AS total_cart_sessions,
    SUM(reached_shipping) AS total_shipping_sessions,
    ROUND(SUM(reached_shipping) * 100.0 / COUNT(website_session_id), 2) AS cart_to_shipping_cvr,
    SUM(reached_billing) AS total_billing_sessions,
    ROUND(SUM(reached_billing) * 100.0 / NULLIF(SUM(reached_shipping), 0), 2) AS shipping_to_billing_cvr,
	SUM(reached_thank_you) AS total_success_purchase,
	ROUND(SUM(reached_thank_you) * 100.0 / NULLIF(SUM(reached_billing), 0), 2) AS billing_to_purchased_cvr,
	100 - ROUND(SUM(reached_thank_you) * 100.0 / COUNT(website_session_id), 2) AS cart_abandonment_rate
FROM funnel_steps;
-- Số lượng khách hàng rời đi khi từ add-to-cart -> shipping, chỉ có 12,426(19.67%) drop sau khi thấy phí ship 
-- -> giá ship hợp lý

-- Số lượng khách hàng rời đi khi từ shipping -> billing là 19,745 (~32.09%) --> Cần xem xét
-- 



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
    b.billing_version,
    COUNT(DISTINCT b.website_session_id) AS total_billing_sessions,
    COUNT(DISTINCT p.website_session_id) AS successful_purchases,
    ROUND(COUNT(DISTINCT p.website_session_id) * 100.0 / COUNT(DISTINCT b.website_session_id), 2) AS billing_to_success_cvr
FROM billing_sessions b
LEFT JOIN purchase_sessions p 
    ON b.website_session_id = p.website_session_id
GROUP BY b.billing_version;
