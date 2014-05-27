package com.shoplite.hub.services;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BaseService {
	InitialContext ctx;
	protected DataSource dataSource;

	
	public void initDB() throws Exception {
		
		try {
			 ctx = new InitialContext();
			 dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/DefaultDB");
		} catch(Exception e) {
			
			throw e;
		}
		
		if(dataSource == null) {
			throw new Exception( "Datasource is null");
		}
		
	}
	
	public String getError()
	{
		return "{\"status\": \"failure\", \"cause\": \"invalid session\"}";
	}

}
