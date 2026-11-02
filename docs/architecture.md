# Architecture

```mermaid
flowchart TD

    A[CSV Sources<br/>Customers / Orders / Products]
    B[Dataflow Gen2]
    C[Bronze Layer<br/>Fabric Lakehouse]
    D1[Silver Customers<br/>Dataflow Gen2]
    D2[Silver Orders<br/>PySpark Notebook]
    D3[Silver Products<br/>Dataflow Gen2]
    E[Gold Sales]
    F[Fabric Warehouse]
    G1[dim_customer]
    G2[dim_product]
    G3[dim_date]
    G4[fact_sales]
    H[SQL Analytics]
    I[Visualizations / Power BI]

    A --> B
    B --> C

    C --> D1
    C --> D2
    C --> D3

    D1 --> E
    D2 --> E
    D3 --> E

    E --> F

    F --> G1
    F --> G2
    F --> G3
    F --> G4

    G1 --> H
    G2 --> H
    G3 --> H
    G4 --> H

    H --> I
