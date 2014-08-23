package com.shoplite.shop.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.shop.services.shopadmin.FetchToPackItems;
import com.shoplite.shop.services.GetCategories;
import com.shoplite.shop.services.GetItems;


@ApplicationPath("/service/admin")
public class AdminApplication extends Application{

	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(FetchToPackItems.class);
       classes.add(GetItems.class);
       classes.add(GetCategories.class);
       return classes;
	}
}
