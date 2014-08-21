package com.shoplite.hub.services.shopadmin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
import com.shoplite.hub.statics.Util;
import com.shoplite.models.Shop;
import com.shoplite.models.ShopSession;
import com.shoplite.models.ShopUser;

@Path("login")
public class LoginService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(LoginService.class);
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String login(@Context HttpServletRequest request, @Context HttpServletResponse response, String user ) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			LoginDetails loginDetails = gson.fromJson(user, LoginDetails.class);
			
			int role =login(conn,loginDetails);
			
			if(role >-1)
			{
				Shop shop = SQLUtil.getShop(loginDetails.shopId, conn);
				
				HttpSession sessionCookie = request.getSession(true);
				sessionCookie.setMaxInactiveInterval((int)Util.session_shop_timeout);
				String cookieName = request.getServletContext().getInitParameter("SessionCookie");
				
				ShopUser shopUser = new ShopUser(loginDetails.userId,loginDetails.shopId,role);
				
				ShopSession session = new ShopSession(shopUser,shop.getUrl(),(int)Util.session_shop_timeout);
				sessionCookie.setAttribute(cookieName, session);
				
				LoginSucess  loginSucess = new LoginSucess();
				loginSucess.setRole(shopUser.getRole());
				loginSucess.setShop(shop);
				return gson.toJson(loginSucess);
			}
			
			return "{\"status\": \"failure\", \"cause\": \"invalid credentials\"}";
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}

	private int login(Connection conn, LoginDetails loginDetails) throws SQLException {
		// TODO Auto-generated method stub
		String getRoleSQL = "SELECT CODE,ROLE from SHOPUSERS WHERE SHOP_ID=? and USER_ID=?";
		PreparedStatement pstmt = conn.prepareStatement(getRoleSQL);
		pstmt.setInt(1, loginDetails.shopId);
		pstmt.setString(2, loginDetails.userId);
		
		ResultSet rs = pstmt.executeQuery();
		
		int role = -1;
		if(rs.next())
		{
			if(loginDetails.code.equals(rs.getString(1)))
				role = rs.getInt(2);
		}
		
		SQLUtil.close(null, pstmt, rs);
		
		return role;
	}
}

class LoginDetails
{
	int shopId;
	String userId;
	String code;
}

class LoginSucess
{
	Constants.ShopUserRole role;
	Shop shop;
	
	public Constants.ShopUserRole getRole() {
		return role;
	}
	public void setRole(Constants.ShopUserRole role) {
		this.role = role;
	}
	public Shop getShop() {
		return shop;
	}
	public void setShop(Shop shop) {
		this.shop = shop;
	}
	
}

