//
//  ShareBookDownViewController.h
//  ComboBox
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareBookDownViewController : DYBBaseView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UIView *superView;
@property (nonatomic,retain)NSArray *arrayResult;

- (void)viewDidLoad;

@end
