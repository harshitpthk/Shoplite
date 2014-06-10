package com.shoplite.shop.services.user;

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
import com.shoplite.shop.statics.Util;

@Path("login")
public class LoginService {
	
	Logger logger = LoggerFactory.getLogger(LoginService.class);
	
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String login(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{
		
		Gson gson = new Gson();
		
		try{
			
			String JSessionID=  gson.fromJson(input,String.class);
			String sessionKey = request.getHeader(Util.session_user_header);
			
			validateClient(request,JSessionID,sessionKey);
			
		}catch(Exception e)
		{
			
		}
			
			
		return "";
	}
	
	private void validateClient(HttpServletRequest request,String jSessionID, String sessionKey) {
		String url = request.getServletContext().getInitParameter("ServerURL");
		//URL url = new URL(url+"service/")
				
	}

}


	
