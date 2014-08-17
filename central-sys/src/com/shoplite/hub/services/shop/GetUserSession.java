package com.shoplite.hub.services.shop;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.hub.statics.Util;
import com.shoplite.models.Session;


@Path("getusersession")

public class GetUserSession extends BaseService{
Logger logger = LoggerFactory.getLogger(GetUserSession.class);
	
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getSession(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			Session user_session= Util.vallidateUserSession(request,conn);
			
			if(user_session.getUserId()==-1)
				throw new Exception("User not found for session");
			
			return gson.toJson(user_session);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}
}