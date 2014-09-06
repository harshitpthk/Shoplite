package com.shoplite.models;


import com.shoplite.hub.statics.Util;


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
		
		this.timeStamp = Util.calendar.getTimeInMillis();

	}
	
	

	public boolean isSessionVallid()
	{
		if(this.timeStamp+this.timeOut*1000 > Util.calendar.getTimeInMillis())
		{
			return true;
		}else
			return false;
	}
	
}
