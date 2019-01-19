//
//  CakeCell.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "CakeCell.h"
@interface CakeCell()
@property (strong, nonatomic, nullable) CakeViewModel *viewModel;
@end

@implementation CakeCell

- (void)updateWithViewModel:(nonnull CakeViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = self.viewModel.title;
    self.descriptionLabel.text = self.viewModel.desc;
}
@end
