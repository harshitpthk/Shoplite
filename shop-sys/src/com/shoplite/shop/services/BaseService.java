package com.shoplite.shop.services;

import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import com.shoplite.models.Session;

public class BaseService {
	InitialContext ctx;
	protected DataSource dataSource;
	protected Session session;
	
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
	
	public boolean checkUserSession(HttpServletRequest request){
		try {
			HttpSession session = request.getSession(false);
			String cookieName = request.getServletContext().getInitParameter("SessionCookie");
			Session user_session = (Session)session.getAttribute(cookieName);
			this.session =user_session;
			return user_session.isSessionVallid();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		
	}
	
	

}
