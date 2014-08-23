package com.shoplite.hub.services.shopadmin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.Category;

@Path("getcategories") 
public class GetCategories extends BaseService {

	Logger logger = LoggerFactory.getLogger(GetCategories.class);
	
	@GET
	@Produces({ MediaType.APPLICATION_JSON})
	public String getCategories(@Context HttpServletRequest request,@Context HttpServletResponse response,String input ) throws IOException 
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
			
			ArrayList<Category> categoriesList =new ArrayList<Category>();
			getAllCategories(conn,categoriesList,0);
			return gson.toJson(categoriesList);
			
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

	private void getAllCategories(Connection conn,
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
