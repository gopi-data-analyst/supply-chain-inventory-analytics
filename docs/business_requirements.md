Business Insights and Recommendations

The project uses SQL joins, aggregation functions, filtering conditions, Common Table Expressions (CTEs), and window functions. A CTE was used to calculate total sales by product, while a window function was used to rank products based on sales performance.

Executive Summary

The purpose of this project was to analyse inventory, supplier performance, warehouse operations, and stock-out issues using SQL. The database contains information about products, warehouses, suppliers, inventory records, and purchase orders.

The analysis showed that the company is managing its inventory quite well. Only a few stock-out incidents were found, and inventory records were highly accurate. However, some products and suppliers require more attention to avoid future inventory shortages.

 Key Findings

Stock-Out Analysis

The analysis found only 3 stock-out incidents in the inventory data. Product_17 experienced two stock-outs, while Product_8 experienced one stock-out. These stock-outs occurred because all available stock was sold, leaving no remaining inventory.

This shows that demand for these products was high and there was no safety stock available after sales.


Stock_out Duration

Stock-out duration measures how long a product remains unavailable after inventory reaches zero. In this dataset, only three stock-out incidents were identified, and none occurred continuously over multiple days. This indicates that inventory was replenished quickly and products were made available again without significant delays

Inventory Accuracy

Inventory accuracy was found to be 100%. The recorded closing stock matched the expected stock calculated from opening stock, received quantity, and sold quantity.

This indicates that inventory records are reliable and can be used for decision-making.

Inventory Levels

The average closing stock was 187.28 units. This suggests that the company generally maintains sufficient inventory levels to meet customer demand.

Although inventory levels are healthy, some products may still require additional safety stock during high-demand periods.

Supplier Performance

Supplier performance varied across the dataset. Some suppliers had delivery delays and inconsistent lead times, which can affect inventory availability. Suppliers with high lead time variability make inventory planning more difficult and may increase the risk of stock shortages.

Warehouse Performance

Most warehouses maintained good stock availability throughout the analysis period. However, some warehouses experienced higher demand pressure than others.

Warehouses with high demand should receive inventory more frequently to avoid stock shortages.

Product Demand

The analysis identified both fast-moving and slow-moving products. Fast-moving products generate higher sales and require frequent replenishment. Slow-moving products remain in storage for longer periods and may increase inventory holding costs.

Understanding product demand patterns helps improve inventory planning.

Operational Challenges

The following challenges were identified during the analysis:

1. Delivery delays from some suppliers.
2. High demand for specific products.
3. Lack of safety stock for certain fast-moving products.
4. Uneven demand across warehouses.

Recommendations

Recommendation 1

Increase safety stock levels for fast-moving products such as Product_17 and Product_8.

Recommendation 2

Implement automatic reorder alerts when stock levels become low.

 Recommendation 3

Regularly monitor supplier performance and reduce dependency on suppliers with frequent delays.

Recommendation 4

Distribute inventory based on warehouse demand to improve stock availability.

Recommendation 5

Reduce inventory levels for slow-moving products to lower storage costs.

Recommendation 6

Use historical sales data to improve demand forecasting and inventory planning.

Conclusion:-

The supply chain analysis showed that the company maintains good inventory control and accurate stock records. Only a few stock-out incidents were identified, which suggests that inventory management practices are generally effective. However, improvements in supplier performance, safety stock planning, and demand forecasting can further reduce inventory risks and improve overall supply chain efficiency.

