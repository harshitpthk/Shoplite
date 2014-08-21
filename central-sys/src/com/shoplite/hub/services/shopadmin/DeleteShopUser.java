package com.shoplite.hub.services.shopadmin;

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
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.ShopUser;

@Path("deleteshopuser")
public class DeleteShopUser extends BaseService{

	Logger logger = LoggerFactory.getLogger(EditShopUser.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String editShopUser(@Context HttpServletRequest request, @Context HttpServletResponse response, String user ) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
//			ShopSession session = vallidateShopSession(request,conn);
//			
//			if(session.getShopUser().getRole()!=Constants.ShopUserRole.ADMIN)
//			{
//				throw new Exception("Cannot add an user. Please contact your administrator");
//			}
			
			ShopUser shopUser = gson.fromJson(user, ShopUser.class);
			shopUser.setShopID(10000);
//			shopUser.setShopID(session.getShopUser().getShopID());
			
			
			if(shopUser.getUserID()==null)
				throw new Exception("User is not vallid");
			
			deleteUser(shopUser,conn);
			
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

	private void deleteUser(ShopUser shopUser, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		String deleteUser ="delete from SHOPUSERS Where SHOP_ID=? and USER_ID=?";
		
		PreparedStatement pstmt =null;
		
		if(shopUser.getUserID()!=null)
		{
			pstmt = conn.prepareStatement(deleteUser);
			pstmt.setInt(1,  shopUser.getShopID());
			pstmt.setString(2, shopUser.getUserID());
			
			pstmt.executeUpdate();	
		}
		
		SQLUtil.close(null, pstmt, null);
	}
}
