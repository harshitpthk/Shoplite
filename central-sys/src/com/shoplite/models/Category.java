package com.shoplite.models;

import java.util.ArrayList;

public class Category {
	int id;
	String name;
	ArrayList<Category> childList;
	
	public ArrayList<Category> getChildList() {
		return childList;
	}
	public void setChildList(ArrayList<Category> childList) {
		this.childList = childList;
	}
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
	
	public Category(int id, String name, ArrayList<Category> childList) {
		super();
		this.id = id;
		this.name = name;
		this.childList = childList;
	}
	
	public Category(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	}
	

}
