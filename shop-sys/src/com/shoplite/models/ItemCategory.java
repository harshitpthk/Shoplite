package com.shoplite.models;

import java.util.ArrayList;

public class ItemCategory {

	private int id;
	private String name;
	private int categoryId;
	private ArrayList<Item> itemList;
	
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
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	
	public ItemCategory(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	}
	public ArrayList<Item> getItemList() {
		return itemList;
	}
	public void setItemList(ArrayList<Item> itemList) {
		this.itemList = itemList;
	}
	
	
}
