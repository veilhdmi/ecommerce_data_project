# 📊 Strategic Data Engineering: Scaling Insights for Olist E-commerce

## 🎯 Project Vision

The core objective was to architect and implement a production-grade **ELT Pipeline** for Olist, Brazil's largest e-commerce marketplace. The project transformed fragmented, high-volume raw data into a high-performance **Star Schema** within Snowflake, specifically designed to empower executive decision-making through synchronized, cross-functional analytics.

---

## 🛠️ Specialized Tech Stack

* **Cloud Data Warehouse:** Snowflake (Multi-cluster warehouse for high-concurrency).
* **Data Transformation:** dbt Core (Modular SQL modeling with Jinja templating).
* **Data Modeling:** Dimensional Modeling (Kimball Methodology).
* **Visualization:** Google Looker Studio (Advanced data blending and interactive filtering).
* **Version Control:** Git-based workflow for CI/CD readiness.

---

## 🏗️ Technical Architecture & Roadmap

### 1. Robust Data Cleansing (Bronze to Silver)

I implemented a multi-stage cleaning process to ensure data integrity:

* **Geospatial Standardization:** Resolved inconsistencies in state and city naming conventions using `UPPER()` and `TRIM()` functions.
* **Deduplication Logic:** Utilized Window Functions (`QUALIFY ROW_NUMBER() OVER...`) to handle duplicate geolocation coordinates, ensuring a 1:1 mapping for customer and seller zip codes.
* **Temporal Normalization:** Standardized various timestamp formats into a unified UTC timezone for accurate delivery time calculations.

### 2. Business Logic & Enrichment (Silver to Gold)

I engineered complex Fact tables that pre-calculate critical KPIs to reduce runtime latency:

* **Fact Sales:** Merged order items with payment sequences to provide a holistic view of revenue without overcounting due to multi-payment transactions.
* **Seller Performance:** Integrated review scores and logistics data to create a 360-degree view of seller health, including a custom-coded "Punctuality Rate."
* **Top Categories:** A specialized aggregation layer optimized for regional trend analysis.

---

## 💡 Key Engineering Decisions & Rationale

* **Implementation of ISO-3166-2 Geospatial Mapping:**
* **Decision:** I standardized all state data to ISO formats (e.g., `BR-SP`) and mapped them to Macro-regions (North, Southeast, etc.).
* **Rationale:** This enables "Cross-Filtering" in Looker Studio. By aligning the grain of the geographical dimension across all Fact tables, I ensured that a filter applied to "Macro-Region" updates Sales, Seller Metrics, and Product Trends simultaneously.


* **Optimization via Ephemeral Materialization:**
* **Decision:** I transitioned non-essential intermediate models to `ephemeral` materialization in dbt.
* **Rationale:** This strategy minimizes the cloud footprint by reducing **Storage costs** and saving **Compute credits** in Snowflake. It keeps the production schema clean by only persisting "Golden" tables while keeping the logic reusable.


* **Window Function Strategy for "Primary Category" Assignment:**
* **Decision:** I used `ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY SUM(price) DESC)` to determine each seller's top-performing category.
* **Rationale:** This solved a "fan-out" problem where sellers with multiple categories would otherwise duplicate revenue figures in a JOIN. This ensures that the Top 10 Sellers table remains accurate to the cent while still providing categorical context.



---

## 🚀 Quick Start: How to Clone & Run

### 1. Clone the Repository

```bash
git clone https://github.com/veilhdmi/ecommerce_data_project.git
cd olist-dbt-snowflake

```

### 2. Configure Credentials

Create or update your `profiles.yml` file (usually located in `~/.dbt/`) with your Snowflake credentials:

* **Account ID** (found in your Snowflake URL or `profiles.yml`)
* **User/Password/Role**
* **Database/Warehouse**

### 3. Initialize & Execute

```bash
# Install dbt packages (like dbt_utils)
dbt deps

# Run all models and materializations
dbt run

# Execute data quality tests (uniqueness, not_null, etc.)
dbt test

```

### 4. Documentation

```bash
dbt docs generate
dbt docs serve

```

---

## 📈 Business Impact

The resulting infrastructure serves as a **Scalable Analytical Engine**. It reduced the time-to-insight for regional performance from hours of manual spreadsheet merging to seconds of interactive filtering. The business can now proactively identify logistics bottlenecks in specific Macro-regions and pivot category strategies based on real-time regional demand.

---
