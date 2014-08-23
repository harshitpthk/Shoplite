package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;

public class AddUserTest implements TestInterface{
	
	public AddUserTest(Integer regToken)
	{
		super();
		this.regToken =regToken;
	}
	
	public Integer regToken;
	public String servicename="adduser"; 
	public String serviceType = "POST";
	public String client_id="";
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
		System.out.println(gson.toJson(this.regToken));
		return gson.toJson(this.regToken);
		
		
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
