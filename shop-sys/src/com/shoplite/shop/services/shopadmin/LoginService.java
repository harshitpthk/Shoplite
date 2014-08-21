package com.shoplite.shop.services.shopadmin;


import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

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
import com.shoplite.models.ShopSession;
import com.shoplite.shop.statics.Util;

@Path("login")
public class LoginService {
	
	Logger logger = LoggerFactory.getLogger(LoginService.class);
	
	
	@POST
	@Consumes({ MediaType.APPLICATION_JSON})
	@Produces({ MediaType.APPLICATION_JSON})
	public String login(@Context HttpServletRequest request, @Context HttpServletResponse response, String input ) 
	{
		
		Gson gson = new Gson();
		
		try{
			
			String JSessionID=  gson.fromJson(input,String.class);
			String session_str = validateClient(JSessionID);
			
			if(Util.getInvalidSessionError().equalsIgnoreCase(session_str))
				throw new Exception("Session validation from central system failed");
			
			ShopSession sessionCookie = gson.fromJson(session_str, ShopSession.class);
			
			if(sessionCookie!=null && sessionCookie.isSessionVallid())
			{
				HttpSession session = request.getSession(true);
				session.setMaxInactiveInterval(Util.session_shop_timeout);
				String cookieName = request.getServletContext().getInitParameter("SessionCookie");
				
				session.setAttribute(cookieName, sessionCookie);
				
				return Util.getSuccessMessage();
				
			}else
			{
				throw new Exception("Session expired");
			}
			
		}catch(Exception e)
		{
			logger.error(e.getMessage());
			for (StackTraceElement ste : e.getStackTrace()) {
				logger.error(ste.toString());
			}
			return gson.toJson(Util.getInvalidSessionError());
		}
		
	}
	
	private String validateClient(String jSessionID) throws Exception {
		
		HttpURLConnection connection = null;  
		 String HEADER_KEY = "Access-Control-Allow-Star";
		 String HEADER_VALUE = "shoplite"; 
		
		 try {
		      //Create connection
			 URL url = new URL(Util.starURL+"service/shop/getusersession");
				
		      connection = (HttpURLConnection)url.openConnection();
		      connection.setReadTimeout(2000*60);
		      
		      //System.out.println(connection.getResponseCode());
		      connection.setRequestMethod("POST");
		      connection.setRequestProperty("content-type","application/json; charset=utf-8");
		     connection.setDoOutput(true); 
		     connection.setRequestProperty(HEADER_KEY, HEADER_VALUE);
		     connection.setRequestProperty("Cookie", "JSESSIONID="+jSessionID);
		     
		     boolean redirect = false;
		     
		 	// normally, 3xx is redirect
		 	int status = connection.getResponseCode();
		 	if (status != HttpURLConnection.HTTP_OK) {
		 		if (status == HttpURLConnection.HTTP_MOVED_TEMP
		 			|| status == HttpURLConnection.HTTP_MOVED_PERM
		 				|| status == HttpURLConnection.HTTP_SEE_OTHER)
		 		redirect = true;
		 	}
		  
		 	//System.out.println("Response Code ... " + status);
		  
		 	if (redirect) {
		  
		 		// get redirect url from "location" header field
		 		String newUrl = connection.getHeaderField("Location");
		  

		 		// open the new connnection again
		 		connection = (HttpURLConnection) new URL(newUrl).openConnection();
		 		  connection.setRequestMethod("POST");
			      connection.setRequestProperty("content-type","application/json; charset=utf-8");
			     connection.setDoOutput(true); 
			     connection.setRequestProperty(HEADER_KEY, HEADER_VALUE);
			     connection.setRequestProperty("Cookie", "JSESSIONID="+jSessionID);
				    
		  
		 	}
		  
		      
		          
		      //Get Response	
		      InputStream is = connection.getInputStream();
		      BufferedReader rd = new BufferedReader(new InputStreamReader(is));
		      String line;
		      StringBuffer response = new StringBuffer(); 
		      while((line = rd.readLine()) != null) {
		        response.append(line);
		        response.append('\r');
		      }
		      rd.close();
		      
		      return response.toString();

		    } catch (Exception e) {

		      throw e;

		    } finally {

		      if(connection != null) {
		        connection.disconnect(); 
		      }
		    }
		  
	}

}


	
