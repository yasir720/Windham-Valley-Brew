DECLARE
    v_cursor SYS_REFCURSOR;
    v_id customers.customer_id%TYPE;
    v_name customers.customer_name%TYPE;
    v_total NUMBER;
BEGIN
    v_cursor := cafe_pkg.get_top_spenders;

    LOOP
        FETCH v_cursor INTO v_id, v_name, v_total;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_name || ' spent: ' || v_total
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