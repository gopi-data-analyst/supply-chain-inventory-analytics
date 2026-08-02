create database supply_chain_stockout_db;
use supply_chain_stockout_db;

#products table

create table products (
    product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    unit_price decimal(10,2)
);

 # warehouses table
 
 create table warehouses (
    warehouse_id int primary key,
    warehouse_location varchar(100)
);

# suppliers table

create table suppliers (
    supplier_id int primary key,
    supplier_name varchar(100),
    on_time_delivery_rate decimal(5,2)
);


# inventory table

create table inventory (
    inventory_id int primary key,
    product_id int,
    warehouse_id int,
    inventory_date date,
    opening_stock int,
    quantity_received int,
    quantity_sold int,
    closing_stock int,
    foreign key (product_id)
    references products(product_id),
    foreign key (warehouse_id)
    references warehouses(warehouse_id)
);

# purchase_orders

create table purchase_orders (
    order_id int primary key,
    product_id int,
    supplier_id int,
    order_date date,
    expected_delivery_date date,
    actual_delivery_date date,
    order_quantity int,
    unit_cost decimal(10,2),
    foreign key (product_id)
    references products(product_id),
    foreign key (supplier_id)
    references suppliers(supplier_id)
);
