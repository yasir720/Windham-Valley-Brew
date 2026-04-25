CREATE OR REPLACE PACKAGE cafe_pkg AS
    -- Procedures
    -- Standard order creation procedure
    PROCEDURE create_order(p_customer_id NUMBER);

    -- Procedure to add item to a menu
    PROCEDURE add_menu_item (
        p_item_name IN VARCHAR2,
        p_item_price IN NUMBER
    );

    -- Functions
    -- Function to get total spend for one specific customer
    FUNCTION get_customer_total(p_customer_id NUMBER) RETURN NUMBER;

    -- Function to return the top 3 spenders at the café
    FUNCTION get_top_spenders RETURN SYS_REFCURSOR;

    -- Function to return the 3 most popular items at the café
    FUNCTION get_trending_items RETURN SYS_REFCURSOR;

    -- Function to return the most profitable item at the café
    FUNCTION get_most_profitable_items RETURN SYS_REFCURSOR;

    -- Function to return the favorite item for each customer
    FUNCTION get_customer_favorite_items RETURN SYS_REFCURSOR;
END cafe_pkg;
/