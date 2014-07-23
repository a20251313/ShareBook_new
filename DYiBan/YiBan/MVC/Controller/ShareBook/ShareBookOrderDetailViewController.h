//
//  ShareBookOrderDetailViewController
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface ShareBookOrderDetailViewController : DYBBaseViewController<UITextFieldDelegate>
@property (nonatomic,retain)NSString *orderID;
@property (nonatomic,retain)NSDictionary   *dicAddress;
@end
