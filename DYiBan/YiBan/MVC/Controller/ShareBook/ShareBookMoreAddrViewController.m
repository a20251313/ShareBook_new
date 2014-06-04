//
//  ShareBookMoreAddrViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-3-6.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookMoreAddrViewController.h"

@interface ShareBookMoreAddrViewController (){


    DYBUITableView *tbDataBank11;
}

@end

@implementation ShareBookMoreAddrViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.headview setTitle:@"选择地址"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        
//        [self setButtonImage:self.rightButton setImage:@"icon_retreat"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIView *viewBGTableView = [[UIView alloc]initWithFrame:CGRectMake(10,self.headHeight + 20 , 300.0f , self.view.frame.size.height -self.headHeight - 100  )];
        [viewBGTableView setBackgroundColor:[UIColor whiteColor]];
        [viewBGTableView.layer setBorderWidth:1];
        [viewBGTableView.layer setCornerRadius:10.0f];
        [viewBGTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:viewBGTableView];
        RELEASE(viewBGTableView);
        
        
        tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(20,self.headHeight + 20 , 280.0f , self.view.frame.size.height -self.headHeight - 100  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, CGRectGetHeight(self.view.frame) - 50, 280.0f, 40.0f)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnOK addTarget:self action:@selector(doChoose) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnOK];
//        RELEASE(btnOK);
        
//        [self addlabel_title:@"设置默认地址" frame:btnOK.frame view:btnOK];
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}



#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        
        NSNumber *s;
        
        s = [NSNumber numberWithInteger:10];
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:50];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        UIButton *btnCheck;
        
        static NSString *reuseIdetify = @"SvTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        //        if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        DLogInfo(@"%d", indexPath.section);
        UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(10.09f, 10.0f, 300.0, 30.0f)];
        [labelText setText:@"人民广场100号5楼404"];
        [cell addSubview:labelText];
        RELEASE(labelText);
        
//        btnCheck = [[UIButton alloc]initWithFrame:CGRectMake(230.0f, 10.0f, 30.0f, 30.0f)];
//        [btnCheck setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
//        [btnCheck setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateSelected];
//        [btnCheck setTag:indexPath.row + 10];
//        [btnCheck addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:btnCheck];
//        RELEASE(btnCheck);
        
        //        }
        //        NSDictionary *dictInfoFood = Nil;
        //        [cell creatCell:dictInfoFood];
//        UIButton *tt = (UIButton *)[cell viewWithTag:indexPath.row + 10];
//        
//        if (tt) {
//            
//            if (iSelectRow == indexPath.row + 10) {
//                
//                [tt setSelected:YES];
//            }
//        }
        
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        [self.drNavigationController popViewControllerAnimated:YES];
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}


-(void)doSelect:(id)sender{
    
//    UIButton *btn =(UIButton *)sender;
//    //    [btn setSelected:YES];
//    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:iSelectRow - 10 inSection:0];
//    UITableViewCell *cell = [tbDataBank11 cellForRowAtIndexPath:index];
//    
//    if (cell) {
//        UIButton *btnn = (UIButton *)[cell viewWithTag:iSelectRow];
//        [btnn setSelected:NO];
//    }
//    
//    
//    iSelectRow = btn.tag;
//    [btn setSelected:YES];
    
}

- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
//        ShareBookAddAddrViewController *add  = [[ShareBookAddAddrViewController alloc]init];
//        [self.drNavigationController pushViewController:add animated:YES];
//        RELEASE(add);
        
    }
}


-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}


@end
