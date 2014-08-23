package com.shoplite.hub.services;


import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.hub.services.shop.GetItem;
import com.shoplite.hub.services.user.AddUserService;
import com.shoplite.hub.services.user.GetShopListService;
import com.shoplite.hub.services.user.GetShopService;
import com.shoplite.hub.services.user.LoginService;
import com.shoplite.hub.services.user.RegisterUserService;


@ApplicationPath("/service/user/")
public class StarUserApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(GetItem.class); 
       classes.add(GetShopService.class);
       classes.add(RegisterUserService.class);
       classes.add(AddUserService.class);
       classes.add(LoginService.class);
       classes.add(GetShopListService.class);
       return classes;
	}
    
}
