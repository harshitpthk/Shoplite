package com.shoplite.hub.services.shopadmin;

import java.sql.Connection;
import java.sql.PreparedStatement;

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
import com.shoplite.hub.statics.Constants;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.ShopSession;
import com.shoplite.models.ShopUser;

@Path("addshopuser")
public class AddShopUser extends BaseService{
	Logger logger = LoggerFactory.getLogger(AddShopUser.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String addShopUser(@Context HttpServletRequest request, @Context HttpServletResponse response, String user ) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			ShopSession session =   vallidateShopSession(request,conn);
			
			if(session.getShopUser().getRole()!=Constants.ShopUserRole.ADMIN)
			{
				throw new Exception("Cannot add an user. Please contact your administrator");
			}
			
			ShopUser shopUser = gson.fromJson(user, ShopUser.class);
			shopUser.setShopID(session.getShopUser().getShopID());
			
			addUser(shopUser,conn);
			
			return gson.toJson("Success");
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
		
	}

	
	private  boolean addUser(ShopUser user,Connection conn) throws Exception {
		
		String getValueStatement ="insert into SHOPUSERS (USER_ID,CODE,ROLE,SHOP_ID)  values(?,?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(getValueStatement);
		pstmt.setString(1, user.getUserID());
		pstmt.setString(2, user.getCode());
		pstmt.setInt(3, user.getRole().ordinal());
		pstmt.setInt(4,  user.getShopID());
		
		int row = pstmt.executeUpdate();
		SQLUtil.close(null, pstmt, null);
			
		if(row==1)
		{
			
			return true;
		}
		
		return false;
		
	}
}

