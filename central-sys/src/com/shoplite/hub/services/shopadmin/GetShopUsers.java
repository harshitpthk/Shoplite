package com.shoplite.hub.services.shopadmin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.statics.Constants;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.ShopSession;
import com.shoplite.models.ShopUser;

@Path("getshopusers")
public class GetShopUsers extends BaseService{
	Logger logger = LoggerFactory.getLogger(GetShopUsers.class);
	
	@GET
	@Consumes({ MediaType.APPLICATION_JSON})
	public String getShopUsers(@Context HttpServletRequest request, @Context HttpServletResponse response) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
//			ShopSession session =   vallidateShopSession(request,conn);
//			
//			if(session.getShopUser().getRole()!=Constants.ShopUserRole.ADMIN)
//			{
//				throw new Exception("Cannot add an user. Please contact your administrator");
//			}
			
			ArrayList<ShopUser> list = new ArrayList<ShopUser>();
//			getShopUsers(session.getShopUser().getShopID(),conn,list);
			getShopUsers(10000,conn,list);
			
			return gson.toJson(list);
			
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}

	private void getShopUsers(int shopID, Connection conn, ArrayList<ShopUser> list) throws SQLException {
		// TODO Auto-generated method stub
		String getUsers ="Select USER_ID,ROLE from SHOPUSERS Where SHOP_ID=?";
		
		PreparedStatement pstmt = conn.prepareStatement(getUsers);
		pstmt.setInt(1,  shopID);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next())
		{
			list.add(new ShopUser(rs.getString(1),rs.getInt(2)));
		}
		
		SQLUtil.close(null, pstmt, rs);
			
		
	}
}
