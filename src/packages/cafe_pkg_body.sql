CREATE OR REPLACE PACKAGE BODY cafe_pkg AS

    PROCEDURE create_order(p_customer_id NUMBER) IS
        v_count NUMBER;
        v_order_id NUMBER;
        v_total NUMBER := 0;
        v_item_qty NUMBER;
    BEGIN
       SELECT COUNT(*) INTO v_count
        FROM customers
        WHERE customer_id = p_customer_id;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid customer');
        END IF;

        -- Create new order using sequence for order_id
        v_order_id := order_seq.NEXTVAL;

        INSERT INTO orders (order_id, customer_id, order_date, total_amount)
        VALUES (v_order_id, p_customer_id, SYSDATE, 0);

        

        -- Add all menu items with random quantity (1 to 5)
        FOR item IN (SELECT item_id, price FROM menu_items) LOOP
            -- Randomly determine how many of each item to add to the order (1 to 5)
            v_item_qty := TRUNC(DBMS_RANDOM.VALUE(1, 6));
            INSERT INTO order_items
            VALUES (
                order_item_seq.NEXTVAL,
                v_order_id,
                item.item_id,
                v_item_qty,
                item.price
            );

            v_total := v_total + (v_item_qty * item.price);
        END LOOP;

        UPDATE orders
        SET total_amount = v_total
        WHERE order_id = v_order_id;

        DBMS_OUTPUT.PUT_LINE('Order created: ' || v_order_id);

    END;

END cafe_pkg;
/