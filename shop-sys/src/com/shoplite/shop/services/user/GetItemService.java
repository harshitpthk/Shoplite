package com.shoplite.shop.services.user;

import java.sql.Connection;
import java.sql.SQLException;

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
import com.shoplite.models.Item;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;
import com.shoplite.shop.services.BaseService;

@Path("getitem")
public class GetItemService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(GetItemService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getItem(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{
	
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			if(!checkUserSession(request))
			{
				return Util.getInvalidSessionError();
			}
			
			initDB();
			conn = dataSource.getConnection();
			
			int  itemId = gson.fromJson(input, Integer.class);
			Item item = getItem(itemId,conn);
			
			return gson.toJson(item);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
		
	}

	private Item getItem(int itemId, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		
		return SQLUtil.getItem(itemId,conn,logger);
	}


}
