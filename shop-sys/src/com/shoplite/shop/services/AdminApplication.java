package com.shoplite.shop.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.shoplite.shop.services.shopadmin.ChangeItem;
import com.shoplite.shop.services.shopadmin.FetchToPackItems;
import com.shoplite.shop.services.shopadmin.GetCategories;
import com.shoplite.shop.services.shopadmin.GetItems;
import com.shoplite.shop.services.shopadmin.GetOrders;
import com.shoplite.shop.services.shopadmin.GetOrderDetails;
import com.shoplite.shop.services.shopadmin.SubmitPayment;
import com.shoplite.shop.services.shopadmin.ChangeOrderState;


@ApplicationPath("/service/shopadmin")
public class AdminApplication extends Application{

	@Override
    public Set<Class<?>> getClasses() {
        final Set<Class<?>> classes = new HashSet<Class<?>>();
        // register root resource
       classes.add(FetchToPackItems.class);
       classes.add(GetItems.class);
       classes.add(GetCategories.class);
       classes.add(ChangeItem.class);
       classes.add(GetOrders.class);
       classes.add(GetOrderDetails.class);
       classes.add(SubmitPayment.class);
       classes.add(ChangeOrderState.class);
       return classes;
	}
}
