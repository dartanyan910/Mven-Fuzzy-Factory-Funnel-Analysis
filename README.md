# Fuzzy-Store-Funnel-and-Product-Launching-analysis
An end-to-end data analysis project focused on optimizing the conversion funnel and evaluating product launch performance for "Fuzzy Store." This repository contains tools to identify customer drop-off points and measure the success of marketing campaigns through data-driven insights.
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
Fuzzy Factory recorded over 400,000 website sessions across the analysis period, yet only 32,313 resulted in completed transactions — an overall conversion rate of 6.8%. This report investigates the root causes of the 93.2% drop-off, identifies the primary bottleneck in the conversion funnel, and documents the A/B testing journey that progressively improved landing page performance. The findings support a focused optimization effort on the Detail View → Add-to-cart stage, while confirming that the Home/Landing page bottleneck has been largely resolved through iterative experimentation.

[Visualization, including a graph of overall trends or snapshot of a dashboard]
# Insights Deep Dive

## ***Why does high traffic volume not translate into proportional order volume — where are customers dropping off?***

Table 1: Total Session through funnel

|year|total_sessions|step_1_home|step_2_products|step_3_product_detail|step_4_cart|step_5_shipping|step_6_billing|step_7_ordered|
|-------|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|2012|	62470 |	62470  |29468	 |21252 |9235 |	6306 |	5166 |	2586 |
|2013|	112781|	112781 |62491	 |47878	|21521|	14647|	11877|	7447 |
|2014|	233423|	233422 |130660 |108182|48794|	33058|	26580|	16860|
|2015|	64198 |	64198	 | 38612 |32902	|15403|	10473|	8435 |	5420 |

|<img width="1011" height="333" alt="Ảnh chụp màn hình 2026-03-29 230840" src="https://github.com/user-attachments/assets/15abc764-181f-422b-a3b2-fff8486d9917" />|
|:---------:|
|**Figure 2:** Conversion Rate and Drop-off by Stages|



Based on Table 1 and Figure 2, between March 2012 and March 2015, the Fuzzy Factory e-commerce platform recorded a total of 472,871 sessions. Out of these, only 32,313 sessions successfully converted into orders, resulting in an overall Conversion Rate (CVR) of 6.8%. Analysis of the conversion funnel reveals three critical bottlenecks:
- **Point 1: Home -> Product:** More than 200,000 sessions exit the site immediately after landing, without viewing any specific product.
- **Point 2: Product Detail View -> Add-to-cart:** Approximately 115,000 sessions—nearly 54,8% of users who viewed a product—dropped off before adding an item to their cart.
- **Point 3: Add-to-cart -> Success Purchase:** Out of 63,640   sessions that reached the "Add-to-cart" stage, 38,547 sessions failed to complete the transaction, resulting in only 32,313 successful orders.

To better understand these bottlenecks and explain why high traffic volume does not translate into proportional orders, a detailed drill-down into the first stage is required:

### **Bottleneck 1:** Home → Product

Analysis across three dimensions — landing page performance, campaign attribution, and device type — reveals that the primary driver of Home-stage drop-off can from both page design and traffic source.

***Page Design***

**Table 2:** Average time spent in each landing page
|landing page| avg time spent (sec)|
|----------|:----------:|
|`/home`|	185.6|
|`/lander-1`|	184.3|
|`/lander-2`|	185.6|
|`/lander-3`|	184.6|
|`/lander-4`|	187.9|
|`/lander-5`|	184.2|

Non-bounce sessions averaged 185 seconds (~3 minutes), significantly exceeding the e-commerce benchmark of 60–120 seconds ([source](https://www.growthsuite.net/glossary/average-time-on-page)). This high engagement, paired with a 44.8% drop-off rate (well below the industry average of 70–90%), indicates strong initial user intent and content relevance ([source](https://www.leadraftmarketing.com/post/best-practices-to-decrease-bounce-rate-for-landing-pages)).

These findings effectively reject the hypothesis of a landing page design flaw, shifting the strategic focus to downstream friction points.

***Traffic Source***

**1. By landing page**

Insight 1: The Pilot campaign inflated traffic volume on `/lander‑3` but sharply diluted its quality, directly suppressing CTR and downstream conversions.

Between December 2013 and February 2014, the campaign drove a surge in sessions — from 3,829 to 5,129 (+34%) — yet the number of users advancing to the product catalog fell from 2,047 to 1,797. CTR consequently collapsed from 53.5% to 35.0%.

The incremental 1,300–2,000 sessions brought in by Pilot traffic carried low purchase intent and eroded page efficiency, effectively destroying more value than they created. After the campaign ended, `/lander‑3` rebounded to 2,077 advancing users (CTR 53.2%) by April 2014, confirming that the issue lay not in page quality but in traffic composition.

So what: The Pilot campaign’s broad targeting strategy inflated headline traffic metrics while masking a decline in buyer intent — a key factor explaining why higher visits did not translate into proportional order volume.

Insight 2 — Dual failure of the desktop_targeted campaign on `/lander-2`

During Q4 2014, the desktop_targeted campaign was routed to `/lander-2`, producing a sustained and severe performance decline. In October 2014, `/lander-2` processed 5,795 sessions with 3,079 users advancing (CTR 53.1%). By December 2014, as desktop_targeted traffic came to dominate the page's session mix, total sessions collapsed to 1,647 — with only 490 users proceeding (CTR 29.7%). This represents a net loss of approximately 2,589 users advancing per month compared to October, despite the page itself remaining unchanged. The campaign failed both in audience selection and message-to-page alignment.

**2. By campaign**

Insight 1 — The cost of broad targeting without quality filters

The Pilot campaign demonstrates a recurring pattern: rapid traffic volume expansion without corresponding purchase intent. When broad-targeted traffic is directed to a landing page, the dilution effect on CTR is immediate and measurable. In the case of `/lander-3`, injecting approximately 1,450 – 2,011 low-intent sessions per month (Pilot CTR: ~10–11%) into a page previously converting at 53% reduced the blended CTR by 15–18 percentage points — directly explaining the gap between rising session counts and stagnant order volumes.

Insight 2 — Audience-page mismatch in the desktop_targeted campaign

The desktop_targeted campaign was designed to optimize conversion among desktop users, yet delivered traffic with below-average purchase intent. The 23.4 percentage point CTR decline on `/lander-2` between October and December 2014 (53.1% → 29.7%) constitutes the strongest evidence of systematic targeting misalignment in the dataset. Whether the root cause lies in ad creative, audience definition, or bid strategy cannot be determined from session data alone, but the outcome — a page that previously converted more than half its visitors now converting fewer than one in three — warrants a formal post-mortem on campaign configuration.

|<img width="1032" height="525" alt="image" src="https://github.com/user-attachments/assets/47f93bb0-b6ef-45f7-ac0d-52c1890f74dc" />|
|:----------------:|
|**Figure 3:** Landing page Click-through-rate Overtime|

|<img width="1035" height="524" alt="image" src="https://github.com/user-attachments/assets/b053a6b2-3a1b-4b69-bfce-9437451ed8e1" />|
|:----------------:|
|**Figure 4:** Monthly Traffic Volume by Landing page|

**3. By device type**

|<img width="1182" height="590" alt="image" src="https://github.com/user-attachments/assets/4577a769-073d-4d6d-99bd-1a47006b8f4f" />|
|:----------------:|
|**Figure 5:** Click-through rate Trend by device|

|<img width="1184" height="590" alt="image" src="https://github.com/user-attachments/assets/7ab0a79b-ae51-42f8-a44b-58393356f42c" />|
|:----------------:|
|**Figure 5:** Traffic Volume Trend by device|

Insight — Mobile consistently underperforms desktop across all landing pages

Device-level analysis confirms that mobile sessions record materially lower CTR than desktop sessions across all landing page variants and time periods. The Pilot campaign, which disproportionately targeted mobile users via socialbook, compounded this structural disadvantage by routing low-intent mobile traffic to `/lander-3` — a page not optimized for mobile viewing.


## **Bottleneck 2 — Detail View → Add-to-Cart (~55% drop-off):**

This is the most significant active bottleneck. 

|<img width="1186" height="690" alt="image" src="https://github.com/user-attachments/assets/e005ec95-6531-4caf-a1f6-b30636b18736" />|
|:----------------:|
|**Figure 5:** Product Detail to Add-to-Cart Conversion Rate by Product|

## **Bottleneck 3 — Check-out funnel (Shipping → Billing → Purchased):**

Elevated, but within the accepted e-commerce benchmark range of ~60–80% ([source](https://baymard.com/lists/cart-abandonment-rate)). Average time at this stage (~3.25 minutes) suggests checkout form complexity as a contributing factor. Given benchmark alignment, this is a lower priority relative to Bottleneck 2.


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
