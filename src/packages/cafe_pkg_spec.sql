CREATE OR REPLACE PACKAGE cafe_pkg AS
    -- Standard order creation procedure
    PROCEDURE create_order(p_customer_id NUMBER);

    -- Function to get total spend for one specific customer
    FUNCTION get_customer_total(p_customer_id NUMBER) RETURN NUMBER;

    -- Function to return the top 3 spenders at the cafe
    FUNCTION get_top_spenders RETURN SYS_REFCURSOR;

    -- Function to return the 3 most popular items at the cafe
    FUNCTION get_trending_items RETURN SYS_REFCURSOR;

    -- Function to return the most profitable item at the cafe
    FUNCTION get_most_profitable_items RETURN SYS_REFCURSOR;
END cafe_pkg;
/
