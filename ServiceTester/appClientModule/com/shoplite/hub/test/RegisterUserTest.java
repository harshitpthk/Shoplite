package com.shoplite.hub.test;

import java.net.HttpURLConnection;

import com.google.gson.Gson;
import com.shoplite.models.Location;
import com.shoplite.models.User;

public class RegisterUserTest implements TestInterface{
	public String servicename="registeruser"; 
	public String serviceType = "POST";
	public String user_id = "";
	public User user=null;
	
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
		Location loc = new Location("long", "lat");
		
		user = new User();
		user.setEmail("harsht91@gmail.com");
		user.setPhno("7259310712");
		user.setLocation(loc);
		user.setName("harshit");
		user.setDob("07/01/1991");
		user_id = user.getEmail()+"-"+user.getPhno();
		Gson gson = new Gson();
		System.out.println(gson.toJson(user.getEmail()));
		return gson.toJson(user.getEmail());
		
		
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
