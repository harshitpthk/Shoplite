package com.shoplite.hub.statics;

import com.shoplite.models.Session;

public class InMemoryDS {
	
	private static final MyHashMap<String,String> toBeRegisteredUsers =new MyHashMap<String,String>();
	private static final MyHashMap<String,String> toBeValidatedUsers =new MyHashMap<String,String>();
	private static final MyHashMap<String,Session> currentSessions =new MyHashMap<String,Session>();

	public static MyHashMap<String, String> getToBeRegisteredUsers() {
		return toBeRegisteredUsers;
	}
	
	public static MyHashMap<String, String> getToBeValidatedUsers() {
		return toBeValidatedUsers;
	}

	public static MyHashMap<String,Session> getCurrentsessions() {
		return currentSessions;
	}


	
}
