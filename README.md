# Fuzzy-Store-Funnel-and-Product-Launching-analysis
An end-to-end data analysis project focused on optimizing the conversion funnel and evaluating product launch performance for "Fuzzy Store." This repository contains tools to identify customer drop-off points and measure the success of marketing campaigns through data-driven insights.
# Project Background
Fuzzy Factory is a direct-to-consumer e-commerce company specializing in premium stuffed animals and gift-oriented bear products. The company has been operational since early 2012 and operates entirely through its online storefront, making website performance and conversion optimization central to its revenue model.

As the in-house Data Analyst, the primary mandate is to support marketing, product, and executive leadership in making data-backed decisions across four strategic areas: understanding growth trends, diagnosing funnel inefficiencies, evaluating product launches, and optimizing marketing channel spend.

Key business metrics tracked:

- Conversion Rate (CVR) — sessions to completed purchase
- Revenue by product and landing page
- Bounce rate by landing page variant
- Cart abandonment rate
- Cross-sell attach rate

Insights and recommendations are provided on the following stakeholder questions:

- **Question 2:** Why does high traffic volume not translate into proportional order volume — where are customers dropping off?
- **Question 4:** Which marketing channels deliver the highest-quality traffic, and where should we reallocate spend?

The Python codes used to inspect and clean the data for this analysis can be found here [link].

Targeted SQL queries regarding various business questions can be found here [link].

An interactive Tableau dashboard used to report and explore sales trends can be found here [link].
# Data Structure & Initial Checks
The companies main database structure as seen below consists of four tables: table1, table2, table3, table4, with a total row count of X records. A description of each table is as follows:

`orders`: Stores high-level information and summary data for all placed orders.

`order_items`: Contains granular details for each specific product within an order (e.g., quantity, price per unit).

`order_item_refunds`: Tracks customer refund transactions and associated return data.

`products`: A comprehensive catalog of all products available on the platform.

`website_sessions`: Records user visit data, including traffic source and entry touchpoints.

`session_pageviews`: Logs specific pages viewed by users during each individual session.

<img width="1288" height="510" alt="image" src="https://github.com/user-attachments/assets/e1336a4d-0858-4b64-8c05-51faae49be52" />

Figure 1: Entities Relationship Diagram


# Executive Summary
Fuzzy Factory recorded over 400,000 website sessions across the analysis period, yet only 32,313 resulted in completed transactions — an overall conversion rate of 6.8%. This report investigates the root causes of the 93.2% drop-off, identifies the primary bottleneck in the conversion funnel, and documents the A/B testing journey that progressively improved landing page performance. The findings support a focused optimization effort on the Detail View → Add-to-cart stage, while confirming that the Home/Landing page bottleneck has been largely resolved through iterative experimentation.

[Visualization, including a graph of overall trends or snapshot of a dashboard]
# Insights Deep Dive
## Question 1: Why does high traffic volume not translate into proportional order volume — where are customers dropping off?

<img width="1011" height="333" alt="Ảnh chụp màn hình 2026-03-29 230840" src="https://github.com/user-attachments/assets/15abc764-181f-422b-a3b2-fff8486d9917" />

**Figure 2: Conversion Rate and Drop-off by Stages**

Between March 2012 and March 2015, the Fuzzy Factory e-commerce platform recorded a total of 472,871 sessions. Out of these, only 32,313 sessions successfully converted into orders, resulting in an overall Conversion Rate (CVR) of 6.8%. Analysis of the conversion funnel reveals three critical bottlenecks:

Point 1: Home -> Product: More than 200,000 sessions exit the site immediately after landing, without viewing any specific product. This suggests a significant gap in initial engagement or landing page relevance.

Point 2: Product Detail View -> Add-to-cart: This stage represents the largest point of friction in the funnel. Approximately 183,306 sessions—nearly 72% of users who viewed a product—dropped off before adding an item to their cart. This indicates potential issues with product pricing, lack of trust, or poor UI/UX on the product detail pages.

Point 3: Add-to-cart -> Success Purchase: Even after expressing clear intent by adding items to the cart, the conversion to a successful purchase is only about 46%. We are losing over 37,000 potential orders during the checkout phase, which often points to friction in the shipping/billing steps or technical errors during payment.

**Bottleneck 2 — Detail View → Add-to-Cart (~55% drop-off):**

Initially flagged as a UI/UX concern, average time-on-page data (~186 seconds) indicates users do engage with the home page before leaving. The high drop-off in early 2012 (>60% bounce rate) triggered the A/B testing program documented below. This bottleneck has since been largely resolved through iterative landing page experimentation — no further optimization effort is recommended here.

**Bottleneck 2 — Detail View → Add-to-Cart (~55% drop-off):**

This is the most significant active bottleneck. Average time on the product detail page is approximately 2 minutes — indicating user engagement rather than UI friction. The high exit rate therefore points to product-side barriers: insufficient product description quality, non-compelling imagery, or a pricing mismatch relative to willingness-to-pay. This is the highest-priority optimization target.

<img width="1186" height="690" alt="1a110e4e-6547-49cf-adc4-aa826a199ffe" src="https://github.com/user-attachments/assets/a5708691-a296-4635-bdbb-b6c9f30a2d1a" />

**Figure 3:** Product Detail to Cart Conversion Rate by Product

**Bottleneck 3 — Billing Drop-off (37.9%):**

Elevated, but within the accepted e-commerce benchmark range of ~60–80% ([source](https://baymard.com/lists/cart-abandonment-rate)). Average time at this stage (~3.25 minutes) suggests checkout form complexity as a contributing factor. Given benchmark alignment, this is a lower priority relative to Bottleneck 2.



Figure 3: Avg Time check-out

## Category 3: Sản phẩm mới ra mắt có hiệu quả hay không
Main insight 1. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 2. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 3. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 4. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
[Visualization specific to category 3]
Category 4:
Main insight 1. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 2. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 3. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 4. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
[Visualization specific to category 4]
# Recommendations:
Based on the insights and findings above, we would recommend the [stakeholder team] to consider the following:
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
# Assumptions and Caveats:

Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

**1. Partial months excluded from YoY trend analysis:**
The dataset begins on March 19, 2012 and ends on March 19, 2015. Both March periods contain only 13–19 days of data. Including these months in YoY comparisons would overstate 2013 growth by approximately 2x due to unequal day counts in the baseline. All trend analysis uses April 2012 as the start point for YoY calculations. For March 2015 performance, a Month-to-Date (MTD) comparison using the same 19-day window from 2014 is used instead of full-month extrapolation.

**2. Null UTM campaign handling:**

For records in website_sessions where utm_campaign is missing (null), traffic is categorized using the following logic:

- ***Direct Traffic:*** Sessions where both utm_source and http_referer are null — users accessing via direct URL or bookmarks.
- ***Organic Search:*** Sessions where utm_source is null but http_referer contains search engine strings — unpaid search discovery.

**3. Bounce rate benchmarks sourced from Shopify industry data:**

The e-commerce bounce rate benchmark range of 36–45% referenced in Category 2 is based on published Shopify industry averages for retail and gifting categories. This benchmark should be periodically refreshed as market conditions evolve.

**4. March 2015 YoY decline is a data artifact, not a business signal:**

The apparent -3.7% YoY session decline in March 2015 is caused by the dataset ending on March 19 — creating an incomplete month compared to a full March 2014. This should not be reported as a performance decline without the MTD context provided in Category 1.
