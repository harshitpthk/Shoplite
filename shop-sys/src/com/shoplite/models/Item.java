package com.shoplite.models;

public class Item {

	String name;
	double price;
	int id;
	String imageUrl;
	
	public Item(String name, double price, int id, String imageUrl) {
		super();
		this.name = name;
		this.price = price;
		this.id = id;
		this.imageUrl = imageUrl;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
}
