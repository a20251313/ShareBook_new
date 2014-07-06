//
//  ShareBookBankViewController.h
//  ShareBook
//
//  Created by tom zeng on 14-2-10.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface searchDataModel : NSObject
@property(nonatomic,strong)NSString *cirleID;
@property(nonatomic,strong)NSString *loanstatus;
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSString *loanway;
@property(nonatomic,strong)NSString *tagid;
@property(nonatomic,strong)NSString *kind;


@end
@interface ShareBookSearchResultViewController : DYBBaseViewController
@property(nonatomic,retain)searchDataModel  *dataModel;

@end
