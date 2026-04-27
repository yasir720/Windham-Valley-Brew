CREATE OR REPLACE PACKAGE BODY cafe_pkg AS
    -- Procedures:
    -- Procedure to create a new order for a customer
    PROCEDURE create_order(p_customer_id NUMBER) IS
        v_dummy NUMBER;
        v_order_id NUMBER;
        v_total NUMBER := 0;
        v_item_qty NUMBER;
    BEGIN
        -- Validate customer exists
        BEGIN
            SELECT 1
            INTO v_dummy
            FROM customers
            WHERE customer_id = p_customer_id;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'Invalid customer');
        END;

        -- Start transaction with savepoint
        SAVEPOINT order_start;

        -- Create new order using sequence for order_id
        v_order_id := order_seq.NEXTVAL;

        INSERT INTO orders (order_id, customer_id, order_date, order_total_amount)
        VALUES (v_order_id, p_customer_id, SYSDATE, 0);

        -- Add all menu items with random quantity (1 to 5)
        FOR item IN (SELECT item_id, item_price FROM menu_items) LOOP
            -- Randomly determine how many of each item to add to the order (1 to 5)
            v_item_qty := TRUNC(DBMS_RANDOM.VALUE(1, 6));
            INSERT INTO order_items (order_item_id, order_id, item_id, quantity, line_total)
            VALUES (
                order_item_seq.NEXTVAL,
                v_order_id,
                item.item_id,
                v_item_qty,
                v_item_qty * item.item_price
            );

            v_total := v_total + (v_item_qty * item.item_price);
        END LOOP;

        -- Update order total
        UPDATE orders
        SET order_total_amount = v_total
        WHERE order_id = v_order_id;

        -- Commit transaction if all inserts succeed
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Order created: ' || v_order_id);

    EXCEPTION
        -- Rollback to savepoint on any error
        WHEN OTHERS THEN
            ROLLBACK TO order_start;
            RAISE_APPLICATION_ERROR(-20003, 'Failed to create order: ' || SQLERRM);
    END;

    -- Procedure to add item to a menu
    PROCEDURE add_menu_item (p_item_name  IN VARCHAR2, p_item_price IN NUMBER) IS
    BEGIN
        INSERT INTO menu_items (
            item_id,
            item_name,
            item_price
        )
        VALUES (
            menu_item_seq.NEXTVAL,
            p_item_name,
            p_item_price
        );

        DBMS_OUTPUT.PUT_LINE('Menu item added: ' || p_item_name);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20002, 'Item already exists');
        WHEN OTHERS THEN
            RAISE;
    END;

    -- Functions:
    -- Function to get total spend for specific customer
    FUNCTION get_customer_total(p_customer_id NUMBER)
    RETURN NUMBER IS
        v_customer_total NUMBER;
    BEGIN
        SELECT NVL(SUM(order_total_amount), 0) -- Use NVL to return 0 if the customer has no orders
        INTO v_customer_total
        FROM orders
        WHERE customer_id = p_customer_id;

        RETURN v_customer_total;
    END;

    -- Function to return the top 3 spenders at the café
    FUNCTION get_top_spenders
    RETURN SYS_REFCURSOR IS -- Return multiple rows using a ref cursor
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT
                c.customer_id,
                c.customer_name,
                SUM(o.order_total_amount) AS total_spent
            FROM customers c
            JOIN orders o
                ON c.customer_id = o.customer_id
            GROUP BY c.customer_id, c.customer_name
            ORDER BY total_spent DESC
            FETCH FIRST 3 ROWS ONLY;

        RETURN v_cursor;
    END;

    -- Function to return the 3 most popular items at the café
    FUNCTION get_trending_items
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT
                m.item_id,
                m.item_name,
                SUM(oi.quantity) AS total_sold
            FROM menu_items m
            JOIN order_items oi
                ON m.item_id = oi.item_id
            GROUP BY m.item_id, m.item_name
            ORDER BY total_sold DESC
            FETCH FIRST 3 ROWS ONLY;

        RETURN v_cursor;
    END;

    -- Function to return the most profitable item at the café
    FUNCTION get_most_profitable_items
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            WITH item_revenue AS (
                SELECT
                    m.item_id,
                    m.item_name,
                    SUM(oi.line_total) AS total_revenue
                FROM menu_items m
                JOIN order_items oi
                    ON m.item_id = oi.item_id
                GROUP BY m.item_id, m.item_name
            ),
            ranked_items AS (
                SELECT
                    item_id,
                    item_name,
                    total_revenue,
                    RANK() OVER (ORDER BY total_revenue DESC) AS ranked_item_revenue
                FROM item_revenue
            )
            SELECT
                item_id,
                item_name,
                total_revenue
            FROM ranked_items
            WHERE ranked_item_revenue = 1;

        RETURN v_cursor;
    END;

    -- Function to return the favorite item for each customer
    FUNCTION get_customer_favorite_items
    RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            WITH item_counts AS (
                SELECT
                    o.customer_id,
                    oi.item_id,
                    m.item_name,
                    SUM(oi.quantity) AS total_quantity
                FROM orders o
                JOIN order_items oi
                    ON o.order_id = oi.order_id
                JOIN menu_items m
                    ON oi.item_id = m.item_id
                GROUP BY o.customer_id, oi.item_id, m.item_name
            ),
            ranked_items AS (
                SELECT
                    customer_id,
                    item_id,
                    item_name,
                    total_quantity,
                    ROW_NUMBER() OVER (
                        PARTITION BY customer_id
                        ORDER BY total_quantity DESC
                    ) AS rnk
                FROM item_counts
            )
            SELECT
                customer_id,
                item_id,
                item_name,
                total_quantity
            FROM ranked_items
            WHERE rnk = 1;

        RETURN v_cursor;
    END;

END cafe_pkg;
/