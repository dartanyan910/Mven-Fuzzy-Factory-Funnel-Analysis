# Fuzzy-Store-Funnel-and-Product-Launching-analysis
An end-to-end data analysis project focused on optimizing the conversion funnel and evaluating product launch performance for "Fuzzy Store." This repository contains tools to identify customer drop-off points and measure the success of marketing campaigns through data-driven insights.
# Project Background
Fuzzy Factory is a direct-to-consumer e-commerce company specializing in premium stuffed animals and gift-oriented bear products. The company has been operational since early 2012 and operates entirely through its online storefront, making website performance and conversion optimization central to its revenue model.

As the in-house Data Analyst, the primary mandate is to support marketing, product, and executive leadership in making data-backed decisions across four strategic areas: understanding growth trends, diagnosing funnel inefficiencies, evaluating product launches, and optimizing marketing channel spend.

Key business metrics tracked:

- Website Sessions & Monthly Orders (volume and YoY growth)
- Conversion Rate (CVR) — sessions to completed purchase
- Revenue by product and landing page
- Bounce rate by landing page variant
- Cart abandonment rate
- Cross-sell attach rate

Insights and recommendations are provided on the following key areas:

- Category 1: Website Sessions & Orders Growth
- Category 2: Conversion Funnel Analysis
- Category 3: Product Launch Impact
- Category 4: Channel Optimization (in progress)

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
## Overview of Findings

Fuzzy Factory recorded over 400,000 website sessions across the analysis period, yet only 32,313 resulted in completed transactions — an overall conversion rate of 6.8%. This report investigates the root causes of the 93.2% drop-off, identifies the primary bottleneck in the conversion funnel, and documents the A/B testing journey that progressively improved landing page performance. The findings support a focused optimization effort on the Detail View → Add-to-cart stage, while confirming that the Home/Landing page bottleneck has been largely resolved through iterative experimentation.

[Visualization, including a graph of overall trends or snapshot of a dashboard]
# Insights Deep Dive
## Category 1:
Main insight 1. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 2. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 3. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 4. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
[Visualization specific to category 1]
## Category 2: Funnel

**Bottleneck 1 — Home → Product Page (~55.5% drop-off):**
More than 200,000 sessions exit before viewing any product. Initially flagged as a UI/UX concern, however average time-on-page data (~186 seconds) suggests users do engage with the homepage. The high drop-off in early 2012 (>60% bounce rate) triggered the A/B testing program documented in Section 4. This bottleneck has since been largely resolved.

**Bottleneck 2 — Detail View → Add-to-Cart (~55% drop-off) (Primary):**
This is the most significant active bottleneck. Average time on the product detail page is approximately 2 minutes — indicating user engagement rather than UI friction. The high exit rate therefore points to product-side barriers: insufficient product description quality, non-compelling imagery, or a pricing mismatch relative to willingness-to-pay.

**Bottleneck 3 — Billing → Purchase (~65% cart abandonment):**
Elevated, but within the accepted e-commerce benchmark range of 60–80%. Average time at this stage (~3.25 minutes) suggests checkout complexity as a contributing factor. Given benchmark alignment, this is a lower priority relative to Bottleneck 2.

<img width="682" height="228" alt="image" src="https://github.com/user-attachments/assets/9e096190-1026-4e6c-80f0-02a143dd7729" />

Figure 2: Conversion Rate and Drop-off by Stages

### Stage Home → Product 

Based on Table 1, The bounce rates for Fuzzy Store's landing pages range from 41.68% to 53.24%. Compared to the e-commerce industry benchmark of 36% - 45% ([source](https://www.shopify.com/hk-en/blog/bounce-rate)), our current figures are significantly higher. The high bounce rates suggest friction at the initial touchpoint. Potential causes include slow page load times, non-mobile-friendly layouts, or a lack of compelling Call-to-Action (CTA) elements.

This idea also supported by Figure 3. Thời gian spent trung bình của các user đến bước tiếp theo

<img width="461" height="226" alt="image" src="https://github.com/user-attachments/assets/b6998987-c47d-4ba6-91f7-8b537a54e966" />

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
