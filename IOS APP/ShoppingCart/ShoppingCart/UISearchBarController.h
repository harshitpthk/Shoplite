//
//  UISearchBarController.h
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 21/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpsOperations.h"

@protocol SearchDelegate <NSObject>
-(void)selectedAddress:(NSString *)string;
@end

@interface UISearchBarController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,OperationDelegate>


@property(nonatomic,retain) UISearchBar *searchbar;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *searchResults;
@property(nonatomic,retain) NSMutableArray *backupResults;
@property(nonatomic,assign) id<SearchDelegate> delegate;

-(void)getSearchResults:(NSString *)input;

@end
