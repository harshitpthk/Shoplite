package com.shoplite.hub.services.shop;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


public class BaseService extends com.shoplite.hub.services.BaseService{

	public  Object vallidateUserSession(HttpServletRequest request, Connection conn) throws Exception
	{
		HttpSession session = request.getSession(false);
		
		
		if(session==null)
		{
			throw new Exception("session not found");
		}
		
		String cookieName = request.getServletContext().getInitParameter("SessionCookie");
		Object obj = session.getAttribute(cookieName);
		
		if(obj!=null)
		{
			return obj;
			
		}
		
		throw new Exception("session object missing");

	}
}
