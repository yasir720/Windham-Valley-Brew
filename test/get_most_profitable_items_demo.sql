DECLARE
    v_cursor SYS_REFCURSOR;
    v_item_id menu_items.item_id%TYPE;
    v_item_name menu_items.item_name%TYPE;
    v_revenue NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_most_profitable_items;

    LOOP
        FETCH v_cursor INTO v_item_id, v_item_name, v_revenue;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_item_name || ' revenue: ' || v_revenue
        );
    END LOOP;

    CLOSE v_cursor;
END;
/