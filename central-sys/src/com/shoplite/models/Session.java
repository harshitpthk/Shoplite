package com.shoplite.models;

import java.util.GregorianCalendar;
import java.util.TimeZone;

import com.shoplite.hub.statics.Util;

public class Session {
	private long timeStamp;
	private int user_id;
	private long timeOut;
	
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
		GregorianCalendar calendar = new GregorianCalendar();
		calendar.setTimeZone(TimeZone.getTimeZone("GMT"));
		if(this.timeStamp+this.timeOut*1000 > calendar.getTimeInMillis())
		{
			return true;
		}else
			return false;
	}

}
