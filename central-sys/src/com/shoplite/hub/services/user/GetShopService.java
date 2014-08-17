package com.shoplite.hub.services.user;

import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Consumes;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.hub.statics.Util;
import com.shoplite.models.Location;
import com.shoplite.models.Session;
import com.shoplite.models.Shop;

@Path("getshop") 
public class GetShopService extends BaseService{
	Logger logger = LoggerFactory.getLogger(GetShopService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getShop(@Context HttpServletRequest request,@Context HttpServletResponse response,String location ) {
		
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			Session user_session= Util.vallidateUserSession(request,conn);
			
			if(user_session.getUserId()==-1)
				throw new Exception("User not found for session");
			
			Location loc = gson.fromJson(location, Location.class);
			
			Shop shop = getShopFromLocation(loc,conn);
			
			if(shop==null)
			{
				throw new Exception("Shop not found");
			}
			
			return gson.toJson(shop);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			for (StackTraceElement ste : e.getStackTrace()) {
				logger.error(ste.toString());
			}
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	
	}
	
	public Shop getShopFromLocation(Location loc,Connection conn) throws Exception
	{
		
		Shop shop =SQLUtil.getShop(loc,conn);
		return shop;
	}
	
	

}
