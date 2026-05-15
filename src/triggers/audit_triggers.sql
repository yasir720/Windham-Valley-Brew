CREATE OR REPLACE TRIGGER trg_orders_audit
AFTER INSERT OR UPDATE OR DELETE
ON orders
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        audit_pkg.log_audit_entry(
            'AUDIT',
            'ORDER',
            :NEW.order_id,
            'INSERT',
            'Order created for customer ' || :NEW.customer_id || ' total=' || :NEW.order_total_amount,
            NULL,
            NULL,
            'TRG_ORDERS_AUDIT'
        );
    ELSIF UPDATING THEN
        audit_pkg.log_audit_entry(
            'AUDIT',
            'ORDER',
            :NEW.order_id,
            'UPDATE',
            'Order updated from total ' || NVL(TO_CHAR(:OLD.order_total_amount), 'NULL') ||
                ' to ' || NVL(TO_CHAR(:NEW.order_total_amount), 'NULL'),
            NULL,
            NULL,
            'TRG_ORDERS_AUDIT'
        );
    ELSE
        audit_pkg.log_audit_entry(
            'AUDIT',
            'ORDER',
            :OLD.order_id,
            'DELETE',
            'Order deleted for customer ' || :OLD.customer_id || ' total=' || :OLD.order_total_amount,
            NULL,
            NULL,
            'TRG_ORDERS_AUDIT'
        );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_menu_items_audit
AFTER INSERT
ON menu_items
FOR EACH ROW
BEGIN
    audit_pkg.log_audit_entry(
        'AUDIT',
        'MENU_ITEM',
        :NEW.item_id,
        'INSERT',
        'Menu item added: ' || :NEW.item_name || ' price=' || :NEW.item_price,
        NULL,
        NULL,
        'TRG_MENU_ITEMS_AUDIT'
    );
END;
/
