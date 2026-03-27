# Fuzzy-Store-Funnel-and-Product-Launching-analysis
An end-to-end data analysis project focused on optimizing the conversion funnel and evaluating product launch performance for "Fuzzy Store." This repository contains tools to identify customer drop-off points and measure the success of marketing campaigns through data-driven insights.
# Project Background
Background about the company, including the industry, active years, business model, and key business metrics. Explain this from the POV of a data analyst who is working at the company.
Insights and recommendations are provided on the following key areas:
Category 1:
Category 2:
Category 3:
Category 4:
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
Explain the overarching findings, trends, and themes in 2-3 sentences here. This section should address the question: "If a stakeholder were to take away 3 main insights from your project, what are the most important things they should know?" You can put yourself in the shoes of a specific stakeholder - for example, a marketing manager or finance director - to think creatively about this section.
[Visualization, including a graph of overall trends or snapshot of a dashboard]
# Insights Deep Dive
## Category 1:
Main insight 1. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 2. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 3. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
Main insight 4. More detail about the supporting analysis about this insight, including time frames, quantitative values, and observations about trends.
[Visualization specific to category 1]
## Category 2: Funnel
Toàn bộ funnel đang mất khoảng 91,5% user từ Home đến Success, dẫn tới overall conversion rate chỉ 8,5% trên 327K sessions và 28K purchased sessions trong giai đoạn 2012–2015. Phần lớn rơi rụng diễn ra sớm (Home → Product) và giữa phễu (Detail View → Cart), cho thấy vấn đề chính nằm ở khả năng đưa người dùng từ khám phá sang hành động, hơn là ở bước thanh toán cuối cùng.

<img width="682" height="228" alt="image" src="https://github.com/user-attachments/assets/9e096190-1026-4e6c-80f0-02a143dd7729" />

Figure 2: Conversion Rate and Drop-off by Stages

### Stage Home → Product 
Table 1:

| Landing Page | Total Sessions | Bounce Sessions | Bounce Rate (%) | Avg. Time (sec) | Avg. Time Before Next Page (sec) |
|:---|---:|---:|---:|---:|---:|
| `/home` | 137,576 | 57,346 | 41.68% | 185.63 | 185.63 |
| `/lander-2` | 131,170 | 59,249 | 45.17% | 185.58 | 185.58 |
| `/lander-3` | 79,000 | 39,733 | 50.29% | 184.64 | 184.64 |
| `/lander-5` | 68,166 | 25,131 | 36.87% | 184.18 | 184.18 |
| `/lander-1` | 47,574 | 25,330 | 53.24% | 184.28 | 184.28 |
| `/lander-4` | 9,385 | 4,851 | 51.69% | 187.86 | 187.86 |

Based on Table 1, The bounce rates for Fuzzy Store's landing pages range from 41.68% to 53.24%. Compared to the e-commerce industry benchmark of 36% - 45%, our current figures are significantly higher. The high bounce rates suggest friction at the initial touchpoint. Potential causes include slow page load times, non-mobile-friendly layouts, or a lack of compelling Call-to-Action (CTA) elements.

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
Handling Null Values: For records in the website_sessions table where utm_campaign is missing (null), traffic is categorized based on the following technical criteria:
Direct Traffic: Defined as sessions where both utm_source and http_referer are null. This represents users who accessed the site directly via URL entry or browser bookmarks, without an external referral or campaign tracking.
Organic Search: Defined as sessions where utm_source is null but the http_referer contains "search" strings. This indicates users who discovered the website through unpaid results on search engines (e.g., Google, Bing).
Temporal Scope Exclusions: Data for March 2012 has been excluded from the primary analysis for the following reasons:
Data Incompleteness: The dataset for this period only begins on the 19th of the month. Including this partial data would lead to skewed Month-over-Month or Year-over-Year growth metrics, resulting in misleading interpretations.
Relevance and Recency: Given that this data is over three years old, it lacks sufficient proximity to current market conditions and has negligible impact on contemporary currently strategic decision-making.
