//
//  SCartAppDelegate.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 09/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "SCartAppDelegate.h"
#import "GetStartedController.h"
#import "MainScreenController.h"
#import "SignUpController.h"
#import "KeychainWrapper.h"
#import "ConnectionManager.h"
#import  <GoogleMaps/GoogleMaps.h>
#import "GoogleMapController.h"
#import "ErrorController.h"


@implementation SCartAppDelegate

@synthesize SCNavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [Utility getLightColor];
    [self.window makeKeyAndVisible];
    
    //Adding google api key
    [GMSServices provideAPIKey:[Utility getGoogleAPIKey]];
    
    [Utility setAppearance];
    [self initiateApplication];
    
    return YES;
}

-(void)initiateApplication
{
    [ConnectionManager clearInstance];
    
    KeychainWrapper *keyChain = [KeychainWrapper getInstance];
     
    NSString *key = [keyChain myObjectForKey:(__bridge id)kSecValueData];
    id account = [keyChain myObjectForKey:(__bridge id)kSecAttrAccount];
    
    
    if(![key isEqualToString:@"password"])
    {
        NSData *data = [keyChain myObjectForKey:(__bridge id)kSecAttrAccount];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)data];
        
        User *user = [[User alloc] initWithName:[dict objectForKey:@"name"] withEmail:[dict objectForKey:@"email"] withPhno:[dict objectForKey:@"phno"]];
        
        ConnectionManager *manager = [ConnectionManager getInstance];
        manager.user =user;
        
        
        if([self loginToStar])
        {
            #if (TARGET_IPHONE_SIMULATOR)
                [self launchMainScreenWithIndex:1];
            #else
                [self launchShopSelectionScreen];
            
            #endif
            
        }else
        {
            [self launchErrorScreen];
            
        }
        
    }else if([account isKindOfClass:[NSData class]])
    {
        [self launchSignUpScreen];
        
    }else
    {
        [self launchGetStartedScreen];
    }
    
}

- (void) launchGetStartedScreen
{
    //Creating GetStartedScreen
    GetStartedController *getStartedController = [[GetStartedController alloc] initWithNibName:nil bundle:nil];
    self.SCNavController = [[UINavigationController alloc] initWithRootViewController:getStartedController];
    [self.window setRootViewController:self.SCNavController];
    [self.SCNavController setNavigationBarHidden:YES];
}

- (void) launchSignUpScreen
{
    //Creating GetStartedScreen
    SignUpController *controller = [[SignUpController alloc] initWithNibName:nil bundle:nil];
    self.SCNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window setRootViewController:self.SCNavController];
    [self.SCNavController setNavigationBarHidden:YES];
}

- (void)launchShopSelectionScreen
{

    GoogleMapController *controller = [[GoogleMapController alloc] initWithNibName:nil bundle:nil];
    self.SCNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.SCNavController.navigationBar.translucent =NO;
    [self.window setRootViewController:self.SCNavController];
    
}

- (void)launchErrorScreen
{
    
    ErrorController *controller = [[ErrorController alloc] initWithNibName:nil bundle:nil];
    self.SCNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.SCNavController.navigationBar.translucent =NO;
    [self.window setRootViewController:self.SCNavController];
    
}

-(void)launchMainScreenWithIndex: (NSUInteger) index
{
    //launch main screen means user is starting new shopping session so clear previous cart
    
    [ShoppingCart clearInstance];
    
    ListController *listcont = [[ListController alloc] initWithNibName:nil bundle:nil];
    QRScannerController *qrcont  = [[QRScannerController alloc] initWithNibName:nil bundle:nil];
    ProfileController *profcont = [[ProfileController alloc] initWithNibName:nil bundle:nil];
    NSArray *tabcontrollerslist = [[NSArray alloc] initWithObjects:listcont,qrcont,profcont, nil];


    CenterTabController *tabController = [[CenterTabController alloc] init];
    self.SCNavController = [[UINavigationController alloc] initWithRootViewController:tabController];
    [tabController setViewControllers:tabcontrollerslist];
    
    self.SCNavController.navigationBar.translucent =NO;
    
    if(index>0 && index <4)
        tabController.selectedIndex = index;
    
    [UIView transitionWithView:self.window
                      duration:0.5
                      options:UIViewAnimationOptionTransitionCrossDissolve
                      animations:^{
                        self.window.rootViewController = nil;
                        [self.window setRootViewController:self.SCNavController];
                      }
                    completion:nil];
    
    
}

-(BOOL)loginToStar
{
    
    ConnectionManager *manager = [ConnectionManager getInstance];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:nil];
    [manager prepareRequestForConnection:postRequest withService:@"login" isPost:YES];
    
    [postRequest setValue:[Utility getUniqueSession] forHTTPHeaderField:@"shoplite-client-id"];
    
    NSData *data =[manager.user.email dataUsingEncoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:data];
    
    
    NSURLResponse *response;
    NSError *errorResponse = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:postRequest  returningResponse:&response error:&errorResponse];
    
    if(errorResponse)
    {
         
        [Utility showNetworkAlert:self withErrorCode:errorResponse.code withMessage:[errorResponse localizedDescription]];
        
        return NO;
        
    }else if ((200 != [(NSHTTPURLResponse *)response statusCode]) && (201 != [(NSHTTPURLResponse *)response statusCode]))
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Shop Error"
                                                            message:@"Sorry! We are not to able to serve you now" delegate:self
                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        
        return NO;
    }
    
    NSString *newStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    //change at server
    if([@"\"success\"" isEqualToString:newStr])
    {
        return YES;
    }else
    {
        return NO;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

/**
 Returns the URL to the application's documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
     _persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // add the default store to our coordinator
    NSError *error;
    
    
    // setup and add the user's store to our coordinator
    NSURL *userStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"userorders.sqlite"];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:userStoreURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}



@end
