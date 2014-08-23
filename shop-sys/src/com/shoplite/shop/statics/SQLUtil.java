package com.shoplite.shop.statics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.shoplite.models.Category;
import com.shoplite.models.Item;
import com.shoplite.models.ItemCategory;
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

	
	public static ItemCategory getItemCategoryDetails(int itemcategoryId, Connection conn) throws SQLException {
		
		String getItemCategory="Select ITEM_CATEGORY_ID,ITEM_CATEGORY_NAME from ITEM_CATEGORY WHERE ITEM_CATEGORY_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItemCategory);
		pstmt.setInt(1,  itemcategoryId);
		ResultSet rs = pstmt.executeQuery();
		ItemCategory itemCategory=null;
		
		if(rs.next())
		{
			itemCategory = new ItemCategory(rs.getInt(1),rs.getString(2));
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		return itemCategory;
	}

	public static void getItemsInItemCategory(Connection conn, ArrayList<Item> list,
			int itemCatId) throws SQLException {
		// TODO Auto-generated method stub
		String getItems="Select ITEM_ID,ITEM_DESC,ITEM_PRICE,ITEM_QUANTITY from ITEM WHERE ITEM_CATEGORY_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItems);
		pstmt.setInt(1,  itemCatId);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			list.add(new Item(rs.getInt(1),rs.getString(2),rs.getDouble(3),rs.getInt(4)));
		}
		
		SQLUtil.close(null, pstmt, rs);
	}


	public static void getAllItems(Connection conn, ArrayList<ItemCategory> itemList,
			int categoryId, int shopID) throws SQLException 
	{
		
		String getItems="Select ITEM_CATEGORY_ID,ITEM_CATEGORY_NAME from ITEM_CATEGORY WHERE CATEGORY_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItems);
		pstmt.setInt(1,  categoryId);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			itemList.add(new ItemCategory(rs.getInt(1),rs.getString(2)));
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		for (ItemCategory itemCategory:itemList)
		{
			ArrayList<Item> list = new ArrayList<Item>();
			getItemsInItemCategory(conn,list,itemCategory.getId());
			
			itemCategory.setItemList(list);
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
	
	public static void getAllCategories(Connection conn,
			ArrayList<Category> categoriesList, int level) throws SQLException {
		
		String getCategories ="Select CATEGORY_ID,CATEGORY_NAME from CATEGORY WHERE PARENT_CAT_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getCategories);
		pstmt.setInt(1,  level);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			categoriesList.add(new Category(rs.getInt(1),rs.getString(2)));
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		for (Category category:categoriesList)
		{
			ArrayList<Category> list = new ArrayList<Category>();
			getAllCategories(conn,list,category.getId());
			
			category.setChildList(list);
		}
	}

}
