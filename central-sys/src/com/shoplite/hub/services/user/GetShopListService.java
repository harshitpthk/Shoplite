package com.shoplite.hub.services.user;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.Location;
import com.shoplite.models.Session;
import com.shoplite.models.Shop;

@Path("getshoplist")
public class GetShopListService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(GetShopListService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getShopList(@Context HttpServletRequest request,@Context HttpServletResponse response,String location ) throws IOException {

		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			try
			{
				Session user_session= vallidateUserSession(request,conn);
			
				if(user_session.getUserId()==-1)
					throw new Exception("User not found for session");
				
			}catch(Exception e)
			{
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "invalid session");
				return null;
			}
			
			
			Location loc = gson.fromJson(location, Location.class);
			
			
			ArrayList<Shop> shopList =new ArrayList<Shop>();
			getShopFromLocation(conn,loc,shopList);
			
			return gson.toJson(shopList);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			for (StackTraceElement ste : e.getStackTrace()) {
				logger.error(ste.toString());
			}
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
			return null;
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	
	}
	
	public void getShopFromLocation(Connection conn,Location loc,ArrayList<Shop> list) throws SQLException
	{
		
		String getShopStatement ="Select SHOP_NAME, URL,SHOP_LAT,SHOP_LONG from SHOP where SHOP_LAT>? and SHOP_LAT<? and SHOP_LONG>? and SHOP_LONG<?";
		PreparedStatement pstmt = conn.prepareStatement(getShopStatement);
		pstmt.setDouble(1, loc.getLatitude()-0.018);
		pstmt.setDouble(2, loc.getLatitude()+0.018);
		pstmt.setDouble(3, loc.getLongitude()-0.018);
		pstmt.setDouble(4, loc.getLongitude()+0.018);
				
		ResultSet rs = pstmt.executeQuery();
				
		while(rs.next())
		{
			String shopName = rs.getString(1);
			String url = rs.getString(2);
			Location location = new Location(rs.getDouble(3),rs.getDouble(4));
			
			Shop shop = new Shop();
			shop.setName(shopName);
			shop.setUrl(url);
			shop.setLocation(location);
			
			list.add(shop);
			
		}
				
	    SQLUtil.close(null, pstmt, rs);
				
		
	}
}
