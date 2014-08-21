package com.shoplite.shop.services.user;

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
import com.shoplite.shop.statics.Constants;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("packitems")
public class PackItemsService extends BaseService {
	
	Logger logger = LoggerFactory.getLogger(PackItemsService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String packItems(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			PackList packList=gson.fromJson(input, PackList.class); 
			
			if(this.session.getUserOrderId()<0)
			{
				if(packList.state!=Constants.DBState.INSERT)
				{
					throw new Exception("No order is found to update or delete the items");
				}
				int orderId = createOrder(conn,this.session.getUserId());
				
				if(orderId>0)
				{
					this.session.setUserOrderId(orderId);
				}
			}
			
			switch(packList.state)
			{
				case DELETE:
					deleteItems(conn,packList);
					break;
				case INSERT:
					insertItems(conn,packList);
					break;
				case UPDATE:
					updateItems(conn,packList);
					break;
				
			 	
			}
			
			return Util.getSuccessMessage();
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}

	private void updateItems(Connection conn, PackList packList) throws SQLException {
		
		int orderID =  this.session.getUserOrderId();
		
		String update = "UPDATE ORDERDETAILS SET QUANTITY=? WHERE ORDER_ID=? and ITEM_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(update);
		
		pstmt.setInt(2, orderID);
		
		for(int i=0;i<packList.items.size();i++)
		{
			pstmt.setInt(1, packList.items.get(i).getQuantity());
			pstmt.setInt(3, packList.items.get(i).getItemId());
			
			pstmt.executeUpdate();
		}
		
		SQLUtil.close(null, pstmt, null);
		
	}

	private void deleteItems(Connection conn, PackList packList) throws SQLException {
		
		int orderID =  this.session.getUserOrderId();
		
		String delete = "DELETE FROM ORDERDETAILS WHERE ORDER_ID=? and ITEM_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(delete);
		
		pstmt.setInt(1, orderID);
		
		for(int i=0;i<packList.items.size();i++)
		{
			pstmt.setInt(2, packList.items.get(i).getItemId());
			pstmt.executeUpdate();
		}
		
		SQLUtil.close(null, pstmt, null);
	}

	private void insertItems(Connection conn, PackList packList) throws SQLException {
		
		int orderID =  this.session.getUserOrderId();
		
		String insert = "INSERT INTO ORDERDETAILS(ORDER_ID,ITEM_ID,PRICE,QUANTITY) VALUES(?,?,?,?)";
		String insertItemsToPack = "INSERT INTO ITEMSTOPACK(ORDER_ID,ITEM_ID,PRICE,QUANTITY) VALUES(?,?,?,?)";
		
		
		PreparedStatement pstmt = conn.prepareStatement(insert);
		PreparedStatement pstmtItemsToPack = conn.prepareStatement(insertItemsToPack);
		
		
		pstmt.setInt(1, orderID);
		pstmtItemsToPack.setInt(1, orderID);
		
		for(int i=0;i<packList.items.size();i++)
		{
			pstmt.setInt(2, packList.items.get(i).getItemId());
			pstmt.setDouble(3, packList.items.get(i).getPrice());
			pstmt.setInt(4, packList.items.get(i).getQuantity());
			
			pstmt.executeUpdate();
			
			pstmtItemsToPack.setInt(2, packList.items.get(i).getItemId());
			pstmtItemsToPack.setDouble(3, packList.items.get(i).getPrice());
			pstmtItemsToPack.setInt(4, packList.items.get(i).getQuantity());
			
			pstmtItemsToPack.executeUpdate();
		}
		
		SQLUtil.close(null, pstmt, null);
		SQLUtil.close(null, pstmtItemsToPack, null);
	}

	private int createOrder(Connection conn, int userId) throws SQLException {
		
		String seqSQL = "SELECT ORDER_SEQ.NEXTVAL FROM DUMMY";
		PreparedStatement pstmt = conn.prepareStatement(seqSQL);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		int orderID = rs.getInt(1);
		SQLUtil.close(null, pstmt, rs);
		
		String insert = "INSERT INTO ORDERS(ORDER_ID,USER_ID,STATUS) VALUES(?,?,?)";
		
		pstmt = conn.prepareStatement(insert);
		pstmt.setInt(1, orderID);
		pstmt.setInt(2, this.session.getUserId());
		pstmt.setInt(3, Constants.ORDERState.INITIAL.ordinal());
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
		return orderID;
	}

}

class PackList {

    public Constants.DBState state;
	public ArrayList<OrderItemDetail> items;
}
