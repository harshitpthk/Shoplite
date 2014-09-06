package com.shoplite.shop.services.shopadmin;

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
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.shop.statics.Constants;
import com.shoplite.shop.statics.Constants.ORDERState;
import com.shoplite.shop.statics.SQLUtil;

@Path("getorders")
public class GetOrders extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(GetOrders.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getOrders(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) throws IOException 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
//			if(!checkUserSession(request))
//			{
//				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "invalid session");
//				return null;
//			}
			
			initDB();
			conn = dataSource.getConnection();
			
			ORDERState state = gson.fromJson(input, Constants.ORDERState.class);
			
			ArrayList<Order> orders = new ArrayList<Order>();
			getOrders(state.ordinal(),conn,orders);
			
			return gson.toJson(orders);
		
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

	private void getOrders(int state, Connection conn, ArrayList<Order> orders) throws SQLException {
		// TODO Auto-generated method stub
		String getOrder = "Select ORDER_ID,USER_ID,USER_NAME,PAYMENT_ID from ORDERS WHERE STATUS =?";
		
		PreparedStatement pstmt = conn.prepareStatement(getOrder);
		pstmt.setInt(1, state);
		
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			orders.add(new Order(rs.getInt(1),rs.getInt(2),rs.getString(3),rs.getInt(4)));
		}
		
	}
	
}

class Order
{
	int orderId;
	int userId;
	String userName;
	int paymentId;
	public Order(int orderId, int userId, String username,int paymentId) {
		super();
		this.orderId = orderId;
		this.userId = userId;
		this.userName=username;
		
		if(paymentId!=0)
			this.paymentId=paymentId;
	}
	
}
