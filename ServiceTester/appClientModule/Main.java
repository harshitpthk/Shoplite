import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.URL;
import java.util.List;

import sun.misc.BASE64Encoder;

import com.google.gson.Gson;
import com.shoplite.hub.test.AddUserTest;
import com.shoplite.hub.test.GetItemTest;
import com.shoplite.hub.test.GetShopTest;
import com.shoplite.hub.test.LoginTest;
import com.shoplite.hub.test.RegisterUserTest;
import com.shoplite.hub.test.ShopLoginTest;
import com.shoplite.hub.test.TestInterface;
import com.shoplite.models.Shop;
import com.shoplite.models.Util;


public class Main {
	
	private static final String HEADER_KEY = "Access-Control-Allow-Star";
	private  static String urlAddress = "https://starp1940130226trial.hanatrial.ondemand.com/central-sys/service/user/";
	private static String HEADER_VALUE = "shoplite"; 
	private static String client_id="";
	private static String session_id="";
	private static String user_id="";
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Gson  gson = new Gson();
		TestInterface test = new GetItemTest();
<<<<<<< HEAD

		System.out.println("Register user ");
		test = new RegisterUserTest();
		 
		String obj =excutePost(test);
		String user_id = ((RegisterUserTest)test).user_id;
		user_id= new BASE64Encoder().encode(user_id.getBytes());
		
			
		System.out.println("reg obj got back ="+obj);
		
		System.out.println("add user ");
		Gson  gson = new Gson();
		Integer regtoken =gson.fromJson(obj, Integer.class);
		test = new AddUserTest(regtoken);
		String client =excutePost(test);
		String id = gson.fromJson(client, String.class);
		System.out.println("client id got ="+client);
		try {
			client_id = Util.decrypt(id);
			System.out.println("client id after decryption ="+client_id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
=======
//		System.out.println("Register user ");
//		test = new RegisterUserTest();
//		 
//		String obj =excutePost(test);
//		String user_id = ((RegisterUserTest)test).user_id;
//		user_id= new BASE64Encoder().encode(user_id.getBytes());
//		
//			
//		System.out.println("reg obj got back ="+obj);
//		
//		System.out.println("add user ");
//		Integer regtoken =gson.fromJson(obj, Integer.class);
//		test = new AddUserTest(regtoken);
//		String client =excutePost(test);
//		String id = gson.fromJson(client, String.class);
//		System.out.println("client id got ="+client);
//		try {
//			client_id = Util.decrypt(id);
//			System.out.println("client id after decryption ="+client_id);
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		client_id="UBYr789";
>>>>>>> origin/master
		System.out.println("login user ");
		test = new LoginTest(client_id);
		System.out.println(excutePost(test));
		
		
		test = new GetShopTest();
		String shopStr= excutePost(test);
		System.out.println(shopStr);
	
		
		Shop shop = gson.fromJson(shopStr, Shop.class);
		
		urlAddress = "https://"+shop.getUrl()+"service/user/";
		
		test = new ShopLoginTest(session_id);
		System.out.println(excutePost(test));
		
		test =new GetItemTest();
		System.out.println(excutePost(test));
		
	}

	/* (non-Java-doc)
	 * @see java.lang.Object#Object()
	 */
	public Main() {
		super();
		
	}
	
	public static String excutePost(TestInterface test)
	  {
		HttpURLConnection connection = null;  
	    try {
	      //Create connection
	      URL url = new URL(urlAddress+test.getServiceName());
	      
	      Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress("proxy", 8080));
	      connection = (HttpURLConnection)url.openConnection(proxy);
	      connection.setReadTimeout(2000*60);
	      
	      //System.out.println(connection.getResponseCode());
	      connection.setRequestMethod(test.getMethodType());
	      connection.setRequestProperty("content-type","application/json; charset=utf-8");
	     connection.setDoOutput(true); 
	     connection.setRequestProperty(HEADER_KEY, HEADER_VALUE);
	     connection.setRequestProperty("user", user_id);
	     connection.setRequestProperty("Cookie", session_id);
	     connection.setConnectTimeout(60*1000*3);
	     
	     test.writeHeaders(connection);
	     
	     if("POST".equalsIgnoreCase( test.getMethodType()))
	      {
	    	//Send request
	    	  DataOutputStream wr = new DataOutputStream (
		                  connection.getOutputStream ());
		      wr.writeBytes (test.getPostObject());
		      wr.flush ();
		      wr.close ();
	      }
	     
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
	 		connection = (HttpURLConnection) new URL(newUrl).openConnection(proxy);
	 		  connection.setRequestMethod(test.getMethodType());
		      connection.setRequestProperty("content-type","application/json; charset=utf-8");
		     connection.setDoOutput(true); 
		     connection.setRequestProperty(HEADER_KEY, HEADER_VALUE);
		     connection.setRequestProperty("user", user_id);
		     connection.setRequestProperty("Cookie", session_id);
		     test.writeHeaders(connection);
	  
	 		//System.out.println("Redirect to URL : " + newUrl);
	  
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
	      test.readHeaders(connection);
	      
	      List<String> cookies = connection.getHeaderFields().get("Set-Cookie");
	      for (String cookie : cookies) {                    
             if(cookie.contains("JSESSIONID="))
             {
            	 session_id=cookie.split(";")[0];
            	 System.out.println(session_id);
            	 break;
             }
             
         }
	      
	      
	      return response.toString();

	    } catch (Exception e) {

	      e.printStackTrace();
	      return null;

	    } finally {

	      if(connection != null) {
	        connection.disconnect(); 
	      }
	    }
	  }

}