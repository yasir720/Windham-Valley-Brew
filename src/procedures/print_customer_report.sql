CREATE OR REPLACE PROCEDURE print_customer_report IS
    CURSOR c_customers IS
        SELECT customer_id, customer_name FROM customers;

    v_total NUMBER;
BEGIN
    FOR customer IN c_customers LOOP
        v_total := cafe_pkg.get_customer_total(customer.customer_id);

        DBMS_OUTPUT.PUT_LINE(
            customer.customer_name || ' spent: $' || v_total
        );
    END LOOP;
END;
/