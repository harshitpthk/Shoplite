package com.shoplite.hub.services.user;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.shoplite.models.Session;

public class BaseService extends com.shoplite.hub.services.BaseService{

	public  Session vallidateUserSession(HttpServletRequest request, Connection conn) throws Exception
	{
		HttpSession session = request.getSession(false);
		
		
		if(session==null)
		{
			throw new Exception("session not found");
		}
		
		String cookieName = request.getServletContext().getInitParameter("SessionCookie");
		
		Session session_user = (Session)session.getAttribute(cookieName);
		
		if(session_user!=null && session_user.isSessionVallid())
		{
			return session_user;
			
		}else if(session_user ==null)
		{
			throw new Exception("session object missing");
		}else
		{
			throw new Exception("session time out");
		}

	}
}
