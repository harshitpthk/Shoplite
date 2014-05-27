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
import com.shoplite.models.User;

@Path("adduser") 
public class AddUser extends BaseService{
	
	Logger logger = LoggerFactory.getLogger(AddUser.class);
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String addUser(String regString)
	{
		
		String user_code ="";
		Gson gson = new Gson();
		Connection conn = null;
		
		try
		{
			initDB();
			conn = dataSource.getConnection();
			RegistrationTokenizer reg = gson.fromJson(regString, RegistrationTokenizer.class);
			if(reg!=null)
			{
				String user_email=null;
				if(reg.isUserExists())
				{
					user_email =InMemoryDS.getToBeRegisteredUsers().getItem(reg.getValidator(),conn,String.class);
					if(user_email!=null && reg.getUser().getEmail().equalsIgnoreCase(user_email) )
					{
						InMemoryDS.getToBeRegisteredUsers().deleteItem(reg.getValidator(), conn);
						if(!addUserToDB(reg.getUser(),conn))
							throw new Exception("Adding new user to DB failed");
					}
				}else
				{
					user_email =InMemoryDS.getToBeRegisteredUsers().getItem(reg.getValidator(),conn,String.class);
					if(user_email!=null && reg.getUser().getEmail().equalsIgnoreCase(user_email))
					{
						InMemoryDS.getToBeRegisteredUsers().deleteItem(reg.getValidator(), conn);
						
						if( !updateUser(reg.getUser(),conn))
							throw new Exception("Updating user to DB failed");
					}
				}
				
				if(user_email==null)
				{
					throw new Exception("user not found failed");
				}
			}
			
			user_code =Util.encrypt(Util.CLIENT_ID);
		}catch(Exception e)
		{
			logger.error(e.getMessage());
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
		int id = SQLUtil.getUserId(user.getEmail(), conn, logger);
		user.setId(id);
		SQLUtil.updateUser(user, conn, logger);
		return true;
	}

}
