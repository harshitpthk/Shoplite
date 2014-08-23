package com.shoplite.hub.services.shopadmin;

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
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.Item;
import com.shoplite.models.ItemCategory;

@Path("getitems") 
public class GetItems extends BaseService {

	Logger logger = LoggerFactory.getLogger(GetItems.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getItems(@Context HttpServletRequest request,@Context HttpServletResponse response, String input ) throws IOException 
	{
		
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
//			ShopSession session =null;
//			
//			try{
//				
//				session =  vallidateShopSession(request,conn);
//				
//			}catch(Exception e)
//			{
//				logger.error(e.getMessage());
//				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "invalid session");
//				return null;
//			}
//			
//			
//			if(session.getShopUser().getRole()!=Constants.ShopUserRole.ADMIN)
//			{
//				throw new Exception("Cannot add an user. Please contact your administrator");
//			}
			
			int categoryId = gson.fromJson(input, Integer.class);
			ArrayList<ItemCategory> itemList =new ArrayList<ItemCategory>();
			getAllItems(conn,itemList,categoryId,10000);
			return gson.toJson(itemList);
			
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

	private void getAllItems(Connection conn, ArrayList<ItemCategory> itemList,
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

	private void getItemsInItemCategory(Connection conn, ArrayList<Item> list,
			int itemCatId) throws SQLException {
		// TODO Auto-generated method stub
		String getItems="Select ITEM_ID,ITEM_DESC,ITEM_PRICE,ITEM_BARCODE from ITEM WHERE ITEM_CATEGORY_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItems);
		pstmt.setInt(1,  itemCatId);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			list.add(new Item(rs.getInt(1),rs.getString(2),rs.getDouble(3),rs.getInt(4)));
		}
		
		SQLUtil.close(null, pstmt, rs);
	}



}
