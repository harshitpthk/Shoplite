//
//  SCartAppDelegate.h
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListController.h"
#import "QRScannerController.h"
#import "ProfileController.h"
#import "CenterTabController.h"
#import <CoreData/CoreData.h>

@interface SCartAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) UINavigationController    *SCNavController;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)launchMainScreenWithIndex: (NSUInteger)index;
- (void) launchShopSelectionScreen;
- (void) launchSignUpScreen;
- (void) launchGetStartedScreen;
- (void)launchErrorScreen;
-(void)initiateApplication;



@end
