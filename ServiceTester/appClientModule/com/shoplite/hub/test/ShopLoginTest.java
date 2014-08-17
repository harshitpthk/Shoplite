package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;
import com.shoplite.models.Util;

public class ShopLoginTest implements TestInterface {
	public String servicename="login"; 
	public String serviceType = "POST";
	private String sessionID="";
	private String JSession ="";
	
	public ShopLoginTest(String session, String jsession)
	{
		this.sessionID= session;
		this.JSession= jsession;
	}
	
	@Override
	public String getServiceName() {
		// TODO Auto-generated method stub
		return servicename;
	}
	@Override
	public String getMethodType() {
		// TODO Auto-generated method stub
		return serviceType;
	}
	@Override
	public String getPostObject() {
		// TODO Auto-generated method stub
		Gson gson = new Gson();
		String str =JSession.substring(JSession.indexOf("=")+1,JSession.length());
		return gson.toJson(str);
		
		
	}
	@Override
	public void writeHeaders(HttpURLConnection conn) {
		// TODO Auto-generated method stub
		conn.addRequestProperty(Util.session_user_header, sessionID);
	     
	}
	@Override
	public void readHeaders(HttpURLConnection conn) {
		// TODO Auto-generated method stub
		
	}
}
