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
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("getorder")
public class GetOrders extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(SubmitPayment.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getOrder(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			int state = gson.fromJson(input, Integer.class);
			
			ArrayList<Order> orders = new ArrayList<Order>();
			getOrder(state,conn,orders);
			
			return gson.toJson(orders);
		
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}

	private void getOrder(int state, Connection conn, ArrayList<Order> orders) throws SQLException {
		// TODO Auto-generated method stub
		String getOrder = "Select ORDER_ID,USER_ID from ORDERS WHERE STATUS =?";
		
		PreparedStatement pstmt = conn.prepareStatement(getOrder);
		pstmt.setInt(1, state);
		
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			orders.add(new Order(rs.getInt(1),rs.getInt(2)));
		}
		
	}
	
}

class Order
{
	int orderId;
	int userId;
	public Order(int orderId, int userId) {
		super();
		this.orderId = orderId;
		this.userId = userId;
	}
	
}
