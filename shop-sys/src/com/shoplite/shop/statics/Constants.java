package com.shoplite.shop.statics;

public class Constants {
	
	public enum DBState {INSERT,UPDATE,DELETE};
	
	public enum ORDERState {INITIAL,FORPAYMENT,FORHOMEDELIVERY,FORDELIVERY,CLOSED};
	
	public enum PAYMENTMode {CASH,ONLINE,SWIPE};
	
	public enum ShopUserRole {ADMIN,MANAGER,CASHIER,PACKER};
}
