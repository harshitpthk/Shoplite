//
//  SCartLeftViewController.m
//  ShoppingCart
//
//  Created by Ayyanababu, Kopparthi Raja on 10/09/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize  leftTable;
@synthesize menuItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor lightTextColor]];
        self.menuItems = [[NSMutableArray alloc] initWithObjects:@"Shop At Store",@"Shop Offline",@"Settings", nil];
        
        [self.navigationItem setTitle:@"Menu"];
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,
          [Utility getFontWithSize:20.0f], NSFontAttributeName,nil]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.leftTable = tabView;
    self.leftTable.dataSource = self;
    self.leftTable.delegate = self;
    self.leftTable.dataSource = self;
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_panelLeft.png"]];
    [self.leftTable setBackgroundView:bg];
    [self.view addSubview:self.leftTable];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellidentifier = @"staticcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    cell.textLabel.text = @"first cell";
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cellMainBackgroundPlain.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    

    [cell.textLabel setText:[self.menuItems objectAtIndex:indexPath.row]];
    return  cell;
}



#pragma mark todeleteMethods in table
#pragma mark ________________________

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.menuItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
