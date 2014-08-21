package com.shoplite.shop.services.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
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
import com.shoplite.shop.statics.Constants;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("submitorder")
public class SubmitOrderService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(SubmitOrderService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String submitOrder(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			SubmitOrderDetail orderDetail=gson.fromJson(input, SubmitOrderDetail.class); 
			
			changeOrderState(orderDetail,conn);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}

		return Util.getSuccessMessage();
	}

	private void changeOrderState(SubmitOrderDetail orderDetail, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		String update = "UPDATE ORDERS SET STATUS=? WHERE ORDER_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(update);

		pstmt.setInt(1, orderDetail.state.ordinal());
		pstmt.setInt(2, orderDetail.orderID);
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
		
	}
	
}

class SubmitOrderDetail {
	
	int orderID;
	public Constants.ORDERState state;

}
