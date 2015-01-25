//
//  UISearchBarController.m
//  ShoppingCart
//
//  Created by Sunkara, Radha Phani on 21/10/14.
//  Copyright (c) 2014 com.sample.shoppingcart. All rights reserved.
//

#import "UISearchBarController.h"
#import "ConnectionManager.h"

#define rowHeight 44

@interface UISearchBarController ()

@end

@implementation UISearchBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40,0) style:UITableViewStylePlain];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,40)];
    
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-70,40)];
    self.searchbar.delegate =self;
    self.searchbar.layer.borderWidth =1.0f;
    self.searchbar.layer.borderColor = [[Utility getThemeColor] CGColor];
    
    self.searchbar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchbar becomeFirstResponder];
    
    [view addSubview:self.searchbar];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.navigationItem.titleView= view;
    
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getSearchResults:(NSString *)input
{
    ConnectionManager *manager = [ConnectionManager getInstance];
    NSString *searchText =[input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(regions)&key=%@&components=country:in",searchText,@"AIzaSyDYYRgTGk777pOLVGQgqyYA3QtFKF9BMbw"];
    
    NSURL *url =[NSURL URLWithString:urlString];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    HttpsOperations *operation = [[HttpsOperations alloc] initWithRequest:postRequest withDelegate:self];
    [manager.concurrentQueue addOperation:operation];    
    
}

-(void)cancelSearch
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *result = [self.searchResults objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text =result;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *result = [self.searchResults objectAtIndex:indexPath.row];
    [self.delegate selectedAddress:result];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if(searchText.length==3)
    {
        [self getSearchResults:searchText];
        
    }else if(searchText.length >3){
        
        self.searchResults = nil;
        self.searchResults = [[NSMutableArray alloc] init];
        
        for(int i=0;i<self.backupResults.count;i++)
        {
            NSString *result = [self.backupResults objectAtIndex:i];
            
            if([result rangeOfString:searchText options:NSCaseInsensitiveSearch].length>0)
            {
                [self.searchResults addObject:result];
            }
        }
        
        CGRect frame = self.tableView.frame;
        frame.size.height =rowHeight*self.searchResults.count+10;
        [self.tableView setFrame:frame];
        [self.tableView reloadData];
        
    }else if(self.backupResults.count>0)
    {
        self.backupResults = nil;
        self.searchResults = nil;
        
        CGRect frame = self.tableView.frame;
        frame.size.height = 0;
        [self.tableView setFrame:frame];
        [self.tableView reloadData];
    }
}

#pragma mark - opeartion delegate

-(void)operationFinishedWithdata:(HttpsOperations *)operation
{
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.receivedData options: NSJSONReadingMutableContainers error: &e];
    
    NSArray *array = [dict objectForKey:@"predictions"];
    
    self.searchResults =nil;
    self.searchResults = [[NSMutableArray alloc] init];
    
    self.backupResults =nil;
    
    for(int i=0;i<array.count;i++)
    {
        NSDictionary *dictInner = [array objectAtIndex:i];
        [self.searchResults addObject:[dictInner objectForKey:@"description"]];
    }
    
    self.backupResults = [NSMutableArray arrayWithArray:self.searchResults];
    
    CGRect frame = self.tableView.frame;
    frame.size.height =rowHeight*self.searchResults.count+10;
    [self.tableView setFrame:frame];
    [self.tableView reloadData];
}

-(void)operationFailed:(id)operation withErrorCode:(NSUInteger)errorCode
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Search Error"
                                           message:@"Sorry to inform you that we are facing some issues with search. Please go back and navigate in map to pick address" delegate:self
                                 cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
}

-(void)networkFailed:(id)operation withErrorCode:(NSUInteger)errorCode withMessage:(NSString *)msg
{
    [Utility showNetworkAlert:self withErrorCode:errorCode withMessage:msg];
}

@end
