package com.shoplite.models;

import java.util.GregorianCalendar;
import java.util.TimeZone;


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
		calendar.setTimeZone(TimeZone.getTimeZone("GMT"));
		this.timeStamp = calendar.getTimeInMillis();

	}
	
	

	public boolean isSessionVallid()
	{
		GregorianCalendar calendar = new GregorianCalendar();
		calendar.setTimeZone(TimeZone.getTimeZone("GMT"));
		if(this.timeStamp+this.timeOut*1000 > calendar.getTimeInMillis())
		{
			return true;
		}else
			return false;
	}
	
}
