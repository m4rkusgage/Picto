//
//  DLShotLIstingTableViewController.m
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLShotLIstingTableViewController.h"
#import "DLDribbbleAPI.h"
#import "DLShotTableViewCell.h"
#import "DLShot.h"

@interface DLShotLIstingTableViewController ()
@property (assign, nonatomic) int pageNumber;
@property (strong, nonatomic) DLDribbbleAPI *apiClient;
@property (strong, nonatomic) NSArray *shotList;
@end

@implementation DLShotLIstingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.pageNumber = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DLShotTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"shotCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 500;
    
   /* [self.apiClient popularShots:self.pageNumber completionHandler:^(id result, NSError *error) {
        self.pageNumber++;
        self.shotList = (NSArray *)result;
        NSLog(@"%@",self.shotList);
        [self.tableView reloadData];
    }];*/
    
    [self.apiClient oAuthUserShots:self.pageNumber completionHandler:^(id result, NSError *error) {
        self.pageNumber++;
        self.shotList = (NSArray *)result;
        NSLog(@"%@",self.shotList);
        [self.tableView reloadData];
    }];
}

- (DLDribbbleAPI *)apiClient
{
    if (!_apiClient) {
        _apiClient = [DLDribbbleAPI sharedInstance];
    }
    return _apiClient;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shotList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLShotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shotCell" forIndexPath:indexPath];
    
    DLShot *shot = [self.shotList objectAtIndex:indexPath.row];
    [cell addShotData:shot];
    // Configure the cell...
    
    return [cell updateCell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.shotList count] - 5) {
        [self.apiClient popularShots:self.pageNumber completionHandler:^(id result, NSError *error) {
            self.pageNumber++;
            self.shotList = [self.shotList arrayByAddingObjectsFromArray:(NSArray *)result];
            NSLog(@"%@",self.shotList);
            [self.tableView reloadData];
        }];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
