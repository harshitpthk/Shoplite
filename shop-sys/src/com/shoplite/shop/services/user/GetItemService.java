package com.shoplite.shop.services.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import com.shoplite.shop.services.BaseService;

@Path("getitem")
public class GetItemService extends BaseService{
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getItem(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{

		return "";
	}


}
