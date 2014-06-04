package com.shoplite.shop.services;


import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.shop.services.user.Login;


@ApplicationPath("/service")
public class ShopApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(Login.class);
       return classes;
	}
    
}
