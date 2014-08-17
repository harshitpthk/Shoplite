package com.shoplite.hub.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.hub.services.shopadmin.LoginService;

@ApplicationPath("/service/shopadmin/")
public class StarShopAdminApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        classes.add(LoginService.class);
       return classes;
	}
}
