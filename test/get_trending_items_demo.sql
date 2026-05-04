DECLARE
    v_cursor SYS_REFCURSOR;
    v_item_id menu_items.item_id%TYPE;
    v_item_name menu_items.item_name%TYPE;
    v_sold NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_trending_items;

    LOOP
        FETCH v_cursor INTO v_item_id, v_item_name, v_sold;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_item_name || ' sold: ' || v_sold
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