package com.shoplite.models;

import java.util.GregorianCalendar;

import com.shoplite.hub.statics.Constants;

public class ShopSession {
	
	private String userID;
	private int shopID;
	private Constants.ShopUserRole role;
	private String shopUrl;
	
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

	public String getShopUrl() {
		return shopUrl;
	}

	public void setShopUrl(String shopUrl) {
		this.shopUrl = shopUrl;
	}

	private long timeStamp;
	private long timeOut;
	
	public ShopSession(String userID, int shopID,int role, String shopUrl, long timeOut) {
		super();
		this.userID = userID;
		this.shopID = shopID;
		this.shopUrl = shopUrl;
		this.timeOut = timeOut;
		
		GregorianCalendar calendar = new GregorianCalendar();
		this.timeStamp = calendar.getTimeInMillis();
		
		switch(role)
		{
			case 0:
				this.role = Constants.ShopUserRole.ADMIN;
				break;
				
			case 1:
				this.role = Constants.ShopUserRole.MANAGER;
				break;
				
			case 2:
				this.role = Constants.ShopUserRole.CASHIER;
				break;
				
			case 3:
				this.role = Constants.ShopUserRole.PACKERS;
				break;
			
				
		}
	}
	
	public Constants.ShopUserRole getRole() {
		return role;
	}

	public void setRole(Constants.ShopUserRole role) {
		this.role = role;
	}

	public boolean isSessionVallid()
	{
		GregorianCalendar calendar = new GregorianCalendar();
		if(this.timeStamp+this.timeOut*1000 < calendar.getTimeInMillis())
		{
			return false;
		}else
			return true;
	}
	
}
