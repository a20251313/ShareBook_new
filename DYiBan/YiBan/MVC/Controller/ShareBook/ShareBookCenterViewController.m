//
//  ShareBookCenterViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-19.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareBookCenterViewController.h"
#import "ShareBookListViewController.h"

#import "DYBTwoDimensionCodeViewController.h"

@interface ShareBookCenterViewController (){

    NSMutableArray *arraySouce;
}

@end

@implementation ShareBookCenterViewController

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
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"我的图书中心"];
        
        
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        arraySouce = [[NSMutableArray alloc]initWithObjects:@"架上图书",@"借入图书",@"借出图书",@"漂流中的图书",@"预借中的图书", nil];
        
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0, 320.0f, self.view.frame.size.height)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        UIImage *imageIcon = [UIImage imageNamed:@"icon_book 2.png"];
        UIImageView *iamgeViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, self.headHeight+ 5, imageIcon.size.width, imageIcon.size.height)];
        [iamgeViewIcon setImage:imageIcon];
        [iamgeViewIcon setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:iamgeViewIcon];
        RELEASE(iamgeViewIcon)
        
        UILabel *labelBook = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, self.headHeight, 150.0f, 40.0f)];
        [labelBook setText:@"我的图书中心"];
        [self.view addSubview:labelBook];
        RELEASE(labelBook);
        
        
        [labelBook setBackgroundColor:[UIColor clearColor]];
        
        UIView *viewBGTableView = [[UIView alloc]initWithFrame:CGRectMake(10, self.headHeight + 60, 300.0f,  5* 50  )];
        [viewBGTableView setBackgroundColor:[UIColor whiteColor]];
        [viewBGTableView.layer setBorderWidth:1];
        [viewBGTableView.layer setCornerRadius:10.0f];
        [viewBGTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.view addSubview:viewBGTableView];
        RELEASE(viewBGTableView);
        
        
       UITableView * tbDataBank11 = [[UITableView alloc]initWithFrame:CGRectMake(20, self.headHeight+ 60 , 280.0f,  6* 50  ) style:UITableViewStylePlain];
        [tbDataBank11 setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setDataSource:self];
        [tbDataBank11 setDelegate:self];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tbDataBank11 setScrollEnabled:NO];
        
        
        UIImage *iamgeBtn = [UIImage imageNamed:@"bt_click1.png"];
        UIButton *btnSendBook = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, 390.f, iamgeBtn.size.width/2, iamgeBtn.size.height/2)];
        [btnSendBook setImage:iamgeBtn forState:UIControlStateNormal];
        [btnSendBook addTarget:self action:@selector(doPushNewBook) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSendBook];
        [btnSendBook setBackgroundColor:[UIColor clearColor]];
        RELEASE(btnSendBook);
        
        
        [self addlabel_title:@"上架图书" frame:btnSendBook.frame view:btnSendBook];
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

-(void)doPushNewBook{
    
    
    DYBTwoDimensionCodeViewController *scan = [[DYBTwoDimensionCodeViewController alloc]init];
    [self.drNavigationController pushViewController:scan animated:YES];
    [scan release];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return arraySouce.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


//    NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
    
    UITableViewCell *cell = [[[UITableViewCell alloc]init] autorelease];
    
    [cell.textLabel setText:[arraySouce objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 50-1, 320.0f, 1)];
    [imageLine setImage:[UIImage imageNamed:@"line3"]];
    [cell addSubview:imageLine];
    [imageLine release];

    
    return cell;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    ShareBookListViewController *list = [[ShareBookListViewController alloc]init];
    list.type = indexPath.row;
    [self.drNavigationController pushViewController:list animated:YES];
    RELEASE(list);


}
- (void)dealloc
{
    [arraySouce release];
    [super dealloc];
}

@end
