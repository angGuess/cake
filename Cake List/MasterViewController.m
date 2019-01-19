//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

@interface MasterViewController ()
@property (strong, nonatomic) MasterViewModel *viewModel;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib =  [UINib nibWithNibName:@"CakeCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//    [self getData];
    WebService *service = [WebService new];
    self.viewModel = [[MasterViewModel alloc] initWithWebService:service completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    self.tableView.dataSource = self;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

//    NSDictionary *object = self.objects[indexPath.row];
//    cell.titleLabel.text = object[@"title"];
//    cell.descriptionLabel.text = object[@"desc"];
 
    
//    NSURL *aURL = [NSURL URLWithString:object[@"image"]];
//    NSData *data = [NSData dataWithContentsOfURL:aURL];
//    UIImage *image = [UIImage imageWithData:data];
//    [cell.cakeImageView setImage:image];
    [cell updateWithViewModel:self.viewModel.viewModels[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getData{
    
    NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *jsonError;
    id responseData = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:kNilOptions
                       error:&jsonError];
    if (!jsonError){
//        self.objects = responseData;
        [self.tableView reloadData];
    } else {
    }
    
}

@end
