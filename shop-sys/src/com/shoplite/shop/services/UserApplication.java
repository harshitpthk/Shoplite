package com.shoplite.shop.services;


import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.shop.services.user.ChangeOrderState;
import com.shoplite.shop.services.user.GetCategories;
import com.shoplite.shop.services.user.GetItems;
import com.shoplite.shop.services.user.GetItemService;
import com.shoplite.shop.services.user.LoginService;
import com.shoplite.shop.services.user.PackItemsService;


@ApplicationPath("/service/user")
public class UserApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(LoginService.class);
       classes.add(GetItemService.class);
       classes.add(GetItems.class);
       classes.add(GetCategories.class);
       classes.add(PackItemsService.class);
       classes.add(ChangeOrderState.class);
       return classes;
	}
    
}
