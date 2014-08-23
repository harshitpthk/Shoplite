package com.shoplite.hub.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.hub.services.shopadmin.AddShopUser;
import com.shoplite.hub.services.shopadmin.DeleteShopUser;
import com.shoplite.hub.services.shopadmin.EditShopUser;
import com.shoplite.hub.services.shopadmin.GetCategories;
import com.shoplite.hub.services.shopadmin.GetItems;
import com.shoplite.hub.services.shopadmin.GetShopUsers;
import com.shoplite.hub.services.shopadmin.LoginService;

@ApplicationPath("/service/shopadmin/")
public class StarShopAdminApplication extends Application{
	
	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        classes.add(LoginService.class);
        classes.add(AddShopUser.class);
        classes.add(EditShopUser.class);
        classes.add(DeleteShopUser.class);
        classes.add(GetShopUsers.class);
        classes.add(GetCategories.class);
        classes.add(GetItems.class);
       return classes;
	}
}
