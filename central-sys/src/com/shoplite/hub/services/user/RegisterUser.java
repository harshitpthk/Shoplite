package com.shoplite.hub.services.user;

import java.sql.Connection;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.shoplite.hub.services.BaseService;
import com.shoplite.hub.statics.InMemoryDS;
import com.shoplite.hub.statics.SQLUtil;
import com.shoplite.hub.statics.Util;
import com.shoplite.models.RegistrationTokenizer;

@Path("registeruser") 
public class RegisterUser extends BaseService{

	Logger logger = LoggerFactory.getLogger(RegisterUser.class);
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String registerUser(String userString)
	{
		Gson gson = new Gson();
		Connection conn = null;
		
		try{
			
			initDB();
			conn = dataSource.getConnection();
			String user_email = gson.fromJson(userString, String.class);
			String random = Util.generateRandomString(8);
		
			RegistrationTokenizer reg = new RegistrationTokenizer();
			
			if(checkUserExists(user_email,conn))
			{
				reg.setUserExists(true);	
				InMemoryDS.getToBeValidatedUsers().setItem(random,user_email,conn);
				
			}else
			{
				reg.setUserExists(false);
				InMemoryDS.getToBeRegisteredUsers().setItem(random, user_email,conn);
			}
			
			reg.setValidator(random);
			reg.setToken(Util.generateRandomNumber(5));	
			return gson.toJson(reg);
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			return getError();
		}finally
		{
			SQLUtil.close(conn, null, null);
		}
	}
	
	public boolean checkUserExists(String user_email, Connection conn) throws Exception
	{
		int id = SQLUtil.getUserId(user_email, conn, logger);
		
		if(id>99999)
			return true;
		else return false;
	}
}
