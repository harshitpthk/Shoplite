package com.shoplite.hub.services;


import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.hub.services.shop.GetItem;
import com.shoplite.hub.services.user.AddUser;
import com.shoplite.hub.services.user.GetShop;
import com.shoplite.hub.services.user.Login;
import com.shoplite.hub.services.user.RegisterUser;


@ApplicationPath("/service")
public class StarApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(GetItem.class); 
       classes.add(GetShop.class);
       classes.add(RegisterUser.class);
       classes.add(AddUser.class);
       classes.add(Login.class);
       return classes;
	}
    
}
