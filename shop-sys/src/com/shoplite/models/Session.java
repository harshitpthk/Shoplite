package com.shoplite.models;


import com.shoplite.shop.statics.Util;

public class Session {
	private long timeStamp;
	private int user_id;
	private long timeOut;
	private int userOrderId;
	
	public Session(int user_id, long timeOut) {
		super();
		this.user_id = user_id;
		this.timeOut = timeOut;
		this.timeStamp = Util.calendar.getTimeInMillis();
	}
	public int getUserId() {
		return user_id;
	}
//	public void setUser(User user) {
//		this.user = user;
//	}
//	public long getTimeOut() {
//		return timeOut;
//	}
//	public void setTimeOut(long timeOut) {
//		this.timeOut = timeOut;
//	}
	
	public boolean isSessionVallid()
	{
		if(this.timeStamp+this.timeOut >  Util.calendar.getTimeInMillis())
		{
			return true;
		}else
			return false;
	}
	public int getUserOrderId() {
		return userOrderId;
	}
	public void setUserOrderId(int userOrderId) {
		this.userOrderId = userOrderId;
	}

}
