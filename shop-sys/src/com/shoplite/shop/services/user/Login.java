package com.shoplite.shop.services.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class Login {
	
	Logger logger = LoggerFactory.getLogger(Login.class);
	
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String login(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{

		return "";
	}

}
