package com.shoplite.shop.services.shopadmin;

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
import com.shoplite.models.PaymentDetail;
import com.shoplite.shop.services.BaseService;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("submitpayment")
public class SubmitPayment extends BaseService{
	
Logger logger = LoggerFactory.getLogger(SubmitPayment.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String submitPayment(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			PaymentDetail payment = gson.fromJson(input,PaymentDetail.class);
			
			int paymentId = SQLUtil.createPayment(conn,payment);
			
			addPaymentForOrder(payment.getOrderId(),paymentId,conn);
			
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

	private void addPaymentForOrder(int orderId, int paymentId, Connection conn) throws SQLException {
		
		String update = "UPDATE ORDERS SET PAYMENT_ID=? WHERE ORDER_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(update);

		pstmt.setInt(1, paymentId);
		pstmt.setInt(2, orderId);
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
		
	}
		

}

