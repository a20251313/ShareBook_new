//
//  JFSegmentControlView.m
//  cocacolaOA
//
//  Created by Joshon on 14-5-4.
//
//

#import "JFSegmentControlView.h"

#define MAINCOLOR           COLOR_RGB(0, 156, 204)
#define MAXSEGCOUNT         10
//30
@implementation JFSegmentControlView
@synthesize segCount = m_isegCount;
@synthesize items = m_arrayItems;
@synthesize index = m_iIndex;
@synthesize delegate;
@synthesize btnBgColor = m_btnBgColor;
@synthesize btnBgSelectColor = m_btnBgSelectColor;
@synthesize btnTextColor = m_btnTextColor;
@synthesize btnTextSelectColor = m_btnTextSelectColor;
@synthesize segLineViewBgColor = m_segLineViewBgColor;
@synthesize needRedAngel = m_bisneedRedAngel;
@synthesize borderColor = m_borderColor;



-(id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"must use method initWithFrame:withitems: init" format:nil];
    return nil;
}
- (id)initWithFrame:(CGRect)frame withitems:(NSArray*)newitems
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.btnBgColor = [UIColor whiteColor];
        self.btnBgSelectColor  =   MAINCOLOR;
        self.btnTextColor = MAINCOLOR;
        self.btnTextSelectColor = [UIColor whiteColor];
        self.segLineViewBgColor = MAINCOLOR;
        self.needRedAngel = YES;
        self.borderColor = MAINCOLOR;
        m_isegCount = [newitems count];
        self.items = newitems;
        
      
        // Initialization code
    }
    return self;
}


-(void)setItems:(NSArray *)newitems
{
    if (m_arrayItems != newitems)
    {
        m_arrayItems = newitems;
    }
    [self drawButtonsAndSegLine];
    
}


-(void)drawButtonsAndSegLine
{
  
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView  *bgView = [self viewWithTag:1000];
    if (!bgView)
    {
        bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.layer.cornerRadius = 8;
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderColor = self.borderColor.CGColor;
        bgView.layer.borderWidth = 0.5;
        [self addSubview:bgView];
        bgView.tag = 1000;
    }
    
    //move btns and segViews
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton *btn = (UIButton*)[bgView viewWithTag:i];
        [btn removeFromSuperview];
        UIView  *segView = [bgView viewWithTag:100+i];
        [segView removeFromSuperview];
    }
    
    CGFloat fsepLinewidth = 0.5;
    CGFloat fwidth = roundf((self.frame.size.width-(self.items.count-1)*fsepLinewidth)/(self.items.count*1.0));
    CGFloat fxpoint = 0;
    for (int i = 0; i < self.items.count; i++)
    {
        UIButton    *btn = [[UIButton alloc] initWithFrame:CGRectMake(fxpoint, 0, fwidth, self.frame.size.height)];
        [btn setBackgroundColor:self.btnBgColor];
        [btn setTitle:[self.items objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSegIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [bgView addSubview:btn];
        btn.tag = i;
        
       
        
        if (i == self.items.count-1)
        {
            [btn setFrame:CGRectMake(fxpoint, 0, self.frame.size.width-fxpoint, self.frame.size.height)];
            
        }else
        {
            fxpoint += fwidth;
            UIView  *viewLine = [[UIView alloc] initWithFrame:CGRectMake(fxpoint, 0, fsepLinewidth, self.frame.size.height)];
            viewLine.backgroundColor = self.segLineViewBgColor;
            [bgView addSubview:viewLine];
            viewLine.tag = 100+i;
            fxpoint += fsepLinewidth;
            
        }
        
    }
       [self setIndex:0];
    
    
   
}


-(void)setBorderColor:(UIColor *)newborderColor
{
    if (m_borderColor != newborderColor)
    {
        m_borderColor = newborderColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    bgView.layer.borderColor = newborderColor.CGColor;
    
}


-(void)setBtnBgColor:(UIColor *)newbtnBgColor
{
    if (m_btnBgColor != newbtnBgColor)
    {
        m_btnBgColor = newbtnBgColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton    *btn = (UIButton*)[bgView viewWithTag:i];
        if (!btn.selected)
        {
            [btn setBackgroundColor:newbtnBgColor];
        }
    }
    
    
}
-(void)setBtnBgSelectColor:(UIColor *)newbtnBgSelectColor
{
    if (m_btnBgSelectColor != newbtnBgSelectColor)
    {
        m_btnBgSelectColor = newbtnBgSelectColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton    *btn = (UIButton*)[bgView viewWithTag:i];
        if (btn.selected)
        {
            [btn setBackgroundColor:newbtnBgSelectColor];
        }
    }
}

-(void)setBtnTextColor:(UIColor *)newbtnTextColor
{
    if (m_btnTextColor != newbtnTextColor)
    {
        m_btnTextColor = newbtnTextColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton    *btn = (UIButton*)[bgView viewWithTag:i];
        [btn setTitleColor:newbtnTextColor forState:UIControlStateNormal];
    }
    
}
-(void)setBtnTextSelectColor:(UIColor *)newbtnTextSelectColor
{
    if (m_btnTextSelectColor != newbtnTextSelectColor)
    {
        m_btnTextSelectColor = newbtnTextSelectColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton    *btn = (UIButton*)[bgView viewWithTag:i];
        [btn setTitleColor:newbtnTextSelectColor forState:UIControlStateSelected];
    }
    
}


-(void)setNeedRedAngel:(BOOL)needRedAngel
{
    m_bisneedRedAngel = needRedAngel;
    UIImageView *indexView = (UIImageView*)[self viewWithTag:10000];
    indexView.hidden = !m_bisneedRedAngel;
}


-(void)setSegLineViewBgColor:(UIColor *)segLineViewBgColor
{
    if (m_segLineViewBgColor != segLineViewBgColor)
    {
        m_segLineViewBgColor = segLineViewBgColor;
    }
    
    UIView  *bgView = [self viewWithTag:1000];
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIView    *segView = (UIView*)[bgView viewWithTag:100+i];
        [segView setBackgroundColor:m_segLineViewBgColor];
    }
    
}




-(void)clickSegIndex:(UIButton*)sender
{
    [self setIndex:sender.tag];
    
    
    if (delegate && [delegate respondsToSelector:@selector(segIndexChanged:)])
    {
        [delegate segIndexChanged:m_iIndex];
    } 
}

-(void)setIndex:(NSInteger)newInter
{
    if (newInter >= self.items.count || newInter < 0)
    {
       // DEBUGLog(@"setIndex fail:%ld",(long)newInter);
        return;
    }
    UIView  *bgView = [self viewWithTag:1000];
    
    m_iIndex = newInter;
    
    //set btn as select or unselect
    for (int i = 0; i < MAXSEGCOUNT; i++)
    {
        UIButton    *btn = (UIButton*)[bgView viewWithTag:i];
        UIView      *segView = [bgView viewWithTag:100+i];
        if (i != m_iIndex)
        {
            [btn setSelected:NO];
        }else
        {
            [btn setSelected:YES];
        }
        
        [segView setBackgroundColor:self.segLineViewBgColor];
        
        if (btn.isSelected)
        {
            [btn setBackgroundColor:self.btnBgSelectColor];
        }else
        {
            [btn setBackgroundColor:self.btnBgColor];
        }
        
        [btn setTitleColor:self.btnTextColor forState:UIControlStateNormal];
        [btn setTitleColor:self.btnTextSelectColor forState:UIControlStateSelected];
    }
    
    
    
    UIImageView *indexView = (UIImageView*)[self viewWithTag:10000];
    if (!indexView)
    {
        indexView = [[UIImageView alloc] initWithFrame:CGRectMake(7, self.frame.size.height, 13, 8)];
        indexView.image = [UIImage imageNamed:@"red_angle.png"];
        [self addSubview:indexView];
        indexView.tag = 10000;
    }
    
    indexView.hidden = !self.needRedAngel;
   
    CGFloat fbtnWidth = [bgView viewWithTag:m_iIndex].frame.size.width;
    CGFloat fxpoint = [bgView viewWithTag:m_iIndex].frame.origin.x;
    
    if (m_iIndex == 0)
    {
        fxpoint += 8;
    }else if(m_iIndex == self.items.count-1)
    {
        fxpoint += fbtnWidth-20;
    }else
    {
        fxpoint += fbtnWidth/2-indexView.frame.size.width/2;
    }
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDuration:0.25];
    [indexView setFrame:CGRectMake(fxpoint, self.frame.size.height, indexView.frame.size.width, indexView.frame.size.height)];
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
