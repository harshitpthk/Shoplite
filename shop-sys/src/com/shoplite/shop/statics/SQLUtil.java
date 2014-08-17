package com.shoplite.shop.statics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;

import com.shoplite.models.Item;
import com.shoplite.models.PaymentDetail;


public class SQLUtil {

public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		
		if(rs != null) {
			try {
				rs.close();
			} catch(Exception e) {}
		}
		if(pstmt != null) {
			try {
				pstmt.close();
			} catch(Exception e) {}
		}
		if(conn != null) {
			try {
				conn.close();
			} catch(Exception e) {}
		}
	}

public static Item getItem(int itemId, Connection conn, Logger logger) throws SQLException {
	
	String getItemStatement ="Select ITEM_DESC,ITEM_PRICE,ITEM_IMG from ITEM where ITEM_ID=?";
	PreparedStatement pstmt=null;
	ResultSet rs = null;
	Item item=null;
	try{
		pstmt = conn.prepareStatement(getItemStatement);
		pstmt.setInt(1, itemId);
		rs = pstmt.executeQuery();
		if(rs.next())
		{
			item = new Item( rs.getString(1),rs.getDouble(2),itemId,rs.getString(3));
			
		}
		
		close(null, pstmt, rs);
		return item;
		
	}catch (SQLException e) {
		throw e;
		
	}finally
	{
		SQLUtil.close(null, pstmt, rs);
	}
}

public static int createPayment(Connection conn, 
		PaymentDetail payment) throws SQLException {
	
		String seqSQL = "SELECT PAYMENT_SEQ.NEXTVAL FROM DUMMY";
		PreparedStatement pstmt = conn.prepareStatement(seqSQL);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		int paymentID = rs.getInt(1);
		SQLUtil.close(null, pstmt, rs);
		
	
		
		String insert = "INSERT INTO ORDERS(PAYMENT_ID,PAYMENT_AMOUNT,PAYMENT_DATE,MODE,REFNO) VALUES(?,?,?)";
		
		pstmt = conn.prepareStatement(insert);
		pstmt.setInt(1, paymentID);
		pstmt.setDouble(2, payment.getAmount());
		pstmt.setString(3, "CURRENTTIMESTAMP");
		pstmt.setInt(1, payment.getMode().ordinal());
		pstmt.setInt(1, payment.getReferenceNumber());
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
		
		return paymentID;
		
	}



}
