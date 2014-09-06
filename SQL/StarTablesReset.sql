/*User Table */

DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.USER CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.USER(
"USER_ID" INTEGER PRIMARY KEY, 
"USER_NAME" VARCHAR(50), 
"USER_E_MAIL" VARCHAR(50) NOT NULL, 
"USER_GENDER" VARCHAR(10),
"USER_PHNO" VARCHAR(10) NOT NULL,
"USER_LAT" DOUBLE, 
"USER_LONG" DOUBLE 


);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.USER_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.USER_SEQ START WITH 10000;

/* Area table */


DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA(
"AREA_ID" INTEGER PRIMARY KEY, 
"AREA_NAME" VARCHAR(50) NOT NULL,
"AREA_DESCRIPTION" VARCHAR(200)
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA_SEQ START WITH 10000;

/* Owner Table */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.OWNER CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.OWNER(
"OWNER_ID" INTEGER PRIMARY KEY, 
"OWNER_NAME" VARCHAR(50), 
"OWNER_E_MAIL" VARCHAR(50) NOT NULL, 
"OWNER_PHNO" VARCHAR(10) NOT NULL, 
"DEPOSIT" DECIMAL(10,2) 

);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.OWNER_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.OWNER_SEQ START WITH 10000;


/* Shop table  */

DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP(
"SHOP_ID" INTEGER PRIMARY KEY, 
"SHOP_NAME" VARCHAR(50), 
"OWNER_ID" INTEGER, 
"AREA_ID" INTEGER,
"SHOP_LAT" DOUBLE,
"SHOP_LONG" DOUBLE, 
"URL" VARCHAR(100), 
FOREIGN KEY (OWNER_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.OWNER ON DELETE CASCADE,
FOREIGN KEY (AREA_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP_SEQ START WITH 10000;

/*Brand Table */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.BRAND  CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.BRAND (
"BRAND_ID" INTEGER PRIMARY KEY, 
"BRAND_NAME" VARCHAR(200) NOT NULL,
"BRAND_QR" VARCHAR(400)
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.BRAND_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.BRAND_SEQ START WITH 10000;
 

/*category tables  */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.CATEGORY  CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.CATEGORY (
"CATEGORY_ID" INTEGER PRIMARY KEY, 
"CATEGORY_NAME" VARCHAR(200) NOT NULL,
"PARENT_CAT_ID" INTEGER,
"PRICE_UPDATE" INTEGER,
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.CATEGORY_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.CATEGORY_SEQ START WITH 10000;

/*Item category  */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_CATEGORY  CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_CATEGORY (
"ITEM_CATEGORY_ID" INTEGER PRIMARY KEY, 
"ITEM_CATEGORY_NAME" VARCHAR(200) NOT NULL,
"ITEM_CATEGORY_IMG" VARCHAR(400),
"ITEM_QR" VARCHAR(400),
"CATEGORY_ID" INTEGER,
"BRAND_ID" INTEGER , 
"LAST_UPDATED" TIMESTAMP,
"PRICE_UPDATE" INTEGER,
FOREIGN KEY (CATEGORY_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.CATEGORY ON DELETE CASCADE,
FOREIGN KEY (BRAND_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.BRAND ON DELETE CASCADE
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_CATEGORY_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_CATEGORY_SEQ START WITH 10000;

/* item table */

DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM(
"ITEM_ID" INTEGER PRIMARY KEY, 
"ITEM_DESC" VARCHAR(400),
"ITEM_CATEGORY_ID" INTEGER,
"ITEM_QR" VARCHAR(400),
"ITEM_BARCODE" BIGINT,
"ITEM_PRICE" DECIMAL(10,2),
FOREIGN KEY (ITEM_CATEGORY_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_CATEGORY ON DELETE CASCADE
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM_SEQ START WITH 10000;


/* price on basis of area */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.PRICE CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.PRICE(
"ITEM_ID" INTEGER PRIMARY KEY, 
"AREA_ID" VARCHAR(400),
"PRICE" DECIMAL(10,2),
FOREIGN KEY (ITEM_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM ON DELETE CASCADE,
FOREIGN KEY (AREA_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.AREA ON DELETE CASCADE,
UNIQUE (ITEM_ID,AREA_ID)
);


/* order table */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDERS CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDERS(
"ORDER_ID" INTEGER PRIMARY KEY, 
"USER_ID" INTEGER, 
"SHOP_ID" INTEGER, 
"ORDER_AMOUNT" INTEGER, 
"ORDER_DATE" TIMESTAMP,
FOREIGN KEY (USER_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.USER ON DELETE CASCADE,
FOREIGN KEY (SHOP_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP ON DELETE CASCADE
);

DROP SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDER_SEQ;
CREATE SEQUENCE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDER_SEQ START WITH 10000;

/* order details */
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDER_DETAILS CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDER_DETAILS(
"ORDER_ID" INTEGER, 
"ITEM_ID" VARCHAR(400),
"PRICE" DECIMAL(10,2),
"QUANTITY" INTEGER,
FOREIGN KEY (ITEM_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.ITEM,
FOREIGN KEY (ORDER_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.ORDERS ON DELETE CASCADE
);

/*Dictionary for temp storage*/
DROP TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOPUSERS CASCADE;
CREATE TABLE NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOPUSERS(
"USER_ID" VARCHAR(200) NOT NULL,
"CODE" VARCHAR(200),
"ROLE" INTEGER,
"SHOP_ID" INTEGER, 
FOREIGN KEY (SHOP_ID) REFERENCES NEO_87674ORGRZW3IPL9DNL9Z03J4.SHOP ON DELETE CASCADE,
UNIQUE(USER_ID,SHOP_ID)
);
