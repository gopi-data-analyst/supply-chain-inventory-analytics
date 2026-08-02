-- records in all tables

select 'products' AS table_name, count(*) as total_records from products
union all
select 'warehouses', count(*) from  warehouses
union all
select 'suppliers', count(*) from suppliers
union all
select 'inventory', count(*)  from  inventory
union all
select 'purchase_orders', count(*) from purchase_orders;

-- stock-out records

select count(*) AS total_stockout_records
from inventory
where closing_stock = 0;


describe inventory;

-- product and warehouse in inventory  when  closing stock equal to zero

select
    i.inventory_id,
    p.product_name,
    w.warehouse_location,
    i.inventory_date,
    i.opening_stock,
    i.quantity_received,
    i.quantity_sold,
    i.closing_stock
from  inventory i
join products p
    on i.product_id = p.product_id
join warehouses w
    on  i.warehouse_id = w.warehouse_id
where i.closing_stock = 0;


-- Average Closing Stock

select
    round(avg(closing_stock),2) as avg_closing_stock
from inventory;

-- Inventory Turnover Ratio

select
    round(
        sum(quantity_sold) /
        avg((opening_stock + closing_stock)/2),
        2
    ) as inventory_turnover_ratio
from inventory;

-- Reorder Point Breaches when closing falls to less than 20%

select
    inventory_id,
    product_id,
    warehouse_id,
    opening_stock,
    closing_stock,
    round(opening_stock * 0.20,2) as reorder_point
from inventory
where  closing_stock < (opening_stock * 0.20);


-- • Inventory Accuracy (system stock vs actual)

select
    inventory_id,
    opening_stock,
    quantity_received,
    quantity_sold,
    closing_stock,
    (opening_stock + quantity_received - quantity_sold) as  expected_stock
from  inventory
where closing_stock <>
      (opening_stock + quantity_received - quantity_sold);



--  Supplier On-Time Delivery Rate

select
    supplier_id,
    count(*) AS total_orders,
    sum(
        case
            when actual_delivery_date <= expected_delivery_date
            then 1
            else 0
        end
    ) as on_time_orders,
    round(
        sum(
            case
                when actual_delivery_date <= expected_delivery_date
                then 1
                else 0
            end
        ) * 100.0 / count(*),
    2) as on_time_delivery_rate
from purchase_orders
group by supplier_id
order by  on_time_delivery_rate desc;


--  Average Delivery Delay
select
    supplier_id,
    round(
        avg(
            case
                when actual_delivery_date > expected_delivery_date
                then datediff(actual_delivery_date, expected_delivery_date)
                else 0
            end
        ),
    2) as avg_delay_days
from purchase_orders
group by supplier_id
order by  avg_delay_days desc;


-- Supplier Lead Time Variability

select
    supplier_id,
    round(
        avg(datediff(actual_delivery_date, order_date)),
        2
    ) as avg_lead_time_days,
    round(
        stddev(datediff(actual_delivery_date, order_date)),
        2
    ) as lead_time_variability
from purchase_orders
group by supplier_id
order by lead_time_variability desc;


-- Order Fulfillment Accuracy

select
    supplier_id,
    count(*) as total_orders,
    count(actual_delivery_date) as delivered_orders,
    round(
        count(actual_delivery_date) * 100.0 /
        count(*),
        2
    ) as fulfillment_accuracy
from purchase_orders
group by supplier_id
order by fulfillment_accuracy desc;


--  Supplier Impact on Stock-Out Incidents


select
    po.supplier_id,
    s.supplier_name,
    count(*) as orders_for_stockout_products
from purchase_orders po
join suppliers s
    on po.supplier_id = s.supplier_id
where po.product_id in (
    select distinct product_id
    from inventory
    where closing_stock = 0
)
group by po.supplier_id, s.supplier_name
order by orders_for_stockout_products desc;


--   Warehouse Demand Pressure Index

select
    warehouse_id,
    sum(quantity_sold) as total_sold,
    sum(opening_stock + quantity_received) as total_available_inventory,
    round(
        sum(quantity_sold) * 1.0 /
        sum(opening_stock + quantity_received),
        2
    ) as demand_pressure_index
from inventory
group by warehouse_id
order by demand_pressure_index desc;


-- Stock Availability % per Warehouse

select
    w.warehouse_id,
    w.warehouse_location,
    count(*) as total_records,
    sum(
        case
            when i.closing_stock > 0 then 1
            else 0
        end
    ) as available_records,
    round(
        sum(
            case
                when i.closing_stock > 0 then 1
                else 0
            end
        ) * 100.0 / count(*),
        2
    ) as stock_availability_percent
from inventory i
join warehouses w
    on i.warehouse_id = w.warehouse_id
group by w.warehouse_id, w.warehouse_location
order by stock_availability_percent desc;


--  Warehouse Throughput (sales vs stock received)

select
    w.warehouse_id,
    w.warehouse_location,
    sum(i.quantity_sold) as total_quantity_sold,
    sum(i.quantity_received) as total_quantity_received,
    round(
        sum(i.quantity_sold) * 1.0 /
        nullif(sum(i.quantity_received), 0),
        2
    ) as warehouse_throughput
from inventory i
join warehouses w
    on i.warehouse_id = w.warehouse_id
group by w.warehouse_id, w.warehouse_location
order by warehouse_throughput desc;


--  Seasonal Demand Variation

select
    year(inventory_date) as sales_year,
    month(inventory_date) as sales_month,
    sum(quantity_sold) as total_sales
from inventory
group by
    year(inventory_date),
    month(inventory_date)
order by
    sales_year,
    sales_month;
    
    
    --  Fast-Moving vs Slow-Moving Items
    
    
    
select
    p.product_id,
    p.product_name,
    sum(i.quantity_sold) as total_units_sold
from products p
join inventory i
    on p.product_id = i.product_id
group by
    p.product_id,
    p.product_name
order by total_units_sold desc
limit 10;



--  Category Contribution to Revenue
select
    p.category,
    round(
        sum(i.quantity_sold * p.unit_price),
        2
    ) as category_revenue
from products p
join inventory i
    on p.product_id = i.product_id
group by p.category
order by category_revenue desc;


--  Profitability by Product

select
    p.product_id,
    p.product_name,
    round(avg(po.unit_cost), 2) as avg_unit_cost,
    p.unit_price,
    sum(i.quantity_sold) as total_units_sold,
    round(
        (p.unit_price - avg(po.unit_cost))
        * sum(i.quantity_sold),
        2
    ) as total_profit
from products p
join inventory i
    on p.product_id = i.product_id
join purchase_orders po
    on p.product_id = po.product_id
group by
    p.product_id,
    p.product_name,
    p.unit_price
order by total_profit desc;


--  Demand Stability Score

select
    p.product_id,
    p.product_name,
    round(avg(i.quantity_sold),2) as avg_demand,
    round(stddev(i.quantity_sold),2) as demand_stddev,
    round(
        stddev(i.quantity_sold) * 100.0 /
        avg(i.quantity_sold),
        2
    ) as demand_stability_score
from products p
join inventory i
on p.product_id = i.product_id
group by p.product_id, p.product_name
order by demand_stability_score;



-- cte example: total sales by product

with product_sales as (
    select
        product_id,
        sum(quantity_sold) as total_units_sold
    from inventory
    group by product_id
)
select
    p.product_name,
    ps.total_units_sold
from product_sales ps
join products p
    on ps.product_id = p.product_id
order by ps.total_units_sold desc;



-- window function example -- rank products by total sales

select
    p.product_id,
    p.product_name,
    sum(i.quantity_sold) as total_units_sold,
    rank() over (
        order by sum(i.quantity_sold) desc
    ) as sales_rank
from products p
join inventory i
    on p.product_id = i.product_id
group by p.product_id, p.product_name;







