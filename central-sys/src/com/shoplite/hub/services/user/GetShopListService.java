package com.shoplite.hub.services.user;

import java.sql.Connection;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.Path;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.hub.statics.Util;
import com.shoplite.models.Location;
import com.shoplite.models.Shop;
import com.shoplite.models.User;

@Path("getshoplist")
public class GetShopListService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(GetShopListService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getShopList(@Context HttpServletRequest request,@Context HttpServletResponse response,String location ) {

		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			int user= Util.vallidateUserSession(request,conn);
			
			if(user==-1)
				throw new Exception("Session not found");
			
			Location loc = gson.fromJson(location, Location.class);
			
			ArrayList<Shop> shopList = getShopFromLocation(loc);
			
			if(shopList==null)
			{
				throw new Exception("Shop not found");
			}
			
			
			return gson.toJson(shopList);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	
	}
	
	public ArrayList<Shop> getShopFromLocation(Location loc)
	{
		Shop shop =new Shop();
		shop.setName("Shop");
		shop.setId("1234");
		shop.setUrl("http://localhost:8080/central-sys/HelloWorldServlet");
		ArrayList<Shop> array = new ArrayList<Shop>(); 
		array.add(shop);
		return array;
	}
}
