SET SERVEROUTPUT ON

-- Expected output:
--   - Order created message for customer 1
--   - Menu item added message for Latte
--   - Duplicate item error for Coffee
--   - Audit report rows including the order insert, the menu item insert, and the duplicate error log
BEGIN
    cafe_pkg.create_order(1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CREATE_ORDER ERROR: ' || SQLERRM);
END;
/

BEGIN
    cafe_pkg.add_menu_item('Latte', 5.25);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ADD_MENU_ITEM ERROR: ' || SQLERRM);
END;
/

BEGIN
    cafe_pkg.add_menu_item('Coffee', 3.50);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ADD_MENU_ITEM DUPLICATE ERROR: ' || SQLERRM);
END;
/

BEGIN
    print_audit_report;
END;
/
