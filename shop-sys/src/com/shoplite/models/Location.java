package com.shoplite.models;

public class Location {
	
	private String longitude;
	private String latitude;

	public Location(String longitude,String latitude)
	{
		super();
		this.longitude = longitude;
		this.latitude = latitude;
	}
	public void setLongitude (String longitude)
	{
		this.longitude = longitude;
	}
	
	public void setLatitude (String latitude)
	{
		this.latitude = latitude;
	}
	
	public String getLongitude()
	{
		return this.longitude;
	}
	
	public String getLatitude(){
		return this.latitude;
	}
}
