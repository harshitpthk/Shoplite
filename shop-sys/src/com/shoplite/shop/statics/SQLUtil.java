package com.shoplite.shop.statics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import com.shoplite.models.Category;
import com.shoplite.models.Item;
import com.shoplite.models.ItemCategory;
import com.shoplite.models.PaymentDetail;
import com.shoplite.shop.statics.Constants.ORDERState;


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
		
		String getItemCategory="Select ITEM_CATEGORY_ID,ITEM_CATEGORY_NAME,BRAND_ID  from ITEM_CATEGORY WHERE ITEM_CATEGORY_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItemCategory);
		pstmt.setInt(1,  itemcategoryId);
		ResultSet rs = pstmt.executeQuery();
		ItemCategory itemCategory=null;
		
		if(rs.next())
		{
			itemCategory = new ItemCategory(rs.getInt(1),rs.getString(2),rs.getInt(3));
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


	public static void getAllItemsInCategory(Connection conn, ArrayList<ItemCategory> itemList,
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
	
	public static void getAllItemsInBrand(Connection conn, ArrayList<ItemCategory> itemList,
			int categoryId, int shopID) throws SQLException 
	{
		
		String getItems="Select ITEM_CATEGORY_ID,ITEM_CATEGORY_NAME from ITEM_CATEGORY WHERE BRAND_ID=?";
		
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
	
	public static void getAllItemsInCategoryForPriceUpdate(Connection conn, ArrayList<ItemCategory> itemList,
			int categoryId, int shopID) throws SQLException 
	{
		
		String getItems="Select ITEM_CATEGORY_ID,ITEM_CATEGORY_NAME from ITEM_CATEGORY WHERE CATEGORY_ID=? AND PRICE_UPDATE=1";
		
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
	
	public static void getAllCategories(Connection conn,
			ArrayList<Category> categoriesList, int level) throws SQLException {
		
		String getCategories ="Select CATEGORY_ID,CATEGORY_NAME,PRICE_UPDATE from CATEGORY WHERE PARENT_CAT_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getCategories);
		pstmt.setInt(1,  level);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			categoriesList.add(new Category(rs.getInt(1),rs.getString(2),rs.getBoolean(3)));
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		for (Category category:categoriesList)
		{
			ArrayList<Category> list = new ArrayList<Category>();
			getAllCategories(conn,list,category.getId());
			
			category.setChildList(list);
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
			
		
			
			String insert = "INSERT INTO PAYMENT(PAYMENT_ID,PAYMENT_AMOUNT,PAYMENT_DATE,MODE,REFNO) VALUES(?,?,?,?,?)";
			Timestamp ts = new Timestamp(Util.calendar.getTimeInMillis());
			
			pstmt = conn.prepareStatement(insert);
			pstmt.setInt(1, paymentID);
			pstmt.setDouble(2, payment.getAmount());
			pstmt.setTimestamp(3, ts);
			pstmt.setInt(4, payment.getMode().ordinal());
			pstmt.setInt(5, payment.getReferenceNumber());
			
			pstmt.executeUpdate();
			
			SQLUtil.close(null, pstmt, null);
			
			return paymentID;
			
		}
	
	public static void changeOrderState(int orderID,ORDERState state, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		String update = "UPDATE ORDERS SET STATUS=? WHERE ORDER_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(update);

		pstmt.setInt(1, state.ordinal());
		pstmt.setInt(2, orderID);
		
		pstmt.executeUpdate();
		
		SQLUtil.close(null, pstmt, null);
		
	}
	
	public static ORDERState getOrderState(int orderID, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		String update = "select STATUS from ORDERS WHERE ORDER_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(update);
		pstmt.setInt(1, orderID);
		
		ResultSet rs =pstmt.executeQuery();
		
		int state =-1;
		if(rs.next())
		{
			state = rs.getInt(1);
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		for(int i=0;i<ORDERState.values().length;i++)
		{
			if(ORDERState.values()[i].ordinal()==state)
			{
				return ORDERState.values()[i];
			}
		}
		
		return null;

		
	}


	

}
