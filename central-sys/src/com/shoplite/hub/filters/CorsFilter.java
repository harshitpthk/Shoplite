package com.shoplite.hub.filters;

import java.io.IOException;
import java.util.Enumeration;
import java.util.GregorianCalendar;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shoplite.hub.statics.Util;

public class CorsFilter implements Filter{

	private  String[] METHODS; 
	private  String[] HEADERS; 
	private  String[] EXPOSED_HEADERS; 
	
	
	private static String HEADER_VALUE = "shoplite"; 
	public static final String REQUEST_HEADER_ORIGIN = "Origin";
	public static final String STAR_KEY="star-key";
	public static final String CLIENT_KEY="client-key";
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse resp,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest httpReq = (HttpServletRequest) req;
        HttpServletResponse httpResp = (HttpServletResponse) resp;

        System.out.print(httpReq.getHeader(REQUEST_HEADER_ORIGIN));
        httpResp.setHeader("Access-Control-Allow-Origin", REQUEST_HEADER_ORIGIN);
        
        String reqMethod = httpReq.getMethod();
		int i;
		for(i=0;i<this.METHODS.length;i++)
		{
			if(this.METHODS[i].equalsIgnoreCase(reqMethod))
			{
				break;
			}
		}
		
		if(i>=this.METHODS.length)
		{
			httpResp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bad Resquest");
			
		}
		
		for(i=0;i<this.EXPOSED_HEADERS.length;i++)
		{
			String header =httpReq.getHeader(this.EXPOSED_HEADERS[i]);
			
			if(HEADER_VALUE.equalsIgnoreCase(header))
			{
				break;
			}
		}
		
		if( httpReq.getHeader(Util.session_user_header) ==null)
		{
			httpResp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bad Resquest");
		}
		
		if(i==this.EXPOSED_HEADERS.length)
		{
			httpResp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bad Request");
			
		}
		
		
		
		
		if(chain!=null)
		{
			chain.doFilter(req, resp);
		}
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.METHODS = config.getInitParameter("cors.allowed.methods").split(",");
		this.HEADERS = config.getInitParameter("cors.allowed.headers").split(",");
		this.EXPOSED_HEADERS = config.getInitParameter("cors.exposed.headers").split(",");
	}

}