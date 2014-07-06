//
//  ShareSearchBookViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-13.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareSearchBookViewController.h"
#import "ShareBookDownView.h"
#import "ShareBookSearchResultViewController.h"
#import "iToast.h"


@interface ShareSearchBookViewController ()<UISearchBarDelegate>
@property(nonatomic,retain)searchDataModel *dataModel;
@end

@implementation ShareSearchBookViewController
@synthesize dataModel;
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
        [self.headview setTitle:@"图书查询"];
        
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:self.view.frame];
        [viewBG setTag:100];
        [viewBG setImage:[UIImage imageNamed:@"bg"]];
        [self.view insertSubview:viewBG atIndex:0];
        RELEASE(viewBG);
        
        UISearchBar *searchView = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,self.headHeight, 320, 44) ];
        searchView.tag = 3000;
        for (UIView *subview in [searchView subviews]) {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
            }else if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setBackground:[UIImage imageNamed:@"bg_search"]];
                
            }else if ([subview isKindOfClass:[UIButton class]]){
                
                
            }
        }
        
        [searchView setPlaceholder:@"搜索书名"];
        [searchView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
        [searchView setUserInteractionEnabled:YES];
        [self.view addSubview:searchView];
        searchView.delegate = self;
        RELEASE(searchView)
        
        UILabel *labelRange = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, CGRectGetHeight(searchView.frame) + CGRectGetMinY(searchView.frame)+ 20, 100.0f, 20.0)];
        [labelRange setText:@"查询范围"];
        [self.view addSubview:labelRange];
        RELEASE(labelRange);
        [labelRange setBackgroundColor:[UIColor clearColor]];
        
        
        ShareBookDownView *downView1 = [[ShareBookDownView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelRange.frame) + CGRectGetMinX(labelRange.frame), CGRectGetHeight(searchView.frame) + CGRectGetMinY(searchView.frame)+ 20, 200, 30)];
        //@"生活圈+好友"
        NSArray *array1 = [NSArray arrayWithObjects:@"生活圈",@"好友", nil];
        downView1.arrayResult = array1;
        downView1.tag = 3001;
        [downView1 viewDidLoad];
        [self.view addSubview:downView1];
        downView1.superView = self.view;
        [downView1 release];
        
        UILabel *labelType = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, CGRectGetHeight(labelRange.frame) + CGRectGetMinY(labelRange.frame)+ 20, 150.0f, 20.0)];
        [labelType setText:@"图书类别"];
        [self.view addSubview:labelType];
        RELEASE(labelType);
        [labelType setBackgroundColor:[UIColor clearColor]];

        ShareBookDownView *downView2 = [[ShareBookDownView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelRange.frame) + CGRectGetMinX(labelRange.frame), CGRectGetHeight(labelRange.frame) + CGRectGetMinY(labelRange.frame)+ 20, 200, 30)];
        [self.view addSubview:downView2];
        downView2.tag = 3002;
        NSArray *array2 = [NSArray arrayWithObjects:@"全部",@"大众",@"其他", nil];
        downView2.arrayResult = array2;
        [downView2 viewDidLoad];
        downView2.superView = self.view;
        [downView2 release];
        
        UILabel *labelModel = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, CGRectGetHeight(labelType.frame) + CGRectGetMinY(labelType.frame)+ 20, 150.0f, 20.0)];
        [labelModel setText:@"状  态"];
        [labelModel setBackgroundColor:[UIColor clearColor]];

        [self.view addSubview:labelModel];
        RELEASE(labelModel);
        
        
        ShareBookDownView *downView3 = [[ShareBookDownView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelRange.frame) + CGRectGetMinX(labelRange.frame), CGRectGetHeight(labelType.frame) + CGRectGetMinY(labelType.frame)+ 20, 200, 30)];
        [self.view addSubview:downView3];
        
        NSArray *array3 = [NSArray arrayWithObjects:@"可借阅",@"不可借阅", nil];
        downView3.arrayResult = array3;
        downView3.tag = 3003;
        [downView3 viewDidLoad];
        downView3.superView = self.view;
        [downView3 release];
        
        UILabel *labelBorrowType = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, CGRectGetHeight(labelModel.frame) + CGRectGetMinY(labelModel.frame)+ 20, 150.0f, 30.0)];
        [labelBorrowType setText:@"借出方式"];
        [self.view addSubview:labelBorrowType];
        RELEASE(labelBorrowType);
        [labelBorrowType setBackgroundColor:[UIColor clearColor]];

        ShareBookDownView *downView4 = [[ShareBookDownView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelRange.frame) + CGRectGetMinX(labelRange.frame), CGRectGetHeight(labelModel.frame) + CGRectGetMinY(labelModel.frame)+ 20, 200, 40)];
        
        
        //@"做客+旅行"
        NSArray *array4 = [NSArray arrayWithObjects:@"做客",@"旅行",nil];
        downView4.arrayResult = array4;
        [downView4 viewDidLoad];
        
        downView4.superView = self.view;
        downView4.tag = 3004;
        [self.view addSubview:downView4];
        [downView4 release];
        
        UIButton *btnDefialModel = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelBorrowType.frame) + CGRectGetMinY(labelBorrowType.frame)+ 20, 20.0f, 20.0f)];
        [btnDefialModel setBackgroundColor:[UIColor clearColor]];
        [btnDefialModel setImage:[UIImage imageNamed:@"check_01"] forState:UIControlStateNormal];
        [btnDefialModel setImage:[UIImage imageNamed:@"check_02"] forState:UIControlStateSelected];
        [self.view addSubview:btnDefialModel];
        [btnDefialModel addTarget:self action:@selector(btnDefialModel:) forControlEvents:UIControlEventTouchUpInside];
        RELEASE(btnDefialModel);
        
        UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(35.0f, CGRectGetHeight(labelBorrowType.frame) + CGRectGetMinY(labelBorrowType.frame)+ 20, 250.0f, 20)];
        [self.view addSubview:labelText];
        RELEASE(labelText);
        [labelText setText:@"设置为默认的查询条件"];
        [labelText setBackgroundColor:[UIColor clearColor]];

        
        UIImage *image = [UIImage imageNamed:@"menu_inactive"];
        
//        
//        UIButton *btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelText.frame) + CGRectGetMinY(labelText.frame) +20, 300.0, 40.0)];
//        [btnSearch addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
//        [btnSearch setBackgroundColor:[UIColor redColor]];
//        [self.view addSubview:btnSearch];
//        [btnSearch release];
        
        
        UIImage *image1 = [UIImage imageNamed:@"bt_click1"];
        UIButton *btnOK = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelText.frame) + CGRectGetMinY(labelText.frame) +20, 300.0, 40.0)];
        [btnOK setTag:102];
        [btnOK setImage:image1 forState:UIControlStateNormal];
        //        [btnOK setBackgroundColor:[UIColor yellowColor]];
        [btnOK addTarget:self action:@selector(doChoose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnOK];
        RELEASE(btnOK);
        
        [self addlabel_title:@"开始查询" frame:btnOK.frame view:btnOK];
        
        
        DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(image.size.width/2, 44, 320.0f - 50, self.view.frame.size.height -44  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor blackColor]];
        //        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        //        RELEASE(tbDataBank11);
        
        
        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        self.dataModel = nil;
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)doChoose{
    [self doSearch];
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


-(void)btnDefialModel:(id)seder{

    UIButton *btn = (UIButton *)seder;
    
    if (btn.selected) {
        
        [btn setSelected:NO];
    }else{
        
        [btn setSelected:YES];
    
    }


}

-(void)doSearch
{

    if ([self checkInputValueIsValild])
    {
        ShareBookSearchResultViewController *controller = [[ShareBookSearchResultViewController alloc] init];
        controller.dataModel = self.dataModel;
        [self.drNavigationController pushViewController:controller animated:YES];
        [controller release];
    }

}


-(void)toastWithText:(NSString*)text
{
    iToast  *toast = [[iToast alloc] initWithText:text];
    [toast setGravity:iToastGravityCenter];
    [toast show];
    [toast release];
}
-(BOOL)checkInputValueIsValild
{
    if (!self.dataModel)
    {
        self.dataModel = [[searchDataModel alloc] init];
    }
    
    
    UISearchBar *bar = (UISearchBar*)[self.view viewWithTag:3000];
    if ([bar.text length] < 1)
    {
        [self toastWithText:@"请输入搜索关键字"];
        return NO;
    }
    
    
    ShareBookDownView  *view1 = (ShareBookDownView*)[self.view viewWithTag:3001];
    NSString    *textrange = [view1 getTextValue];
    if (textrange.length < 1)
    {
        [self toastWithText:@"请选择图书范围!"];
        return NO;
    }
    ShareBookDownView  *view2 = (ShareBookDownView*)[self.view viewWithTag:3002];
    NSString    *textCate = [view2 getTextValue];
    if (textCate.length < 1)
    {
        [self toastWithText:@"请选择图书类别!"];
        return NO;
    }
    ShareBookDownView  *view3 = (ShareBookDownView*)[self.view viewWithTag:3003];
    NSString    *textState = [view3 getTextValue];
    if (textState.length < 1)
    {
        [self toastWithText:@"请选择图书状态!"];
        return NO;
    }
    ShareBookDownView  *view4 = (ShareBookDownView*)[self.view viewWithTag:3004];
    NSString    *textway = [view4 getTextValue];
    if (textway.length < 1)
    {
        [self toastWithText:@"请选择图书借出方式!"];
        return NO;
    }
    
    /*
    @property(nonatomic,strong)NSString *cirleID;
    @property(nonatomic,strong)NSString *loanstatus;
    @property(nonatomic,strong)NSString *keyword;
    @property(nonatomic,strong)NSString *loanway;
    @property(nonatomic,strong)NSString *tagid;
    @property(nonatomic,strong)NSString *kind;
    */
    self.dataModel.keyword = bar.text;
    
    if ([textrange isEqualToString:@"生活圈"])
    {
        self.dataModel.kind = @"1";
    }else if ([textrange isEqualToString:@"好友"])
    {
        self.dataModel.kind = @"2";
    }
    
    if ([textState isEqualToString:@"可借阅"])
    {
        self.dataModel.loanstatus= @"1";
    }else if ([textState isEqualToString:@"不可借阅"])
    {
        self.dataModel.loanstatus = @"0";
    }
    
    if ([textCate isEqualToString:@"全部"])
    {
        self.dataModel.tagid = @"0";
    }else if ([textCate isEqualToString:@"大众"])
    {
        self.dataModel.tagid = @"1";
    }else
    {
        self.dataModel.kind = @"2";
    }
    
    if ([textway isEqualToString:@"做客"])
    {
        self.dataModel.tagid = @"2";
    }else if ([textway isEqualToString:@"旅行"])
    {
        self.dataModel.tagid = @"1";
    }
    
    return YES;
}




- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self doSearch];
}


-(void)dealloc
{
    self.dataModel = nil;
    
    [super dealloc];
}
@end
