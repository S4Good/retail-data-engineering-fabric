
# Retail Data Engineering with Microsoft Fabric

End-to-end retail data engineering portfolio project built with **Microsoft Fabric**, demonstrating data ingestion, Medallion Architecture, PySpark transformations, orchestration, dimensional modeling, and SQL analytics.

## Project Goal

The goal of this project is to simulate a modern retail data platform that integrates data from multiple business domains such as:

* Customers / CRM
* Orders / Webshop
* Products / ERP

The data is ingested, cleaned, transformed, modeled, and prepared for analytics using Microsoft Fabric.

The project was built as a practical Data Engineering learning and portfolio project.

---

## Architecture

The platform follows a Medallion-style architecture:

```text
CSV Sources
    ↓
Dataflow Gen2
    ↓
Bronze Layer
    ↓
Silver Layer
    ├── Dataflow Gen2
    └── PySpark
    ↓
Gold Sales
    ↓
Fabric Warehouse
    ↓
Star Schema
    ↓
SQL Analytics
    ↓
Visualizations / Power BI
```

A detailed architecture diagram is available here:

[View architecture](docs/architecture.md)

---

## Technology Stack

| Area                        | Technologies                        |
| --------------------------- | ----------------------------------- |
| Platform                    | Microsoft Fabric                    |
| Storage                     | Fabric Lakehouse / OneLake          |
| Ingestion                   | Dataflow Gen2                       |
| Transformation              | Power Query, PySpark                |
| Processing                  | Apache Spark                        |
| Storage Format              | Delta Lake                          |
| Orchestration               | Fabric Data Pipelines               |
| Data Warehouse              | Fabric Warehouse                    |
| Analytics                   | T-SQL                               |
| Modeling                    | Medallion Architecture, Star Schema |
| Version Control / Portfolio | GitHub                              |

---

## Data Architecture

### Bronze Layer

Raw source data is ingested into the Fabric Lakehouse.

Tables include:

* `bronze_customers`
* `bronze_orders`
* `bronze_products`

The Bronze layer remains close to the original source structure.

---

### Silver Layer

The Silver layer contains cleaned and validated data.

Implemented transformations include:

* datatype validation
* NULL checks
* duplicate removal
* text normalization
* business-rule validation
* standardized customer and product information

Tables include:

* `silver_customers`
* `silver_orders`
* `silver_orders_pyspark`
* `silver_products`

Orders were implemented both with **Dataflow Gen2** and **PySpark** to compare low-code and code-based transformation approaches.

The outputs were validated against each other to ensure equivalent results.

---

### Gold Layer

The Gold layer combines cleaned customer, product, and order data into a business-ready dataset:

`gold_sales`

The Gold dataset contains attributes such as:

* order ID
* customer
* country
* product
* category
* quantity
* unit price
* sales amount
* order date

Example business calculation:

```text
sales_amount = quantity * unit_price
```

---

## PySpark Transformation

The project contains a PySpark notebook:

`notebooks/nb_transform_orders_silver.ipynb`

The notebook performs:

* reading Bronze orders from the Lakehouse
* NULL validation
* duplicate detection
* validation of `quantity > 0`
* Silver-layer filtering and deduplication
* writing the result as a Delta table
* validation against the Dataflow Gen2 implementation

Example:

```python
df_orders_silver = (
    df_orders
    .filter(col("order_id").isNotNull())
    .filter(col("customer_id").isNotNull())
    .filter(col("product_id").isNotNull())
    .filter(col("quantity") > 0)
    .dropDuplicates(["order_id"])
)
```

---

## Pipeline Orchestration

The Fabric pipeline `pl_retail_medallion` orchestrates the complete workflow.

The ingestion processes for customers, products, and orders can run independently.

Silver transformations are executed after their corresponding Bronze ingestion succeeds.

The production Orders path uses PySpark:

```text
ingest_orders
    ↓
transform_orders_pyspark
    ↓
build_gold_sales
```

The pipeline demonstrates:

* dependency management
* parallel execution
* success conditions
* notebook integration
* Dataflow Gen2 integration
* pipeline monitoring

---

## Data Quality

Several data-quality checks were implemented during transformation.

Examples:

```text
order_id IS NOT NULL
customer_id IS NOT NULL
product_id IS NOT NULL
quantity > 0
order_id must be unique
```

PySpark was also used to compare the output of the low-code Dataflow Gen2 transformation against the code-based implementation.

Both implementations produced identical results.

---

## Fabric Warehouse

A Fabric Warehouse was created as the analytical serving layer:

`retail_warehouse`

The warehouse uses a simple Star Schema.

### Dimension Tables

* `dim_customer`
* `dim_product`
* `dim_date`

### Fact Table

* `fact_sales`

Simplified model:

```text
                 dim_customer
                      |
dim_product —— fact_sales —— dim_date
```

The SQL used to create the model is available in:

`sql/create_star_schema.sql`

---

## SQL Analytics

Example analytical queries are stored in:

`sql/analytics_queries.sql`

Examples include:

* revenue by country
* revenue by product
* revenue by category
* monthly revenue
* top customers by revenue

Example:

```sql
SELECT
    c.country,
    SUM(f.sales_amount) AS total_revenue
FROM dbo.fact_sales AS f
JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;
```

---

## Repository Structure

```text
retail-data-engineering-fabric/
│
├── README.md
│
├── data/
│   └── sample source datasets
│
├── notebooks/
│   └── nb_transform_orders_silver.ipynb
│
├── sql/
│   ├── create_star_schema.sql
│   └── analytics_queries.sql
│
├── docs/
│   └── architecture.md
│
└── screenshots/
    └── Fabric pipeline, Lakehouse, Warehouse and analytics screenshots
```

---

## Engineering Concepts Demonstrated

This project demonstrates practical experience with:

* ETL / ELT
* Microsoft Fabric
* Dataflow Gen2
* Lakehouse architecture
* OneLake
* Bronze / Silver / Gold architecture
* Apache Spark / PySpark
* Delta tables
* Data quality validation
* pipeline orchestration
* dependency management
* dimensional modeling
* Star Schema
* Fact and Dimension tables
* SQL analytics
* troubleshooting and debugging
* low-code vs code-based data transformation

---

## Example Business Questions

The resulting analytical model can answer questions such as:

* Which countries generate the most revenue?
* Which products produce the highest sales?
* Which product categories perform best?
* How does revenue develop over time?
* Which customers generate the most revenue?

---

## Future Improvements

Planned extensions include:

* Power BI dashboard
* incremental data loading
* larger synthetic datasets
* automated data-quality reporting
* improved error handling
* pipeline alerting and monitoring
* CI/CD
* Git-based deployment workflows
* Infrastructure as Code
* streaming / Real-Time Intelligence
* KQL analytics

---

## About This Project

This project was developed as a hands-on Data Engineering portfolio project while preparing for the **Microsoft Fabric Data Engineer (DP-700)** certification.

The focus is not only on using individual Fabric features, but on understanding how ingestion, transformation, orchestration, storage, data modeling, and analytics work together as an end-to-end data platform.
