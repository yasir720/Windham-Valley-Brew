CREATE SEQUENCE order_seq START WITH 1;
CREATE SEQUENCE order_item_seq START WITH 1;
-- The menu_item_seq is used in the add_menu_item procedure to generate new
-- item ids, so it starts with 7 since we have 6 initial items.
CREATE SEQUENCE menu_item_seq START WITH 7;
CREATE SEQUENCE audit_seq START WITH 1;