DECLARE
    v_cursor SYS_REFCURSOR;
    v_customer_id customers.customer_id%TYPE;
    v_item_id menu_items.item_id%TYPE;
    v_item_name menu_items.item_name%TYPE;
    v_qty NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_customer_favorite_items;

    LOOP
        FETCH v_cursor INTO v_customer_id, v_item_id, v_item_name, v_qty;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Customer ' || v_customer_id ||
            ' favorite: ' || v_item_name ||
            ' (' || v_qty || ')'
        );
    END LOOP;

    CLOSE v_cursor;

EXCEPTION
    WHEN OTHERS THEN
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
        RAISE;
END;
/