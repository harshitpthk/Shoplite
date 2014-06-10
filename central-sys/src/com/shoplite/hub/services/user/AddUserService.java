package com.shoplite.hub.services.user;

import java.sql.Connection;

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
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.hub.statics.Util;
import com.shoplite.models.RegistrationTokenizer;
import com.shoplite.models.User;

@Path("adduser") 
public class AddUserService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(AddUserService.class);
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String addUser(@Context HttpServletRequest request, @Context HttpServletResponse response,String regString)
	{
		
		String user_code ="";
		Gson gson = new Gson();
		Connection conn = null;
		
		try
		{
			initDB();
			conn = dataSource.getConnection();
			
			HttpSession session = request.getSession(false);
			String cookieName = request.getServletContext().getInitParameter("RegCookie");
			
			if(session==null)
			{
				throw new Exception("session not found");
			}
			
			RegistrationTokenizer reg =(RegistrationTokenizer) session.getAttribute(cookieName);
			Integer token = gson.fromJson(regString, Integer.class);
			
			
			if(reg!=null && reg.getToken()==token.intValue())
			{
				if(reg.isUserExists())
				{
					if( !updateUser(reg.getUser(),conn))
						throw new Exception("Updating user to DB failed");
				}else
				{
					if(!addUserToDB(reg.getUser(),conn))
						throw new Exception("Adding new user to DB failed");
					
				}
				
			}else
			{
				throw new Exception("registration details not found");
			}
			
			user_code =Util.encrypt(Util.CLIENT_ID);
			session.invalidate();
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			for (StackTraceElement ste : e.getStackTrace()) {
				logger.error(ste.toString());
			}
			return getError();
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
		
		return gson.toJson(user_code);
	}
	
	private boolean addUserToDB(User user,Connection conn) throws Exception
	{
		SQLUtil.addUser(user, conn, logger);
		return true;
	}
	
	private boolean updateUser(User user,Connection conn) throws Exception
	{
		SQLUtil.updateUser(user, conn, logger);
		return true;
	}

}
