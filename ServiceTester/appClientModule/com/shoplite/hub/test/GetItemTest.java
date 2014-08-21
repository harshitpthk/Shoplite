package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;

class Input
{
	String type;
	int id;
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Input(String type, int id) {
		super();
		this.type = type;
		this.id = id;
	}
	
}

public class GetItemTest implements TestInterface {

	public String servicename="getitem"; 
	public String serviceType = "POST";
	
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
		Input input =new Input("itemid",10000);
		
		gson.toJson(input);
		return gson.toString();
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


