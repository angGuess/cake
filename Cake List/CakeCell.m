//
//  CakeCell.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "CakeCell.h"

@interface CakeCell()
@property (weak, nonatomic) IBOutlet UIImageView *cakeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic, nullable) CakeViewModel *viewModel;
@property (strong, nonatomic, nullable) NSURLSessionDataTask *imageTask;
@end

@implementation CakeCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.descriptionLabel.text = nil;
    self.cakeImageView.image = nil;
    if (self.imageTask != nil) {
        [self.imageTask cancel];
    }
}

- (void)updateWithViewModel:(nonnull CakeViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = self.viewModel.title;
    self.descriptionLabel.text = self.viewModel.desc;
    self.imageTask = [self.cakeImageView loadImageWithUrlString:self.viewModel.safeUrl];
}
@end
