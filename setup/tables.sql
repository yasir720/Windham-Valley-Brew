CREATE TABLE customers (
    customer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100)
);

CREATE TABLE menu_items (
    item_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100),
    price NUMBER(6,2)
);

CREATE TABLE orders (
    order_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE,
    total_amount NUMBER(8,2),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id NUMBER,
    item_id NUMBER,
    quantity NUMBER,
    order_total NUMBER(8,2),
    CONSTRAINT fk_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_item FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
);