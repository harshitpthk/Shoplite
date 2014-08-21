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

@Path("registeruser") 
public class RegisterUserService extends BaseService{

	Logger logger = LoggerFactory.getLogger(RegisterUserService.class);
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String registerUser(@Context HttpServletRequest request, @Context HttpServletResponse response,String userString)
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			initDB();
			conn = dataSource.getConnection();
			HttpSession session = request.getSession(true);
			session.setMaxInactiveInterval(60*60);
			logger.error(userString);
			String cookieName = request.getServletContext().getInitParameter("RegCookie");
			
			User user = gson.fromJson(userString, User.class);
			String random = Util.generateRandomString(8);
		
			RegistrationTokenizer reg = new RegistrationTokenizer();
			if(user.getEmail()==null || user.getPhno()==null)
				throw new Exception("user data is not vallid");
			
			int id = SQLUtil.getUserId(user.getEmail(), conn);
			
			if(id>99999)
			{
				reg.setUserExists(true);
				user.setId(id);
			}else
			{
				reg.setUserExists(false);
			}
			
			reg.setValidator(random);
			reg.setToken(Util.generateRandomNumber(5));	
			reg.setUser(user);
			
			session.setAttribute(cookieName, reg);
			return gson.toJson(reg.getToken());
			
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
	}
	
}
