//
//  ShareDouSendViewController.m
//  ShareBook
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "ShareDouSendViewController.h"
#import "ShareBookDetailCell.h"
#import "ShareBookApplyCell.h"
#import "DYBInputView.h"
#import "CALayer+Custom.h"
#import "ShareBookZhuan.h"



@interface ShareDouSendViewController (){

    DYBInputView *_phoneInputNameRSend;
    ZenKeyboardView *_keyboardView;
}

@end

@implementation ShareDouSendViewController

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
        [self.headview setTitle:@"转赠享乐豆"];
        
        
        //        [self.leftButton setHidden:YES];
        [self setButtonImage:self.leftButton setImage:@"icon_retreat"];
        //        [self setButtonImage:self.rightButton setImage:@"home"];
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        [self.headview setBackgroundColor:[UIColor colorWithRed:22.0f/255 green:29.0f/255 blue:36.0f/255 alpha:1.0f]];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        };
        
        
        [self.rightButton setHidden:YES];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height - 44)];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewBG];
        RELEASE(viewBG);
        
        
        UIImageView *imageViewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.f, 70.0f)];
        [imageViewBG setBackgroundColor:[UIColor yellowColor] ];
        [self.view addSubview:imageViewBG];
        [imageViewBG release];
        
        UIImageView *imageViewTou = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 30.0f, 30.0f)];
        [imageViewTou setBackgroundColor:[UIColor clearColor]];
        [imageViewTou setImage:[UIImage imageNamed:@"system-avatar"]];
        [imageViewBG addSubview:imageViewTou];
        [imageViewTou release];
        
        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewTou.frame) + CGRectGetMinX(imageViewTou.frame)+ 5, 5, 100.0f, 20.0f)];
        [labelName setText:@"曾新"];
        [imageViewBG addSubview:labelName];
        [labelName release];
        
        
        
        
        UIImage *image = [UIImage imageNamed:@"down_options_bg"];
        
        UIImageView *imageNum = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 5.0f + self.headHeight + 160, 320.0f, 40)];
        [imageNum setImage:image];
        [self.view addSubview:imageNum];
        [imageNum release];
        
        
//        UILabel *labelNum  = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0, 320.0f, 40)];
//        [labelNum setText:@"本书评论（101）"];
//        [imageNum addSubview:labelNum];
//        RELEASE(labelNum);
        
        DYBUITableView * tbDataBank11 = [[DYBUITableView alloc]initWithFrame:CGRectMake(0, 44 + 120, 320.0f, self.view.frame.size.height -44-100 - 50  ) isNeedUpdate:YES];
        [tbDataBank11 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:tbDataBank11];
        [tbDataBank11 setSeparatorColor:[UIColor colorWithRed:78.0f/255 green:78.0f/255 blue:78.0f/255 alpha:1.0f]];
        RELEASE(tbDataBank11);
        [tbDataBank11 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
//        [self creatDownBar];
        
        
        
        UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
        UIImageView *viewBG1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2 - 0, 320.0f, imageBG.size.height/2)];
        [viewBG1 setUserInteractionEnabled:YES];
        //    [viewBG setBackgroundColor:[UIColor redColor]];
        [viewBG1 setTag:201];
        [viewBG1 setImage:[UIImage imageNamed:@"down_options_bg"]];
        [self.view addSubview:viewBG1];
        RELEASE(viewBG1);
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 200.0f, 30.0f)];
        [viewBG1 addSubview:textField];
        RELEASE(textField);
        
        
        
        _phoneInputNameRSend = [[DYBInputView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 250.0f, 30.0f) placeText:@"输入内容" textType:0];
        [_phoneInputNameRSend.layer AddborderByIsMasksToBounds:YES cornerRadius:4 borderWidth:1 borderColor:[[UIColor blackColor] CGColor]];
        //        [_phoneInputNameR.nameField setText:@"1"];
        [_phoneInputNameRSend.nameField setTextColor:[UIColor blackColor]];
        [_phoneInputNameRSend setBackgroundColor:[UIColor clearColor]];
        [viewBG1 addSubview:_phoneInputNameRSend];
        RELEASE(_phoneInputNameRSend);
        
        _keyboardView = [[ZenKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _keyboardView.delegate = self;
        
        _phoneInputNameRSend.nameField.inputView =_keyboardView;
        
        
        
        UIImage *image1 = [UIImage imageNamed:@"send"];
        
        UIButton *btnSend = [[UIButton alloc]initWithFrame:CGRectMake(270, ( imageBG.size.height/2 - image1.size.height/2)/2, image1.size.width/2, image1.size.height/2)];
        [btnSend setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [btnSend addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
        [btnSend setBackgroundColor:[UIColor redColor]];
        [viewBG1 addSubview:btnSend];
        RELEASE(btnSend);

        
    }else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    
    
    UIView *viewBg = [self.view viewWithTag:201];
    CGRect rect = viewBg.frame;
    
    if (self.view.frame.size.height - rect.origin.y < 100) {
        
        rect.size.height = rect.size.height - kbSize.height  - 60 ;
        [viewBg setFrame:rect];
    }else{
        
        UIImage *imageBG = [UIImage imageNamed:@"down_options_bg"];
        //        UIImageView *viewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
        [viewBg setFrame:CGRectMake(0.0f, self.view.frame.size.height - imageBG.size.height/2, 320.0f, imageBG.size.height/2)];
        
    }
    
    
    //自适应代码
}

#pragma mark - ZenKeyboardViewDelegate

- (void)didNumericKeyPressed:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"完成"]) {
        
        [_phoneInputNameRSend.nameField resignFirstResponder];
        return;
    }
    
     _phoneInputNameRSend.nameField.text = [NSString stringWithFormat:@"%@%@",  _phoneInputNameRSend.nameField.text, button.titleLabel.text];
}

- (void)didBackspaceKeyPressed {
    NSInteger length =  _phoneInputNameRSend.nameField.text.length;
    if (length == 0) {
         _phoneInputNameRSend.nameField.text = @"";
        
        return;
    }
    
    NSString *substring = [ _phoneInputNameRSend.nameField.text substringWithRange:NSMakeRange(0, length - 1)];
     _phoneInputNameRSend.nameField.text = substring;
}



#pragma mark- 只接受UITableView信号
static NSString *cellName = @"cellName";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        //        NSDictionary *dict = (NSDictionary *)[signal object];
        //        NSNumber *_section = [dict objectForKey:@"section"];
        NSNumber *s;
        
        //        if ([_section intValue] == 0) {
        s = [NSNumber numberWithInteger:10];
        //        }else{
        //            s = [NSNumber numberWithInteger:[_arrStatusData count]];
        //        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSNumber *s = [NSNumber numberWithInteger:60];
        [signal setReturnValue:s];
        
        
    }else if([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])/*titleForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ShareBookZhuan *cell = [[ShareBookZhuan alloc]init];
        
        //        NSDictionary *dictInfoFood = nil;
        //        [cell creatCell:dictInfoFood];
        DLogInfo(@"%d", indexPath.section);
        [cell creatCell:indexPath.row];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 60-1, 320.0f, 1)];
        [imageLine setImage:[UIImage imageNamed:@"line3"]];
        [cell addSubview:imageLine];
        [imageLine release];
        
        [signal setReturnValue:cell];
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        
        
    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]){
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]]){
    }else if ([signal is:[MagicUITableView TAbLEVIERETOUCH]]){
        
    }
    
    
    
}
-(void)doSend{
    
    [_phoneInputNameRSend.nameField resignFirstResponder];
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
