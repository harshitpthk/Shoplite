package com.shoplite.models;

public class Location {
	
	private double latitude;
	private double longitude;
	

	public Location(double latitude,double longitude)
	{
		super();
		this.longitude = longitude;
		this.latitude = latitude;
	}
	public void setLongitude (double longitude)
	{
		this.longitude = longitude;
	}
	
	public void setLatitude (double latitude)
	{
		this.latitude = latitude;
	}
	
	public double getLongitude()
	{
		return this.longitude;
	}
	
	public double getLatitude(){
		return this.latitude;
	}
}
