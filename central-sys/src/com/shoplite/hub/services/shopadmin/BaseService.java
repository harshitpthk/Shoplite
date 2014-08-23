package com.shoplite.hub.services.shopadmin;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.shoplite.models.ShopSession;

public class BaseService extends com.shoplite.hub.services.BaseService{

	public  ShopSession vallidateShopSession(HttpServletRequest request, Connection conn) throws Exception
	{
		HttpSession session = request.getSession(false);
		
		
		if(session==null)
		{
			throw new Exception("session not found");
		}
		
		String cookieName = request.getServletContext().getInitParameter("SessionCookie");
		
		ShopSession session_user = (ShopSession)session.getAttribute(cookieName);
		
		
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
