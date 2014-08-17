package com.shoplite.hub.services.user;

import java.sql.Connection;
import java.util.GregorianCalendar;

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
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.InMemoryDS;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.models.Session;
import com.shoplite.hub.statics.Util;

@Path("login")
public class Login extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(Login.class);
	private final static String client_id_header = "shoplite-client-id";
	
	@GET
	@Produces({ MediaType.APPLICATION_JSON})
	public String login(@Context HttpServletRequest request, @Context HttpServletResponse response ) 
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			
			validateClient(request);
			String email=  request.getHeader("user");
			int user_id = SQLUtil.getUserId(email, conn, logger);
			Session session = new Session(user_id,Util.session_user_timeout);
			String key = Util.generateRandomString(16);
			
			InMemoryDS.getCurrentsessions().setItem(key, session,conn);
		
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
		// TODO Auto-generated method stub
		String client = request.getHeader(client_id_header);
		GregorianCalendar calendar = new GregorianCalendar();
//		calendar.setTimeZone(TimeZone.getTimeZone("Asia/Calcutta"));
//		calendar.set(GregorianCalendar.DAY_OF_WEEK, GregorianCalendar.MONDAY);
		long time = calendar.getTimeInMillis();
		int i;
		for(i =0;i<5;i++)
		{
			int key = ((int)time-(i*1000))/1000;
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
			Exception e = new Exception("Validation Failed");
			throw e;
		}
	}
	
}
