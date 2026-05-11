# Windham Valley Brew

Windham Valley Brew is a PL/SQL-based café order management system. It demonstrates the use of packages, procedures, functions, and cursors to handle order processing, menu management, and customer reporting in an Oracle database environment.

## Features
- **Customer, Menu, Order, and Order Item Management**: Full CRUD operations for managing café entities
- **Menu Item Addition**: Add new items to the menu with validation and exception handling
- **Order Creation**: Create orders with random item selection and quantities, including transaction management with savepoints and rollbacks
- **Customer Analytics**:
  - Calculate total spend for individual customers
  - Identify top 3 spenders
  - Determine favorite items for each customer
- **Menu Analytics**:
  - Identify trending (most popular) menu items
  - Find the most profitable menu item
- **Reporting**: Print comprehensive customer spending reports
- **Exception Handling**: Robust error handling with custom application errors and validation
- **Transaction Management**: Atomic operations with savepoints, commits, and rollbacks for data integrity

## 🎬 Demo

<video src="https://github.com/user-attachments/assets/a40b7fed-3ff2-4076-90fa-baad6216c465" width="600" height="400" controls></video>

## Technologies
- Oracle SQL / PL-SQL (tested on Oracle 19c+)

## Project Structure

```
setup/
    tables.sql         # Table definitions
    sequences.sql      # Sequence definitions
    sample_data.sql    # Sample data inserts
src/
    packages/
        cafe_pkg_spec.sql   # Package specification
        cafe_pkg_body.sql   # Package body (logic)
    procedures/
        print_customer_report.sql # Standalone reporting procedure
test/
    *.sql              # Demo scripts for testing features
```

## Setup Instructions

1. **Create the schema:**
     - Run the following scripts in order (from the `setup/` folder):
         1. `tables.sql`
         2. `sequences.sql`
         3. `sample_data.sql`

2. **Compile PL/SQL code:**
     - Compile the package:
         - `src/packages/cafe_pkg_spec.sql`
         - `src/packages/cafe_pkg_body.sql`
     - Compile the reporting procedure:
         - `src/procedures/print_customer_report.sql`

3. **Run demo/test scripts:**
     - Execute any `.sql` file in the `test/` folder to see features in action.

## Usage Examples

### Add a Menu Item
```sql
BEGIN
    cafe_pkg.add_menu_item('Bagel', 2.50);
END;
/ 
```

### Create an Order
```sql
BEGIN
    cafe_pkg.create_order(1); -- For customer_id 1
END;
/ 
```

### Get Customer Total Spend
```sql
SELECT cafe_pkg.get_customer_total(1) AS total_spent FROM dual;
```

### Get Top 3 Spenders
```sql
DECLARE
    v_cursor SYS_REFCURSOR;
    v_customer_id NUMBER;
    v_name VARCHAR2(100);
    v_total NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_top_spenders;
    LOOP
        FETCH v_cursor INTO v_customer_id, v_name, v_total;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ': $' || v_total);
    END LOOP;
    CLOSE v_cursor;
END;
/ 
```

### Get Trending Items (Most Popular)
```sql
DECLARE
    v_cursor SYS_REFCURSOR;
    v_item_id NUMBER;
    v_name VARCHAR2(100);
    v_sold NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_trending_items;
    LOOP
        FETCH v_cursor INTO v_item_id, v_name, v_sold;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ': ' || v_sold || ' sold');
    END LOOP;
    CLOSE v_cursor;
END;
/ 
```

### Get Most Profitable Item
```sql
DECLARE
    v_cursor SYS_REFCURSOR;
    v_item_id NUMBER;
    v_name VARCHAR2(100);
    v_revenue NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_most_profitable_items;
    LOOP
        FETCH v_cursor INTO v_item_id, v_name, v_revenue;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ': $' || v_revenue);
    END LOOP;
    CLOSE v_cursor;
END;
/ 
```

### Get Customer Favorite Items
```sql
DECLARE
    v_cursor SYS_REFCURSOR;
    v_customer_id NUMBER;
    v_item_id NUMBER;
    v_item_name VARCHAR2(100);
    v_quantity NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_customer_favorite_items;
    LOOP
        FETCH v_cursor INTO v_customer_id, v_item_id, v_item_name, v_quantity;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Customer ' || v_customer_id || ' favorite: ' || v_item_name || ' (' || v_quantity || ')');
    END LOOP;
    CLOSE v_cursor;
END;
/ 
```

### Print Customer Report
```sql
BEGIN
    print_customer_report;
END;
/ 
```

## Prerequisites
- Oracle Database 19c or newer
- SQL and PL/SQL
- Oracle SQL Developer



## License
MIT
