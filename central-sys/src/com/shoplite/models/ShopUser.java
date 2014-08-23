package com.shoplite.models;

import com.shoplite.hub.statics.Constants;

public class ShopUser
{
	private String userID;
	private int shopID;
	private Constants.ShopUserRole role;
	private String code;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getShopID() {
		return shopID;
	}
	public void setShopID(int shopID) {
		this.shopID = shopID;
	}
	public Constants.ShopUserRole getRole() {
		return role;
	}
	public void setRole(int role) {
		
		switch(role)
		{
			case 0:
				this.role = Constants.ShopUserRole.ADMIN;
				break;
				
			case 1:
				this.role = Constants.ShopUserRole.MANAGER;
				break;
				
			case 2:
				this.role =  Constants.ShopUserRole.CASHIER;
				break;
				
			case 3:
				this.role =  Constants.ShopUserRole.PACKER;
				break;
		}
	}
	
	public ShopUser(String userID, int shopID, int role) {
		super();
		this.userID = userID;
		this.shopID = shopID;
		this.setRole(role);
		
	}
	
	public ShopUser(String userID, int role) {
		super();
		this.userID = userID;
		this.setRole(role);
	}
	
	
	
}
