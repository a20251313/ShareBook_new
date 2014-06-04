//
//  ShareBookCell.m
//  ShareBook
//
//  Created by tom zeng on 14-2-11.
//  Copyright (c) 2014年 Tomgg. All rights reserved.
//

#import "UIView+Gesture.h"
#import "ShareBookCell.h"
#import "UIView+MagicCategory.h"
#import "UITableView+property.h"
#import "UITableViewCell+MagicCategory.h"
#import "ShareBookBankViewController.h"
#import "ShareBookCellBtnCenterView.h"
#import "ShareBookListViewController.h"
#import "UIImageView+WebCache.h"

@implementation ShareBookCell{

    UIView *swipView;
    CGPoint ptBegin;
    CGPoint currentCenter; //cell当前的中心
    BOOL isOpen;
    MagicUILabel *labelFrom;
    
//    DYBDataBankSelectBtn* btnBottom;
    MagicUIImageView *swipIcan;

}

@synthesize cellBackground = _cellBackground,tb = _tb,indexPath = _indexPath;
@synthesize imageViewStats = _imageViewStats,labelProgress = _labelProgress;
@synthesize  cellType = _cellType,bSwip = _bSwip,sendMegTarget = _sendMegTarget;
@synthesize btnType = _btnType,labelGood = _labelGood,type = _type;
@synthesize labelName = _labelName,labelBad = _labelBad,strTag = _strTag;
@synthesize  beginOrPause = _beginOrPause,imageViewDown = _imageViewDown;


DEF_SIGNAL(CANCEL)
DEF_SIGNAL(FINISHSWIP)



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization codsee;
//        [self creatCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell:(NSDictionary *)dict{

    UIButton *bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 84.0f)];
    [bgBtn setBackgroundColor:[UIColor clearColor]];
    [bgBtn addTarget:self action:@selector(justPinB) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    RELEASE(bgBtn);
    
   
    
    
    
    if ([[_tb superCon] isKindOfClass:[ShareBookListViewController class]]) {
        [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:_tb,@"tbv",_indexPath,@"indexPath", nil]];
        
        
        ShareBookCellBtnCenterView *btnView = [[ShareBookCellBtnCenterView alloc]init];
        [btnView setViewBG:self];
        [btnView addBtnView:_type];
        
        
        
    }
    
    
    swipView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 84.0f)];
    swipView.tag = 100;
    [swipView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:swipView];
    RELEASE(swipView);
    
    
    
     [swipView addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:_tb,@"tbv",_indexPath,@"indexPath", nil] target:self];
    
    UIImage *imageIcon = [UIImage imageNamed:@"defualt_book"];
    UIImageView *imageBook = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, imageIcon.size.width/2, imageIcon.size.height/2)];
    [imageBook setBackgroundColor:[UIColor redColor]];
//    [imageBook setImage:[UIImage imageNamed:@"defualt_book"]];
    [imageBook setImageWithURL:[DYBShareinstaceDelegate getImageString:[dict objectForKey:@"image"]] placeholderImage:imageIcon];
    [swipView addSubview:imageBook];
    [imageBook release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, 5, 250, 20)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setText:[dict objectForKey:@"title"]];
    [swipView addSubview:labelName];
    [labelName release];
    
    UILabel *labelAuther = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelName.frame) + CGRectGetHeight(labelName.frame) + 0, 200, 20)];
    [labelAuther setText:[ NSString stringWithFormat:@"作者：%@",[dict objectForKey:@"author"]]];
    [labelAuther setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelAuther setBackgroundColor:[UIColor clearColor]];

    [labelAuther setFont:[UIFont systemFontOfSize:15]];
    [swipView addSubview:labelAuther];
    [labelAuther release];
    
    UILabel *labelPublic = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelAuther.frame) + CGRectGetHeight(labelAuther.frame) + 0, 200, 20)];
    [labelPublic setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelPublic setText:[NSString stringWithFormat:@"出版社：%@",[dict objectForKey:@"publisher"]]];
    [labelPublic setBackgroundColor:[UIColor clearColor]];

    [swipView addSubview:labelPublic];
    [labelPublic setFont:[UIFont systemFontOfSize:14]];
    [labelPublic release];
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageBook.frame) + CGRectGetMinX(imageBook.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 3, 200, 20)];
    [labelAddr setText:@"长宁区娄山管路2董"];
    [swipView addSubview:labelAddr];
    [labelAddr setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelAddr setBackgroundColor:[UIColor clearColor]];

    [labelAddr setFont:[UIFont systemFontOfSize:12]];
    [labelAddr sizeToFit];
    [labelAddr release];
    
    UILabel *labelModel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelAddr.frame) + CGRectGetMinX(labelAddr.frame) + 5, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 3, 200, 20)];
    [labelModel setText:[dict objectForKey:@"lent_way"]];
    [labelModel setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [labelModel setBackgroundColor:[UIColor clearColor]];

    [swipView addSubview:labelModel];
    [labelModel setFont:[UIFont systemFontOfSize:12]];
    [labelModel sizeToFit];
    [labelModel release];
//6.5 * 100 =
    
    UIImage *imageTitle = [UIImage imageNamed:@"title_bg"];
    UIImageView *imageViewLabel = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelModel.frame) + CGRectGetMinX(labelModel.frame) + 30, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 3, imageTitle.size.width/2, imageTitle.size.height/2)];
    [imageViewLabel setImage:[UIImage imageNamed:@"title_bg"]];
    [swipView addSubview:imageViewLabel];
    RELEASE(imageViewLabel);
    
    
    UILabel *labelMon = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 200, 20)];
   ;
    [labelMon setText: [NSString stringWithFormat:@"%@d豆押金",[dict objectForKey:@"deposit"]]];
    [imageViewLabel addSubview:labelMon];
    [labelMon setTextColor:[UIColor whiteColor]];
    [labelMon setBackgroundColor:[UIColor clearColor]];
    [labelMon setFont:[UIFont systemFontOfSize:12]];
    [labelMon sizeToFit];
    [labelMon release];
    [labelMon setBackgroundColor:[UIColor clearColor]];

    
    UIImage *imageTitle1 = [UIImage imageNamed:@"title_bg"];
    UIImageView *imageViewLabel1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelModel.frame) + CGRectGetMinX(labelModel.frame) + 30, CGRectGetMinY(labelPublic.frame) + CGRectGetHeight(labelPublic.frame) + 3 - 40, imageTitle.size.width/2, imageTitle.size.height/2)];
    [imageViewLabel1 setImage:[UIImage imageNamed:@"title_bg"]];
    [swipView addSubview:imageViewLabel1];
    RELEASE(imageViewLabel1);
    
    
    UILabel *labelMon1 = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 200, 20)];
    [labelMon1 setText:@"5豆租金"];
    [imageViewLabel1 addSubview:labelMon1];
    [labelMon1 setTextColor:[UIColor whiteColor]];
    [labelMon1 setBackgroundColor:[UIColor clearColor]];
    [labelMon1 setFont:[UIFont systemFontOfSize:12]];
    [labelMon1 sizeToFit];
    [labelMon1 release];

    [swipView setBackgroundColor:[UIColor colorWithRed:246.0f/255 green:246.0f/255 blue:246.0f/255 alpha:1.0f]];

    UIImageView *imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 90-1, 320.0f, 1)];
    [imageLine setImage:[UIImage imageNamed:@"line3"]];
    [swipView addSubview:imageLine];
    [imageLine release];
}


#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    //    DLogInfo(@"pan");
    if ([signal is:[UIView PAN]]) {//拖动信号
        NSDictionary *d=(NSDictionary *)signal.object;
        UIPanGestureRecognizer *recognizer=[d objectForKey:@"sender"];
        
        {
            
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
                
                CGPoint translation = [(UIPanGestureRecognizer *)panRecognizer translationInView:self];//移动距离及方向 x>0:右移
                
                //                DLogInfo(@"currentTouchPositionX -- %f",self.initialTouchPositionX);
                
                if (translation.x > 0 &&   self.initialTouchPositionX!=0 && swipView.frame.origin.x >= 0) {
                    {/*此cell是否是在未展开状态右划*/
                        //                        NSLog(@"66666");
                        
                        //恢复swip view frame
                        [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
                        
//                        DragonViewController *con=(DragonViewController *)[self superCon];
//                        if ([con isKindOfClass:[DYBDataBankChildrenListViewController class]])
//                        {
//                            [con.drNavigationController handleSwitchView:recognizer];
//                        }else
//                        {
//                            DYBUITabbarViewController *tabbar=[DYBUITabbarViewController sharedInstace];
//                            [[tabbar getThreeview] oneViewSwipe:panRecognizer];
//                        }
                        
                        return;
                    }
                }
                
                
                CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
                CGFloat currentTouchPositionX = currentTouchPoint.x;
                
                
                
                if (recognizer.state == UIGestureRecognizerStateBegan) {
                    
                    
                    //                    NSLog(@"UIGestureRecognizerStateBegan---");
                    ptBegin = [recognizer translationInView:self];
                    currentCenter = swipView.center;
                    self.initialTouchPositionX = currentTouchPositionX;
                    
                } else if (recognizer.state == UIGestureRecognizerStateChanged) {
                    
                    CGPoint ptEnd = [recognizer translationInView:self];
                    //                    NSLog(@"UIGestureRecognizerStateChanged --- %f",ptEnd.x);
                    currentCenter.x = 160 + ptEnd.x - ptBegin.x;
                    //                    NSLog(@"swipview --- %@",swipView);
                    //                    NSArray *arrayCell = [_tb.muD_dicfferIndexForCellView allValues];
                    if (isOpen) {
                        ShareBookCell *cell=[_tb.muD_dicfferIndexForCellView objectForKey:[NSString stringWithFormat:@"%d",_tb._selectIndex_now.row]];
                        //                        UITableViewCell *cell = [arrayCell objectAtIndex:_tb._selectIndex_now.row];
                        if (ptEnd.x < 0 && [cell isEqual:self]) { //打开的时候，不在左划
                            return;
                        }
                        
                        if (swipView.frame.origin.x + ptEnd.x - ptBegin.x <0 && [cell isEqual:self]) { //防止划过界
                            return;
                        }
                        
                        swipView.center = currentCenter;
                        
                        isOpen = NO;
                        
                    }else{
                        swipView.center = currentCenter;
                    }
                } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                    
                    CGPoint ptEnter = swipView.center;
                    //                    NSLog(@"swipView.center --- %f",swipView.center.x);
                    if (isOpen) {
                        
                        
                        [self judgeSlideRange_Point:ptEnter parameter:-200];
                        //                        [self removeGestureRecognizer:t];
                        
                    }else{
                        
                        [self judgeSlideRange_Point:ptEnter parameter:120];
                        
                    }
                }
            }
        }
    }
    else if ([signal is:[UIView TAP]]) {
        
        isOpen = NO;
        NSDictionary *object=(NSDictionary *)signal.object;
        NSDictionary *d=[object objectForKey:@"object"];
        UITableView *tbv=[d objectForKey:@"tbv"];
        
        //关闭上次展开的cell
        //        NSArray *arrayCell = [tbv.muD_dicfferIndexForCellView allValues];
        if (tbv._selectIndex_now) {
            
            //            [tbv.muD_dicfferIndexForCellView objectForKey:[NSString stringWithFormat:@"%d",tbv._selectIndex_now.row]
            UITableViewCell *cell= [tbv.muD_dicfferIndexForCellView objectForKey:[NSString stringWithFormat:@"%d",tbv._selectIndex_now.row]];
            [cell resetContentView];
            tbv._selectIndex_now=nil;
        }else{//选中cell
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", [d objectForKey:@"indexPath"], @"indexPath", nil];
            [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
        }
        
        [self resetContentView];
    }
    
}

-(void)justPinB{



}


-(void)tomgg{
    
    
}
-(void)judgeSlideRange_Point:(CGPoint )point parameter:(float)param{
    
    
    if (point.x > param) {
        
        [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
        [swipIcan setFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
        
        isOpen = NO;
        
        [self cellRemoveTapView];
        [UIView animateWithDuration:0.3 animations:^{
            
            [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
        }];
        
    }else{
        
        [swipIcan setImage:[UIImage imageNamed:@"close_more.png"]];
        
        [swipIcan setFrame:CGRectMake(320  - SWIPICAN_WIDTH - (25 - SWIPICAN_WIDTH), (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
        
        //发送信号到上层页面
//        [self sendViewSignal:[DYBDataBankListCell FINISHSWIP] withObject:nil from:self target:_sendMegTarget];
        isOpen = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [swipView setFrame:CGRectMake(- 295,0, swipView.frame.size.width, swipView.frame.size.height)];
            
            UITableView *tbv=((UITableView *)(self.superview));
            
            if (![tbv isKindOfClass:[UITableView class]]){
                tbv = (UITableView *)tbv.superview;
            }
            if (swipView.frame.origin.x<0) {//此cell已展开
                
                //                muD_dicfferIndexForCellView
                
                DLogInfo(@"index -- %d",self.index.row);
                DLogInfo(@"tbv._selectIndex_now -- %d",tbv._selectIndex_now.row);
                
                DLogInfo(@"tbv._muA_differHeightCellView -- %@",tbv._muA_differHeightCellView);
                
                //关闭上次展开的cell
                //                NSArray *arrayCell = [tbv.muD_dicfferIndexForCellView allValues];
                
                if (tbv._selectIndex_now&&tbv._selectIndex_now!=self.indexPath) {
                    ShareBookCell *cell=[tbv.muD_dicfferIndexForCellView objectForKey:[NSString stringWithFormat:@"%d",tbv._selectIndex_now.row]];
                    [cell resetContentView];
                }
                
                tbv._selectIndex_now=self.indexPath;
                
            }else if(tbv._selectIndex_now==self.indexPath){//关闭上次展开的cell
                
                UITableView *tbv=((UITableView *)(self.superview));
                
                if (![tbv isKindOfClass:[UITableView class]]){
                    tbv = (UITableView *)tbv.superview;
                }
                
                [tbv set_selectIndex_now:nil];
                
            }        
            
        }];
    }
}


-(void)closeCell{
    
    if (isOpen) {
        
        [self resetContentView];
        _tb._selectIndex_now = nil;
        
        isOpen = NO;
    }
    
}
-(void)cellRemoveTapView{
    
//    UIView * view = [swipView viewWithTag:TAPVIEWTAG];
//    if (view) {
//        [view removeFromSuperview];
//        
//    }
    [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
    [swipIcan setFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
}

-(void)doTap{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
        
    }];
    
    isOpen = NO;
    [self cellRemoveTapView];
    
}
#pragma mark - UIPanGestureRecognizer delegate

//不重写这个,tbv的滚动手势就被UIPanGestureRecognizer的手势覆盖了
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x)/*浮点数的绝对值*/ > fabs(translation.y);
    }
    return YES;
}

//恢复正常视图布局
-(void)resetContentView
{
    if (swipView.frame.origin.x<0) {
        [UIView animateWithDuration:0.3
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             swipView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 84.0f);
         } completion:^(BOOL finished) {
         }];
    }
    
    [self cellRemoveTapView];
    
}


@end
