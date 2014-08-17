package com.shoplite.models;

import java.util.GregorianCalendar;

public class Session {
	private long timeStamp;
	private int user_id;
	private long timeOut;
	
	public Session(int user_id, long timeOut) {
		super();
		this.user_id = user_id;
		this.timeOut = timeOut;
		GregorianCalendar calendar = new GregorianCalendar();
		this.timeStamp = calendar.getTimeInMillis();
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
		GregorianCalendar calendar = new GregorianCalendar();
		if(this.timeStamp+this.timeOut >calendar.getTimeInMillis())
		{
			return false;
		}else
			return true;
	}

}