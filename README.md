# Windham Valley Brew

Windham Valley Brew is a PL/SQL-based café order management system. It demonstrates the use of packages, procedures, functions, and cursors to handle order processing, menu management, and customer reporting in an Oracle database environment.

## Features
- Customer, menu, order, and order item management
- Add new menu items
- Create orders with random items and quantities
- Calculate customer total spend
- Identify top spenders and trending menu items
- Find the most profitable menu item
- Print customer spending reports

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