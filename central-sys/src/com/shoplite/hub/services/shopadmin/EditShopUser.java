package com.shoplite.hub.services.shopadmin;

import java.io.IOException;
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
import com.shoplite.hub.statics.Constants;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.ShopSession;
import com.shoplite.models.ShopUser;

@Path("editshopuser")
public class EditShopUser extends BaseService {

	Logger logger = LoggerFactory.getLogger(EditShopUser.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String editShopUser(@Context HttpServletRequest request, @Context HttpServletResponse response, String user ) throws IOException 
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
//			logger.error(e.getMessage());
//				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "invalid session");
//				return null;
//			}
//			
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
			
			editUser(shopUser,conn);
			
			return gson.toJson("Success");
			
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

	private void editUser(ShopUser shopUser, Connection conn) throws SQLException {
		// TODO Auto-generated method stub
		String updateRoleUser ="Update SHOPUSERS Set ROLE=?  Where SHOP_ID=? and USER_ID=?";
		String updateCodeUser ="Update SHOPUSERS Set CODE=?  Where SHOP_ID=? and USER_ID=?";
		
		
		PreparedStatement pstmt =null;
		
		if(shopUser.getRole()!=null)
		{
			pstmt = conn.prepareStatement(updateRoleUser);
			pstmt.setInt(1,  shopUser.getRole().ordinal());
			pstmt.setInt(2,  shopUser.getShopID());
			pstmt.setString(3, shopUser.getUserID());
			
			pstmt.executeUpdate();	
		}
		
		if(shopUser.getCode()!=null)
		{
			pstmt = conn.prepareStatement(updateCodeUser);
			pstmt.setString(1,  shopUser.getCode());
			pstmt.setInt(2,  shopUser.getShopID());
			pstmt.setString(3, shopUser.getUserID());
			
			pstmt.executeUpdate();	
		}
		
		
		SQLUtil.close(null, pstmt, null);
	}
}
