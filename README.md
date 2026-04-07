# Maven-Fuzzy-Factory-Funnel-Traffic-Analysis
An end-to-end data analysis project focused on optimizing the conversion funnel performance for "Maven Fuzzy Factory." This repository contains tools to identify root-cause of customer drop-off points and propose recommendation through data-driven insights.
# Project Background
Fuzzy Factory is a direct-to-consumer e-commerce company specializing in premium stuffed animals and gift-oriented bear products. The company has been operational since early 2012 and operates entirely through its online storefront, making website performance and conversion optimization central to its revenue model.

As the in-house Data Analyst, the primary mandate is to support marketing, product, and executive leadership in making data-backed decisions across four strategic areas: understanding growth trends, diagnosing funnel inefficiencies, evaluating product launches, and optimizing marketing channel spend.

Key business metrics tracked:

- Conversion Rate (CVR) — sessions to completed purchase
- Click-through rate (CTR)
- Bounce rate by landing page variant
- Cart abandonment rate

Insights and recommendations are provided on the following stakeholder questions:

`Why does high traffic volume not translate into proportional order volume — what is actually optimized, and where is the funnel still leaking?`

The Python codes used to inspect and clean the data for this analysis can be found here [link].

Targeted SQL queries regarding various business questions can be found here [link].

An interactive Tableau dashboard used to report and explore sales trends can be found here [link].
# Data Structure & Initial Checks
The companies main database structure as seen below consists of six tables: `orders`, `order_items`, `order_item_refunds`, `products`, `website_sessions`, `session_pageviews` with more than 1 million records. A description of each table is as follows:

`orders`: Stores high-level information and summary data for all placed orders.

`order_items`: Contains granular details for each specific product within an order (e.g., quantity, price per unit).

`order_item_refunds`: Tracks customer refund transactions and associated return data.

`products`: A comprehensive catalog of all products available on the platform.

`website_sessions`: Records user visit data, including traffic source and entry touchpoints.

`session_pageviews`: Logs specific pages viewed by users during each individual session.

|<img width="1288" height="510" alt="image" src="https://github.com/user-attachments/assets/e1336a4d-0858-4b64-8c05-51faae49be52" />|
|:-----------:|
|**Figure 1:** Entities Relationship Diagram|

# Assumptions and Caveats:

Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

**1. Null UTM campaign handling:**

For records in website_sessions where utm_campaign is missing (null), traffic is categorized using the following logic:

- ***Direct Traffic:*** Sessions where both utm_source and http_referer are null — users accessing via direct URL or bookmarks.
- ***Organic Search:*** Sessions where utm_source is null but http_referer contains search engine strings — unpaid search discovery.

**2. March 2015 YoY decline is a data artifact, not a business signal:**

The apparent decline in March 2015 is caused by the dataset ending on March 19 — creating an incomplete month compared to a full March 2014. Therefore, this should not be reported as a performance decline.

# Executive Summary
Between March 2012 and March 2015, Fuzzy Factory recorded 472,871 sessions but converted only 6.8% into orders — a gap driven by two structural problems, not traffic volume.
First, mobile underperforms at every funnel stage: a 10–12 point CTR deficit at acquisition and a 77.2% cart abandonment rate, well above the 69–72% global benchmark. Second, the flagship Mr. Fuzzy product absorbs 77.5% of product traffic but converts at only 43% — and of the 92,568 sessions that don't add it to cart, exactly 0% navigate to an alternative. Higher-converting products exist (Love Bear 55.6%, Mini Bear 65.1%) but are structurally invisible to hesitant buyers.
Desktop acquisition and checkout performance are both well-optimized through prior A/B testing. The remaining growth opportunity lies in mobile UX and mid-funnel cross-sell architecture.

# Overview

Table 1: Total Session through funnel

|Year|Total Sessions|Step 1-Home|Step 2-products|Step 3-Product Detail|Step 4-Cart|Step 5-Shipping|Step 6-Billing|Step 7-Ordered|
|-------|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|2012|	62470 |	62470  |29468	 |21252 |9235 |	6306 |	5166 |	2586 |
|2013|	112781|	112781 |62491	 |47878	|21521|	14647|	11877|	7447 |
|2014|	233423|	233422 |130660 |108182|48794|	33058|	26580|	16860|
|2015|	64198 |	64198	 | 38612 |32902	|15403|	10473|	8435 |	5420 |

Based on Table 1 and Figure 2, between March 2012 and March 2015, the Fuzzy Factory e-commerce platform recorded a total of 472,871 sessions. Out of these, only 32,313 sessions successfully converted into orders, resulting in an overall Conversion Rate (CVR) of 6.8%. Analysis of the conversion funnel reveals three critical bottlenecks:
- **Point 1: Home -> Product:** More than 200,000 sessions exit the site immediately after landing, without viewing any specific product.
- **Point 2: Product Detail View -> Add-to-cart:** Approximately 115,000 sessions—nearly 54,8% of users who viewed a product—dropped off before adding an item to their cart.
- **Point 3: Add-to-cart -> Success Purchase:** Out of 63,640 sessions that reached the "Add-to-cart" stage, 31,327 sessions failed to complete the transaction, resulting in only 32,313 successful orders.

|<img width="1011" height="333" alt="Ảnh chụp màn hình 2026-03-29 230840" src="https://github.com/user-attachments/assets/15abc764-181f-422b-a3b2-fff8486d9917" />|
|:---------:|
|**Figure 2:** Conversion Rate and Drop-off by Stages|

To better understand these bottlenecks and explain why high traffic volume does not translate into proportional orders, a detailed drill-down into the first stage is required:

# Insight Deep Dive

### **Stage 1:** Top-Funnel Diagnostics (Home/Landing → Product)

***Key takeaway:*** The 200,000+ session drop-off at the top of the funnel is primarily a filtering of low-intent traffic. Continuous A/B testing and split-routing have optimized this stage close to its ceiling, with the exception of a gap on mobile devices.

- **Main finding 1:** The hypothesis that the landing page design is flawed is rejected for desktop users. Historical data traces the A/B testing progression for new desktop traffic. Between mid-2012 and mid-2014, traffic allocated to early variants (`/lander-1`, `/lander-2`, and `/lander-4`) resulted in a 45%–55% CTR, underperforming the `/home` page's 60%–66% baseline and reducing overall monthly averages. In August 2014, the deployment of `/lander-5` achieved a 62.1% CTR, matching the `/home` baseline. Reallocating traffic volume to `/lander-5` in late 2014 stabilized the overall desktop acquisition CTR above 60% by early 2015.

|<img width="1389" height="690" alt="image" src="https://github.com/user-attachments/assets/a62dbe2f-73b6-497e-ad37-64494291eced" />|
|:---------:|
|**Figure 3:** Desktop Acquisition CTR of New Customer on Desktop|

- **Main finding 2:** Audience intent dictates the conversion ceiling, validating the split-routing architecture. Data shows that Repeat and Brand-search cohorts outperform New Nonbrand segments by a 10% to 15% margin across all timeframes and devices. The routing architecture aligns with this user behavior: `/lander-x` pages process nonbrand traffic, while the `/home` page is reserved for Direct, Brand, and Returning users. Operating as a navigation hub, the `/home` page maintains a 68%–75% conversion rate. The remaining top-funnel drop-offs represent the expected baseline of acquiring first-time buyers.

|<img width="1389" height="690" alt="image" src="https://github.com/user-attachments/assets/9a03bf39-15a3-4209-b03d-d52589222a15" />|
|:---------:|
|**Figure 4:** Top-Funnel CTR by Customer Segment and Landing Page Variant|

- **Main finding 3:** Mobile-specific routing improved mobile CTR, though a 10%–12% performance gap remains compared to desktop. Prior to mid-2013, mobile nonbrand traffic maintained a 28%–33% click-through rate (CTR) on the `/home` and `/lander-1` pages. The introduction of `/lander-3`, a dedicated mobile landing page, increased and stabilized the mobile CTR at 52%–54% through early 2015. Despite this increase, mobile performance continues to trail the desktop `/lander-5` benchmark by approximately 10%–12%, identifying mobile viewport optimization as the primary remaining action item at this stage.

|<img width="1033" height="518" alt="image" src="https://github.com/user-attachments/assets/305f02de-312d-4c8e-a678-8de09d92e5d5" />|
|:----------------:|
|**Figure 5:** Click-through rate Trend by device|

## **Stage 2:** Mid-Funnel Diagnostics (Detail View → Add-to-Cart)

***Key takeaway:*** The 55% mid-funnel drop-off is concentrated on a single product. Mr. Fuzzy accounts for 77.5% of product views but converts at 43.04% — the lowest in the portfolio. Higher-converting alternatives exist (Love Bear 55.6%, Mini Bear 65.1%) but receive less than 15% of total traffic, and the current page architecture offers no pathway between them: 100% of the 92,568 sessions that do not convert on Mr. Fuzzy exit the site entirely.

- **Main finding 1:** The primary product, `/the-original-mr-fuzzy`, drives volume but represents the largest absolute drop-off. It accounts for 77.5% of product views but results in over 92,000 lost "Add-to-Cart" sessions due to its 43.04% CVR baseline. Newer products (`Love Bear` at 55.6% and `Mini Bear` at 65.1%) operate at higher conversion rates, but their overall impact is limited by lower traffic allocation.

- **Main finding 2:** Alternative products show stronger product-market fit but lack visibility. Newer SKUs (Love Bear at 55.6% and Mini Bear at 65.1%) demonstrate significantly higher conversion rates. However, their business impact is severely limited because they receive less than 15% of total product traffic.

Table 2: Product Portfolio Conversion Performance (Aggregate 2012 - 2015)
| Product Landing Page | Total Detail Views | Sessions Added to Cart | View-to-Cart CVR (Desktop Only) | View-to-Cart CVR (Mobile Only) |
|:---|---:|---:|---:|---:|
| `/the-original-mr-fuzzy` | 162,525 | 69,957 | 43.04% | 40.13% |
| `/the-forever-love-bear` | 26,033 | 14,485 | 55.64% | 50.20% |
| `/the-birthday-sugar-panda` | 19,046 | 8,811 | 46.26% | 41.50% |
| `/the-hudson-river-mini-bear` | 2,610 | 1,700 | 65.13% | 60.30% |

- **Main finding 3:** The Product Detail Page lacks horizontal navigation, acting as a strict dead-end for hesitant buyers. While the platform successfully generates cross-sales when products are bundled in the cart, users who reject the primary product have no alternative pathways. Behavioral flow analysis reveals that out of the 92,568 sessions that do not add Mr.Fuzzy to their cart, exactly 0% navigate to view alternative products.

Table 3: Next Action Distribution for Mr.Fuzzy
|Next Action	|Total Sessions	|Contribute to Fuzzy traffic (%)|
|------|:------:|:------:|
|Bounced / Exited completely|	92568|	56.96|
|Added to Cart (Converted)  |	69957|	43.04|

## **Bottleneck 3 — Check-out funnel (Shipping → Billing → Purchased):**

***Key takeaway:*** The checkout flow outperforms global e-commerce benchmarks, indicating that bottom-funnel is highly optimized. The primary drop-off occurs at the initial Cart stage rather than during shipping or payment steps.

- **Main finding 1:** Overall cart abandonment of 65.97% falls below the global e-commerce benchmark of 69–72% ([source](https://baymard.com/lists/cart-abandonment-rate)). However, device-level breakdown reveals that desktop (63.00%) is driving this result, while mobile (77.23%) sits above benchmark — indicating the aggregate figure masks a structural mobile problem.

Table 4: Total Session and Conversion Rate of each Stage in Check-out Funnel 
|device|total cart sessions|	total shipping sessions|	cart to shipping cvr (%)|	total billing sessions|	shipping to billing cvr (%)| total success purchase|	billing to purchased cvr (%)|	cart abandonment rate (%)|
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
mobile |	19798|	11792|	59.56|	8336 |	70.69|	4508 |	54.08|	77.23|
desktop|	75155|	52692|	70.11|	43722|	82.98|	27805|	63.59|	63.00|

- Main finding 2: Shipping cost is not a driver of drop-off. Of sessions reaching /shipping, 80.73% proceed to /billing — indicating that delivery terms are not a deterrent at this stage.

- Main finding 3: Payment friction was resolved through A/B testing. /billing-2 lifted billing-to-purchase CVR from 44.79% to 63.36% on desktop and from 34.55% to 55.09% on mobile — a sustained improvement that has held since September 2012.
  
Table 5: Billing Landing Page Performance
|Device|Page URL| Period|Total Billing Session|Successful Purchase|
|:-----|:-----:|:-----:|:-----:|:-----:|
|desktop|/billing  |	3206	|1478|	46.10|
|desktop|/billing-2|	40516|	26327|	64.98|
|mobile|	/billing  |	411	|142	|34.55|
|mobile|	/billing-2|	7925|	4366|	55.09|

# Recommendations:
Based on the insights and findings above, we would recommend the stakeholder to consider the following:

|Priority| Observation| Recommendation| Success Metric
|:----:|----|----|----|
|P1|Mobile traffic consistently underperforms, trailing desktop by ~10% at acquisition and suffering a 77.2% cart abandonment rate.|Conduct a full Mobile UX Audit. Prioritize streamlining the mobile cart interface and top-funnel landing pages to eliminate device-specific friction.|Decrease mobile Cart Abandonment rate from 77.2% to <70%. Increase mobile Top-Funnel CTR to >58%.

|P2|Over 92,000 sessions (56.9%) bounce directly from the flagship Mr. Fuzzy product page with exactly 0% navigating to alternative SKUs, despite newer products converting at much higher rates (55-65%).|Launch a Mid-Funnel Cross-sell A/B Test. Implement a "You May Also Like" product carousel on the Mr. Fuzzy page to route bouncing users to high-CVR products.|+5% increase in secondary SKU Detail Views. +2% uplift in overall Mid-Funnel (View-to-Cart) CVR.|

|P3|`/lander-5` matches `/home` on CTR for new desktop customers while generating the lowest historical refund rate.|Establish `/lander-5` as the strict Desktop Control Baseline. Route all new desktop nonbrand traffic here for optimized acquisition quality.|Maintain Desktop Top-Funnel CTR >62%. Maintain product refund rate <4.5%.|
