package com.shoplite.hub.services.shop;

import java.io.IOException;
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
import com.shoplite.hub.statics.SQLUtil;


@Path("getusersession")

public class GetUserSession extends BaseService{
Logger logger = LoggerFactory.getLogger(GetUserSession.class);
	
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getSession(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) throws IOException 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			Object session =vallidateUserSession(request,conn);
			
			return gson.toJson(session);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			for (StackTraceElement ste : e.getStackTrace()) {
				logger.error(ste.toString());
			}
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, e.getMessage());
			return null;
			
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}
}
