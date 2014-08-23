package com.shoplite.models;

public class Item {
	private int id;
	private String name;
	private int itemCategory;
	private double price;
	private int barcode;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getItemCategory() {
		return itemCategory;
	}
	public void setItemCategory(int itemCategory) {
		this.itemCategory = itemCategory;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getBarcode() {
		return barcode;
	}
	public void setBarcode(int barcode) {
		this.barcode = barcode;
	}
	
	public Item(int id, String name, double price, int barcode) {
		super();
		this.id = id;
		this.name = name;
		this.price = price;
		this.barcode = barcode;
	}
	
	
	
}
