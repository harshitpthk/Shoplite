package com.shoplite.hub.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.hub.services.shop.GetUserSession;

@ApplicationPath("/service/shop/")
public class StarShopApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        classes.add(GetUserSession.class);
       return classes;
	}
}
