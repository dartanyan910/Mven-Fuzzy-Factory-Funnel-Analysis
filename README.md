# Maven-Fuzzy-Factory-Funnel-Traffic-Analysis
An end-to-end data analysis project focused on optimizing the conversion funnel performance for "Maven Fuzzy Factory." This repository contains tools to identify customer drop-off points and measure the success of marketing campaigns through data-driven insights.
# Project Background
Fuzzy Factory is a direct-to-consumer e-commerce company specializing in premium stuffed animals and gift-oriented bear products. The company has been operational since early 2012 and operates entirely through its online storefront, making website performance and conversion optimization central to its revenue model.

As the in-house Data Analyst, the primary mandate is to support marketing, product, and executive leadership in making data-backed decisions across four strategic areas: understanding growth trends, diagnosing funnel inefficiencies, evaluating product launches, and optimizing marketing channel spend.

Key business metrics tracked:

- Conversion Rate (CVR) — sessions to completed purchase
- Click-through rate (CTR)
- Bounce rate by landing page variant
- Cart abandonment rate

Insights and recommendations are provided on the following stakeholder questions:

`Why does high traffic volume not translate into proportional order volume — where are customers dropping off?`

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

|<img width="1288" height="510" alt="image" src="https://github.com/user-attachments/assets/e1336a4d-0858-4b64-8c05-51faae49be52" />|
|:-----------:|
|**Figure 1:** Entities Relationship Diagram|


# Executive Summary
..........

# Overview

## Traffic & Growth Overview
 
**Fuzzy Factory's growth over three years was not just volume — it was volume with improving efficiency at every stage.**
 
| Year | Total Sessions | Total Orders | Overall CVR | Landing → Product | Product → Cart | Cart → Order |
|---|---|---|---|---|---|---|
| 2012 | 62,470 | 2,586 | 3.19% → 5.02% | 39% → 50% | 30% → 32% | 22% → 32% |
| 2013 | 112,781 | 7,447 | 6.09% → 6.95% | 52% → 56% | 33% → 36% | 33% → 37% |
| 2014 | 233,423 | 16,860 | 6.27% → 7.90% | 49% → 58% | 37% → 39% | 33% → 36% |
| 2015 | 64,198 | 5,420 | 8.28% → 8.70% | 59% → 60% | 39% → 41% | 34% → 36% |
 
**Traffic scaled 16x, but orders scaled 39x.** Each additional session in 2015 was worth materially more than each session in 2012 — reflecting a funnel that improved in parallel with volume growth.
 
**CVR improvement was driven by all three stages simultaneously.** Landing → Product improved +21pp, Product → Cart improved +11pp, Cart → Order improved +13pp. No single stage carried the improvement — the entire funnel moved together.
 
**The steepest gains occurred between 2012 and 2013.** Overall CVR nearly doubled in this window, coinciding with the introduction of optimized landing pages and mobile-specific routing. Subsequent years showed continued but more moderate improvement — consistent with a maturing funnel approaching its structural ceiling.

## Funnel Snapshot

Table 1: Total Session through funnel

|year|total_sessions|step_1_home|step_2_products|step_3_product_detail|step_4_cart|step_5_shipping|step_6_billing|step_7_ordered|
|-------|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|2012|	62470 |	62470  |29468	 |21252 |9235 |	6306 |	5166 |	2586 |
|2013|	112781|	112781 |62491	 |47878	|21521|	14647|	11877|	7447 |
|2014|	233423|	233422 |130660 |108182|48794|	33058|	26580|	16860|
|2015|	64198 |	64198	 | 38612 |32902	|15403|	10473|	8435 |	5420 |

Based on Table 1 and Figure 2, between March 2012 and March 2015, the Fuzzy Factory e-commerce platform recorded a total of 472,871 sessions. Out of these, only 32,313 sessions successfully converted into orders, resulting in an overall Conversion Rate (CVR) of 6.8%. Analysis of the conversion funnel reveals three critical bottlenecks:
- **Point 1: Home -> Product:** More than 200,000 sessions exit the site immediately after landing, without viewing any specific product.
- **Point 2: Product Detail View -> Add-to-cart:** Approximately 115,000 sessions—nearly 54,8% of users who viewed a product—dropped off before adding an item to their cart.
- **Point 3: Add-to-cart -> Success Purchase:** Out of 63,640   sessions that reached the "Add-to-cart" stage, 38,547 sessions failed to complete the transaction, resulting in only 32,313 successful orders.

|<img width="1011" height="333" alt="Ảnh chụp màn hình 2026-03-29 230840" src="https://github.com/user-attachments/assets/15abc764-181f-422b-a3b2-fff8486d9917" />|
|:---------:|
|**Figure 2:** Conversion Rate and Drop-off by Stages|

To better understand these bottlenecks and explain why high traffic volume does not translate into proportional orders, a detailed drill-down into the first stage is required:

# Insight Deep Dive

### **Stage 1:** Top-Funnel Diagnostics (Home/Landing → Product)

***Key takeaway:*** The 200,000+ session drop-off at the top of the funnel is primarily a filtering of low-intent traffic, not a UI/UX failure. Continuous A/B testing and split-routing have optimized this stage close to its ceiling, with the exception of a gap on mobile devices.

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

**Conclusion:**
>The top-funnel is functioning exactly as an optimized filter should. The remaining drop-offs are largely the natural friction of acquiring first-time buyers. The only actionable structural leak left at this stage is the ~10% performance gap on mobile devices, which requires a final round of mobile viewport optimization.


## **Bottleneck 2 — Detail View → Add-to-Cart (~55% drop-off):**


|**Figure 5:** Product Detail to Add-to-Cart Conversion Rate by Product|
|:----------------:|
|<img width="1186" height="690" alt="image" src="https://github.com/user-attachments/assets/e005ec95-6531-4caf-a1f6-b30636b18736" />|

## **Bottleneck 3 — Check-out funnel (Shipping → Billing → Purchased):**

***Key takeaway:*** The checkout flow outperforms global e-commerce benchmarks, indicating that bottom-funnel UI/UX is highly optimized. The primary drop-off occurs at the initial Cart stage rather than during shipping or payment steps.

- **Main finding 1:** The hypothesis of widespread bottom-funnel friction is rejected. The overall cart abandonment rate is 65.97%, outperforming the global e-commerce benchmark of 69%–72% ([source](https://baymard.com/lists/cart-abandonment-rate)). This confirms the checkout infrastructure is structurally sound, despite the absolute volume of drop-offs.

Table 4: Total Session and Conversion Rate of each Stage in Check-out Funnel 
|total cart sessions|	total shipping sessions|	cart to shipping cvr (%)|	total billing sessions|	shipping to billing cvr (%)| total success purchase|	billing to purchased cvr (%)|	cart abandonment rate (%)|
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|94,953|	64,484|	67.91|	52,058|	80.73|	32,313|	62.07|	65.97|

- **Main finding 2:** The “shipping cost shock” hypothesis is not supported by the data. Upon reaching the `/shipping` page, 80.73% of sessions proceed to `/billing`. This high progression rate demonstrates that shipping fees and delivery timelines are not significant deterrents for users at this stage.
   
- **Main finding 3:** Payment friction was resolved via historical A/B testing. The original `/billing` page yielded a 44.79% conversion rate. The deployment of `/billing-2` in September 2012 increased and stabilized the payment-to-purchase conversion rate at 63.36%, confirming the payment step operates efficiently.
  
Table 5: Billing Landing Page Performance
|Page URL| Period|Total Billing Session|Successful Purchase|Billing to Successful Purchase CVR (%)|
|:-----|:-----:|:-----:|:-----:|:-----:|
|`/billing`  |3/2012 - 1/2013 |3,617 |1,620 |44.79|
|`/billing-2`|9/2012 - Current|48,441|30,693|63.36|

**Conclusion:**

>The biggest leakage within the checkout funnel is at the /cart → /shipping step, where conversion is only 67.91%. In other words, about 32% of users leave immediately after viewing their cart. This suggests many users may be checking total cost rather than fully committing to buy yet.

# Recommendations:
Based on the insights and findings above, we would recommend the [stakeholder team] to consider the following:
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
Specific observation that is related to a recommended action. Recommendation or general guidance based on this observation.
# Assumptions and Caveats:

Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

**1. Null UTM campaign handling:**

For records in website_sessions where utm_campaign is missing (null), traffic is categorized using the following logic:

- ***Direct Traffic:*** Sessions where both utm_source and http_referer are null — users accessing via direct URL or bookmarks.
- ***Organic Search:*** Sessions where utm_source is null but http_referer contains search engine strings — unpaid search discovery.

**2. Bounce rate benchmarks sourced from Shopify industry data:**

The e-commerce bounce rate benchmark range of 36–45% referenced in Category 2 is based on published Shopify industry averages for retail and gifting categories. This benchmark should be periodically refreshed as market conditions evolve.

**3. March 2015 YoY decline is a data artifact, not a business signal:**

The apparent decline in March 2015 is caused by the dataset ending on March 19 — creating an incomplete month compared to a full March 2014. Therefore, this should not be reported as a performance decline.
