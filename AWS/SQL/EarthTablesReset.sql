
DROP TABLE ORDERDETAILS CASCADE;
DROP TABLE ITEMSTOPACK CASCADE;
DROP TABLE PAYMENT CASCADE;
DROP TABLE ORDERS CASCADE;
DROP TABLE DELIVERY CASCADE;
DROP TABLE SHOPUSERS CASCADE;
DROP TABLE QUANTITY CASCADE;
DROP TABLE PRICE CASCADE;
DROP TABLE VARIANCE CASCADE;
DROP TABLE PRODUCT  CASCADE;
DROP TABLE CATEGORY  CASCADE;
DROP TABLE BRAND  CASCADE;
DROP TABLE SHOP CASCADE;
DROP TABLE OWNER CASCADE;
DROP TABLE AREA CASCADE;
DROP TABLE USER CASCADE;

/*User Table */
CREATE TABLE USER(
USER_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
USER_NAME VARCHAR(50), 
USER_E_MAIL VARCHAR(50) NOT NULL,
USER_PHNO VARCHAR(10) NOT NULL
);

/* Area table */

CREATE TABLE AREA(
AREA_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
AREA_NAME VARCHAR(50) NOT NULL,
AREA_DESCRIPTION VARCHAR(200)
);


/* Owner Table */
CREATE TABLE OWNER(
OWNER_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
OWNER_NAME VARCHAR(50), 
OWNER_E_MAIL VARCHAR(50) NOT NULL, 
OWNER_PHNO VARCHAR(10) NOT NULL, 
DEPOSIT FLOAT
);

/* Shop table  */
CREATE TABLE SHOP(
SHOP_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
SHOP_NAME VARCHAR(50), 
OWNER_ID INTEGER, 
AREA_ID INTEGER,
SHOP_LAT DOUBLE,
SHOP_LONG DOUBLE, 
FOREIGN KEY (OWNER_ID) REFERENCES OWNER(OWNER_ID) ON DELETE CASCADE,
FOREIGN KEY (AREA_ID) REFERENCES AREA(AREA_ID)
);


/*Brand Table */

CREATE TABLE BRAND (
BRAND_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
BRAND_NAME VARCHAR(200) NOT NULL,
BRAND_QR VARCHAR(400)
);
 

/*category tables  */
CREATE TABLE CATEGORY (
CATEGORY_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
CATEGORY_NAME VARCHAR(200) NOT NULL,
PARENT_CAT_ID INTEGER,
PRICE_UPDATE TINYINT(1)
);

/*Item category  */
CREATE TABLE PRODUCT (
PRODUCT_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
PRODUCT_NAME VARCHAR(200) NOT NULL,
PRODUCT_IMG VARCHAR(400),
PRODUCT_QR VARCHAR(400),
CATEGORY_ID INTEGER,
BRAND_ID INTEGER ,
PRICE_UPDATE TINYINT(1),
FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(CATEGORY_ID) ON DELETE CASCADE,
FOREIGN KEY (BRAND_ID) REFERENCES BRAND(BRAND_ID) ON DELETE CASCADE
);


/* VARIANCE table */
CREATE TABLE VARIANCE (
VARIANCE_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
VARIANCE_DESC VARCHAR(400),
PRODUCT_ID INTEGER,
VARIANCE_QR VARCHAR(400),
VARIANCE_BARCODE INTEGER,
VARIANCE_PRICE FLOAT,
FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID) ON DELETE CASCADE
);


/* price on basis of shop */
CREATE TABLE PRICE (
VARIANCE_ID INTEGER, 
SHOP_ID INTEGER,
PRICE FLOAT,
FOREIGN KEY (VARIANCE_ID) REFERENCES VARIANCE (VARIANCE_ID) ON DELETE CASCADE,
FOREIGN KEY (SHOP_ID) REFERENCES SHOP (SHOP_ID) ON DELETE CASCADE,
UNIQUE (VARIANCE_ID,SHOP_ID)
);


/* quantity on basis of shop */
CREATE TABLE QUANTITY (
VARIANCE_ID INTEGER, 
SHOP_ID INTEGER,
QUANTITY INTEGER,
FOREIGN KEY (VARIANCE_ID) REFERENCES VARIANCE (VARIANCE_ID) ON DELETE CASCADE,
FOREIGN KEY (SHOP_ID) REFERENCES SHOP (SHOP_ID) ON DELETE CASCADE,
UNIQUE (VARIANCE_ID,SHOP_ID)
);

CREATE TABLE SHOPUSERS(
USER_ID VARCHAR(200) NOT NULL,
CODE VARCHAR(200),
ROLE INTEGER,
SHOP_ID INTEGER, 
FOREIGN KEY (SHOP_ID) REFERENCES SHOP(SHOP_ID) ON DELETE CASCADE,
UNIQUE(USER_ID,SHOP_ID)
);


CREATE TABLE DELIVERY(
DELIVERY_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
USER_ID INTEGER,
ADDRESS VARCHAR (400),
USER_LAT FLOAT, 
USER_LONG FLOAT, 
FOREIGN KEY (USER_ID) REFERENCES USER (USER_ID) ON DELETE CASCADE
);


/* order table */
CREATE TABLE ORDERS (
ORDER_ID INTEGER AUTO_INCREMENT PRIMARY KEY, 
USER_ID INTEGER,
SHOP_ID INTEGER,
ORDER_AMOUNT FLOAT, 
ORDER_DATE TIMESTAMP,
STATUS TINYINT,
STATE TINYINT,
DELIVERY_ID INTEGER, /* delivery id is not compulsory so there is no need for reference key */
FOREIGN KEY (SHOP_ID) REFERENCES SHOP(SHOP_ID),
FOREIGN KEY (USER_ID) REFERENCES USER (USER_ID) ON DELETE CASCADE
);

/* payment table */
CREATE TABLE PAYMENT(
PAYMENT_ID INTEGER AUTO_INCREMENT PRIMARY KEY,
ORDER_ID INTEGER,
MODE INTEGER,
REFNO VARCHAR(30),
FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID)
);


/* order details */

CREATE TABLE ORDERDETAILS (
ORDER_ID INTEGER, 
VARIANCE_ID INTEGER,
QUANTITY INTEGER,
PRICE FLOAT,
FOREIGN KEY (VARIANCE_ID) REFERENCES VARIANCE (VARIANCE_ID),
FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID) ON DELETE CASCADE,
UNIQUE (ORDER_ID,VARIANCE_ID)
);

/* temp table to get product variances for shop admin */
CREATE TABLE ITEMSTOPACK (
ORDER_ID INTEGER, 
VARIANCE_ID INTEGER,
QUANTITY INTEGER,
SHOP_ID INTEGER,
FOREIGN KEY (VARIANCE_ID) REFERENCES VARIANCE (VARIANCE_ID) ON DELETE CASCADE,
FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ORDER_ID) ON DELETE CASCADE,
FOREIGN KEY (SHOP_ID) REFERENCES SHOP(SHOP_ID) ON DELETE CASCADE,
UNIQUE(ORDER_ID,VARIANCE_ID)
);