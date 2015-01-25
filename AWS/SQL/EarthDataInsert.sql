insert into AREA values(10000,'Whitefield','');
insert into OWNER values(10000,'Phani','srpkrishna@gmail.com','9886182129',10000);
insert into SHOP values(10000,'Star',10000,10000,12.7995079,77.7152518);
insert into SHOP values(10001,'Sawan',10000,10000,12.9853264,77.7103182);
insert into SHOP values(10002,'Sap Store',10000,10000,12.9794264,77.7158182);

insert into SHOPUSERS values('phani','shoplite',0,10000);
insert into SHOPUSERS values('phani','shoplite',0,10001);
insert into SHOPUSERS values('phani','shoplite',0,10002);

insert into CATEGORY values(10000,'Fruits',0,0);
insert into CATEGORY values(10001,'Vegatables',0,1);
insert into CATEGORY values(10002,'Grocery',0,1);
insert into CATEGORY values(10003,'Ready To Eat',0,1);
insert into CATEGORY values(10004,'Bevarages',0,1);
insert into CATEGORY values(10005,'Personal Care',0,0);
insert into CATEGORY values(10006,'House Hold',0,0);
insert into CATEGORY values(10007,'Dairy, Bread and Eggs',0,0);

insert into CATEGORY values(10009,'Bread',10007,1);
insert into CATEGORY values(10010,'Egg',10007,1);
insert into CATEGORY values(10008,'Biscults',10003,1);
insert into CATEGORY values(10011,'Choclates',10003,1);

insert into CATEGORY values(10012,'White Bread',10009,1);
insert into CATEGORY values(10013,'Brown Bread',10009,1);

insert into PRODUCT values(10000,'Dairy Milk','10000.png','10000.png',10011,NULL,0);
insert into PRODUCT values(10001,'Kit Kat','10000.png','10000.png',10011,NULL,0);
insert into PRODUCT values(10002,'5 Star','10000.png','10000.png',10011,NULL,1);
insert into PRODUCT values(10003,'Esclairs','10000.png','10000.png',10011,NULL,1);

insert into PRODUCT values(10004,'Apples','10000.png','10000.png',10000,NULL,1);
insert into PRODUCT values(10005,'Banana','10000.png','10000.png',10000,NULL,1);
insert into PRODUCT values(10006,'Oranges','10000.png','10000.png',10000,NULL,1);
insert into PRODUCT values(10007,'Pomogranites','10000.png','10000.png',10000,NULL,1);

insert into PRODUCT values(10008,'Suguna Eggs','10000.png','10000.png',10010,NULL,1);
insert into PRODUCT values(10009,'White Eggs','10000.png','10000.png',10010,NULL,1);
insert into PRODUCT values(10010,'Red Eggs','10000.png','10000.png',10010,NULL,1);

insert into VARIANCE values(1000,'5 gm 5 rs',10000,'10000.png',34534,10);
insert into VARIANCE values(1001,'10 gm 10 rs',10000,'10000.png',34536,12.34);
insert into VARIANCE values(1002,'25 gm 50 rs',10000,'10000.png',34535,13.45);

insert into VARIANCE values(1003,'5 gm 5 rs',10001,'10000.png',34534,12.3);
insert into VARIANCE values(1004,'15 gm 15 rs',10001,'10000.png',34434,45.34);
insert into VARIANCE values(1005,'25 gm 5 rs',10001,'10000.png',33534,34.5);


insert into VARIANCE values(1006,'250 gm',10004,'10000.png',34534,12);
insert into VARIANCE values(1007,'500 gm',10004,'10000.png',34536,13);
insert into VARIANCE values(1008,'1000 gm',10004,'10000.png',34535,24);

insert into VARIANCE values(1009,'250 gm',10005,'10000.png',34534,23);
insert into VARIANCE values(1010,'500 gm',10005,'10000.png',34536,56);
insert into VARIANCE values(1011,'1000 gm',10005,'10000.png',34535,65);

insert into VARIANCE values(1012,'250 gm',10006,'10000.png',34534,11);
insert into VARIANCE values(1013,'500 gm',10006,'10000.png',34536,1345);
insert into VARIANCE values(1014,'1000 gm',10006,'10000.png',34535,434);

insert into VARIANCE values(1015,'pack of 6',10007,'10000.png',34534,123);
insert into VARIANCE values(1016,'pack of 6',10008,'10000.png',34536,12.45);
insert into VARIANCE values(1017,'pack of 6',10009,'10000.png',34535,999);


insert into QUANTITY values(1000,10000,10);
insert into QUANTITY values(1001,10000,2);
insert into QUANTITY values(1002,10000,2);
insert into QUANTITY values(1003,10000,5);
insert into QUANTITY values(1004,10000,2);
insert into QUANTITY values(1005,10000,26);
insert into QUANTITY values(1006,10000,1);
insert into QUANTITY values(1007,10000,2);
insert into QUANTITY values(1008,10000,6);

insert into QUANTITY values(1009,10000,1);
insert into QUANTITY values(1010,10000,2);
insert into QUANTITY values(1011,10000,2);

insert into QUANTITY values(1012,10000,2);
insert into QUANTITY values(1013,10000,32);
insert into QUANTITY values(1014,10000,7);

insert into QUANTITY values(1015,10000,4);
insert into QUANTITY values(1016,10000,8);
insert into QUANTITY values(1017,10000,12);

insert into PRICE values(1000,10000,12);
insert into PRICE values(1001,10000,12);
insert into PRICE values(1002,10000,13.45);

insert into PRICE values(1003,10000,12);
insert into PRICE values(1004,10000,32.56);
insert into PRICE values(1005,10000,42.45);


insert into PRICE values(1006,10000,12.5);
insert into PRICE values(1007,10000,34);
insert into PRICE values(1008,10000,45);

insert into PRICE values(1009,10000,12);
insert into PRICE values(1010,10000,36);
insert into PRICE values(1011,10000,45);

insert into PRICE values(1012,10000,1);
insert into PRICE values(1013,10000,22);
insert into PRICE values(1014,10000,23);

insert into PRICE values(1015,10000,12);
insert into PRICE values(1016,10000,45);
insert into PRICE values(1017,10000,23);


insert into QUANTITY values(1000,10001,10);
insert into QUANTITY values(1001,10001,2);
insert into QUANTITY values(1002,10001,2);
insert into QUANTITY values(1003,10001,5);
insert into QUANTITY values(1004,10001,2);
insert into QUANTITY values(1005,10001,26);
insert into QUANTITY values(1006,10001,1);
insert into QUANTITY values(1007,10001,2);
insert into QUANTITY values(1008,10001,6);

insert into QUANTITY values(1009,10001,1);
insert into QUANTITY values(1010,10001,2);
insert into QUANTITY values(1011,10001,2);

insert into QUANTITY values(1012,10001,2);
insert into QUANTITY values(1013,10001,32);
insert into QUANTITY values(1014,10001,7);

insert into QUANTITY values(1015,10001,4);
insert into QUANTITY values(1016,10001,8);
insert into QUANTITY values(1017,10001,12);

insert into PRICE values(1000,10001,12);
insert into PRICE values(1001,10001,12);
insert into PRICE values(1002,10001,13.45);

insert into PRICE values(1003,10001,12);
insert into PRICE values(1004,10001,32.56);
insert into PRICE values(1005,10001,42.45);


insert into PRICE values(1006,10001,12.5);
insert into PRICE values(1007,10001,34);
insert into PRICE values(1008,10001,45);

insert into PRICE values(1009,10001,12);
insert into PRICE values(1010,10001,36);
insert into PRICE values(1011,10001,45);

insert into PRICE values(1012,10001,1);
insert into PRICE values(1013,10001,22);
insert into PRICE values(1014,10001,23);

insert into PRICE values(1015,10001,12);
insert into PRICE values(1016,10001,45);
insert into PRICE values(1017,10001,23);


insert into QUANTITY values(1000,10002,10);
insert into QUANTITY values(1001,10002,2);
insert into QUANTITY values(1002,10002,2);
insert into QUANTITY values(1003,10002,5);
insert into QUANTITY values(1004,10002,2);
insert into QUANTITY values(1005,10002,26);
insert into QUANTITY values(1006,10002,1);
insert into QUANTITY values(1007,10002,2);
insert into QUANTITY values(1008,10002,6);

insert into QUANTITY values(1009,10002,1);
insert into QUANTITY values(1010,10002,2);
insert into QUANTITY values(1011,10002,2);

insert into QUANTITY values(1012,10002,2);
insert into QUANTITY values(1013,10002,32);
insert into QUANTITY values(1014,10002,7);

insert into QUANTITY values(1015,10002,4);
insert into QUANTITY values(1016,10002,8);
insert into QUANTITY values(1017,10002,12);

insert into PRICE values(1000,10002,12);
insert into PRICE values(1001,10002,12);
insert into PRICE values(1002,10002,13.45);

insert into PRICE values(1003,10002,12);
insert into PRICE values(1004,10002,32.56);
insert into PRICE values(1005,10002,42.45);


insert into PRICE values(1006,10002,12.5);
insert into PRICE values(1007,10002,34);
insert into PRICE values(1008,10002,45);

insert into PRICE values(1009,10002,12);
insert into PRICE values(1010,10002,36);
insert into PRICE values(1011,10002,45);

insert into PRICE values(1012,10002,1);
insert into PRICE values(1013,10002,22);
insert into PRICE values(1014,10002,23);

insert into PRICE values(1015,10002,12);
insert into PRICE values(1016,10002,45);
insert into PRICE values(1017,10002,23);
