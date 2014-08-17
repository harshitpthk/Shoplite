package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;
import com.shoplite.models.Location;
import com.shoplite.models.Util;

public class GetShopTest implements TestInterface{
	public String servicename="getshop"; 
	public String serviceType = "POST";
	private String sessionID="";
	
	public GetShopTest(String session)
	{
		this.sessionID= session;
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
		
		Location loc = new Location("11111", "11111");
		
		
		Gson gson = new Gson();
		System.out.println(gson.toJson(loc));
		return gson.toJson(loc);
		
		
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
