package com.shoplite.shop.services.shopadmin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

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
import com.shoplite.models.OrderItemDetail;
import com.shoplite.shop.services.BaseService;
import com.shoplite.shop.services.user.PackItemsService;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("fetchitems")
public class FetchToPackItems extends BaseService {
	
Logger logger = LoggerFactory.getLogger(PackItemsService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String fetchItems(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			int noOfItems = gson.fromJson(input, Integer.class);
			
			ArrayList<OrderItemDetail> list = new ArrayList<OrderItemDetail>();
			fetchNextSet(conn,noOfItems,list);
			
			return gson.toJson(list);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}

	private void fetchNextSet(Connection conn, int noOfItems, ArrayList<OrderItemDetail> list) throws SQLException {
		
		String getItems = "SELECT TOP ? * FROM ITEMSTOPACK";
		PreparedStatement pstmt = conn.prepareStatement(getItems);
		pstmt.setInt(1, noOfItems);
		
		ResultSet rs = pstmt.executeQuery();
		while(rs.next())
		{
			OrderItemDetail item =new OrderItemDetail(rs.getInt(1),rs.getInt(2),rs.getInt(3),rs.getInt(4));
			list.add(item);
		}
		SQLUtil.close(null, pstmt, rs);
		
		
		String deleteItems = "DELETE FROM ITEMSTOPACK Where ORDER_ID,ITEM_ID IN ELECT TOP ? * FROM ITEMSTOPACK";
		pstmt = conn.prepareStatement(deleteItems);
		pstmt.setInt(1, noOfItems);
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
	}
}
