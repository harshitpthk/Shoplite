package com.shoplite.hub.services.user;

import java.sql.Connection;
import java.util.GregorianCalendar;

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
import com.shoplite.models.Session;
import com.shoplite.hub.statics.Util;

@Path("login")
public class LoginService extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(LoginService.class);
	private final static String client_id_header = "shoplite-client-id";
	
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
			
			validateClient(request);
			
			String email=  gson.fromJson(user,String.class);
			int user_id = SQLUtil.getUserId(email, conn);
			
			if(user_id<1)
			{
				throw new  Exception ("Username is incorrect.");
			}
			
			HttpSession sessionCookie = request.getSession(true);
			sessionCookie.setMaxInactiveInterval(2*60*60);
			String cookieName = request.getServletContext().getInitParameter("SessionCookie");
			
			
			Session session = new Session(user_id,Util.session_user_timeout);
			String key = Util.generateRandomString(16);
			sessionCookie.setAttribute(cookieName, key);
			sessionCookie.setAttribute(key, session);
			response.setHeader(Util.session_user_header,key);
			
			return gson.toJson("success");
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
			
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}
	
	private void validateClient(HttpServletRequest request) throws Exception{
		String client = request.getHeader(client_id_header);
		GregorianCalendar calendar = new GregorianCalendar();
		long time = calendar.getTimeInMillis();
		time = time+60*1000;
		int i;
		for(i =0;i<4;i++)
		{
			int key = ((int)time-(i*63000))/(63000);
			String seed = Util.generateSeed((long)key,8);
			String authKey = Util.CLIENT_ID+seed;
			String authcode = Util.encrypt(authKey);
			
			logger.error("time "+ time);
			logger.error("factor "+ key);
			logger.error("key "+ Util.CLIENT_ID);
			logger.error("seed "+ seed);
			logger.error("authcode "+ authcode);
			
			if(authcode.equals(client))
			{
				break;
			}
			
		}
		
		if(i==5)
		{
			Exception e = new Exception("validation token is incorrect.");
			throw e;
		}
	}
	
}
