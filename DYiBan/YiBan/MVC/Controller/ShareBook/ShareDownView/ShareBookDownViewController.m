//
//  ShareBookDownViewController.m
//  ComboBox
//
//  Created by tom zeng on 14-2-14.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//

#import "ShareBookDownViewController.h"
#import "UITableView+DataSourceBlocks.h"
@class TableViewWithBlock;
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"



@interface ShareBookDownViewController (){
 
    BOOL isOpened;
    UIButton *_openButton;
    UITextField *_inputTextField;
    TableViewWithBlock *_tb;
}

@end

@implementation ShareBookDownViewController
@synthesize superView,arrayResult = _arrayResult;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self viewDidLoad];
    }
    return self;
}


- (void)viewDidLoad
{
    
//    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake( 0.0f, 0.0f, 160, 30.0f)];
    [_inputTextField setTextAlignment:NSTextAlignmentCenter];
    [_inputTextField setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];
    [_inputTextField setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_inputTextField];
    [_inputTextField release];
    
    UIImage *closeImage=[UIImage imageNamed:@"icon_down"];

    _openButton  = [[UIButton alloc]initWithFrame:CGRectMake(130, 0.0f, closeImage.size.width/1.5, closeImage.size.height/1.5)];
       [_openButton setImage:closeImage forState:UIControlStateNormal];
    [_openButton setBackgroundColor:[ UIColor clearColor]];
    [_openButton addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    [_inputTextField addSubview:_openButton];
    [_openButton release];
    
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(0.0f, 30.0f, 160.0f, 1.0f)];
    [_tb setDelegate:self];
    [_tb setDataSource:self];
    [_tb setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_tb];
    [_tb release];
    
    isOpened=NO;
//    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
//        return 5;
//        
//    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
//        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
//        if (!cell) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//        }
//        [cell.lb setText:[NSString stringWithFormat:@"Select %d",indexPath.row]];
//        return cell;
//    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
//        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
//        _inputTextField.text=cell.lb.text;
//        [_openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//    }];
    
    [_tb.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tb.layer setBorderWidth:2];

    [_tb reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayResult.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    NSString *strContent = [_arrayResult objectAtIndex:indexPath.row];
    
    [cell.lb setText:strContent];
    [cell.lb setTextColor:[UIColor colorWithRed:82.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0f]];

    return cell;



}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
    _inputTextField.text=cell.lb.text;
    [_openButton sendActionsForControlEvents:UIControlEventTouchUpInside];




}

- (void)changeOpenStatus:(id)sender {
    
    if (isOpened) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *closeImage=[UIImage imageNamed:@"icon_down"];
            [_openButton setImage:closeImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            
            frame.size.height=1;
            [_tb setFrame:frame];
            
            CGRect viewFrame = self.frame;
            
            viewFrame.size.height = 30;
            [self setFrame:viewFrame];

            
        } completion:^(BOOL finished){
            
            isOpened=NO;
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *openImage=[UIImage imageNamed:@"icon_up"];
            [_openButton setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            
            frame.size.height=_arrayResult.count * 30;
            [_tb setFrame:frame];
            
            CGRect viewFrame = self.frame;
            
            viewFrame.size.height = _arrayResult.count * 30 + 30;
            [self setFrame:viewFrame];
            
            [superView bringSubviewToFront:self];
            NSLog(@"%@",superView);
        } completion:^(BOOL finished){
            
            isOpened=YES;
        }];
        
        
    }
    
}

- (void)dealloc
{
    [superView release];
    [super dealloc];
}

@end
