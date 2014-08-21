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
import com.shoplite.models.Item;
import com.shoplite.models.ItemCategory;
import com.shoplite.shop.statics.SQLUtil;
import com.shoplite.shop.statics.Util;

@Path("getitem")
public class GetItemService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(GetItemService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String getItem(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
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
			
			Input inputObject = gson.fromJson(input, Input.class);
			
			ItemCategory itemCategory=null;
			
			if(inputObject.type.equalsIgnoreCase("itemCategoryid"))
			{
				itemCategory = SQLUtil.getItemCategoryDetails(inputObject.id, conn);
	
				ArrayList<Item> list = new ArrayList<Item>();
				SQLUtil.getItemsInItemCategory(conn, list, itemCategory.getId());
				itemCategory.setItemList(list);	
			}else
			{	
				itemCategory= getItem(inputObject.id,conn);
			}
			
			return gson.toJson(itemCategory);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return Util.getInternalError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
		
	}

	private ItemCategory getItem(int itemId, Connection conn) throws SQLException {
		
		String getItem="Select ITEM_ID,ITEM_DESC,ITEM_PRICE,ITEM_CATEGORY_ID from ITEM WHERE ITEM_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getItem);
		pstmt.setInt(1,  itemId);
		ResultSet rs = pstmt.executeQuery();
		Item item=null;
		
		if(rs.next())
		{
			item = new Item(rs.getInt(1),rs.getString(2),rs.getDouble(3));
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		ItemCategory itemCategory= SQLUtil.getItemCategoryDetails(rs.getInt(4), conn);
		
		ArrayList<Item> list =new ArrayList<Item>();
		list.add(item);
		
		itemCategory.setItemList(list);
		
		return itemCategory;
	}
	
}

class Input
{
	String type;
	int id;
}
