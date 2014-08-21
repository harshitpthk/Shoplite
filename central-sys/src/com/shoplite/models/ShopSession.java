package com.shoplite.models;

import java.util.GregorianCalendar;


public class ShopSession {
	
	private ShopUser shopUser;
	private String shopUrl;
	

	public ShopUser getShopUser() {
		return shopUser;
	}

	public void setShopUser(ShopUser shopUser) {
		this.shopUser = shopUser;
	}

	public String getShopUrl() {
		return shopUrl;
	}

	public void setShopUrl(String shopUrl) {
		this.shopUrl = shopUrl;
	}

	private long timeStamp;
	private long timeOut;
	
	public ShopSession(ShopUser shopUser, String shopUrl, long timeOut) {
		super();
		this.shopUser = shopUser;
		this.shopUrl = shopUrl;
		this.timeOut = timeOut;
		
		GregorianCalendar calendar = new GregorianCalendar();
		this.timeStamp = calendar.getTimeInMillis();

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
