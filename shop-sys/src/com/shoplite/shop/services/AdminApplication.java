package com.shoplite.shop.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.shop.services.shopadmin.FetchToPackItems;


@ApplicationPath("/service/admin")
public class AdminApplication extends Application{

	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(FetchToPackItems.class);
       return classes;
	}
}
