package com.shoplite.hub.test;

import java.net.HttpURLConnection;
import java.util.GregorianCalendar;

import com.shoplite.models.Util;

public class LoginTest implements TestInterface {

	public String key="";
	@Override
	public String getServiceName() {
		// TODO Auto-generated method stub
		return "login";
	}

	@Override
	public String getMethodType() {
		// TODO Auto-generated method stub
		return "POST";
	}

	@Override
	public String getPostObject() {
		// TODO Auto-generated method stub
		return "srpkrishna@gmail.com";
	}

	@Override
	public void writeHeaders(HttpURLConnection conn) {
		// TODO Auto-generated method stub
		GregorianCalendar calendar = new GregorianCalendar();
		long time = calendar.getTimeInMillis();
		
		int factor = (int)time/(63000);
		
		String seed = Util.generateSeed((long)factor,8);
		String authKey = key+seed;
		String authcode="";
		try {
			authcode = Util.encrypt(authKey);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("time "+ time);
		System.out.println("factor "+ factor);
		System.out.println("key "+ key);
		System.out.println("seed "+ seed);
		System.out.println("authcode "+ authcode);
		conn.setRequestProperty("shoplite-client-id", authcode);
	}

	@Override
	public void readHeaders(HttpURLConnection conn) {
		
	}

	public LoginTest(String key) {
		super();
		this.key = key;
	}
	
	
}
	
	