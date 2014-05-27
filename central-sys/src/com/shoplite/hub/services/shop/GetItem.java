package com.shoplite.hub.services.shop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Path("getitem") 
public class GetItem {
	
	@GET
	@Produces({ MediaType.APPLICATION_JSON})
	public String getItem(@Context HttpServletRequest request,@Context HttpServletResponse response) {
		
		Logger logger = LoggerFactory.getLogger(GetItem.class);

//		String status = init(request,response, logger);
//		
//		if(!status.equalsIgnoreCase("OK")) {
//			return "{\"status\": \"failure\", \"cause\": \"invalid session\"}";
//		}
		return "got item";
	}

}
