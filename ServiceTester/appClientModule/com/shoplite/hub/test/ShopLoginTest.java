package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;
import com.shoplite.models.Util;

public class ShopLoginTest implements TestInterface {
	public String servicename="login"; 
	public String serviceType = "POST";
	private String JSession ="";
	
	public ShopLoginTest(String jsession)
	{
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
		return gson.toJson(JSession);
		
		
	}
	@Override
	public void writeHeaders(HttpURLConnection conn) {
		// TODO Auto-generated method stub
		  
	}
	@Override
	public void readHeaders(HttpURLConnection conn) {
		// TODO Auto-generated method stub
		
	}
}
