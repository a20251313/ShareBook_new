//
//  JFSegmentControlView.h
//  cocacolaOA
//
//  Created by Joshon on 14-5-4.
//
//

#import <UIKit/UIKit.h>

@protocol JFSegmentControlViewDelegate <NSObject>

-(void)segIndexChanged:(NSInteger)Nowindex;

@end


@interface JFSegmentControlView : UIView
{
    NSInteger           m_isegCount;
    NSArray             *m_arrayItems;
    NSInteger           m_iIndex;
    UIColor             *m_btnBgColor;
    UIColor             *m_btnBgSelectColor;
    UIColor             *m_btnTextColor;
    UIColor             *m_btnTextSelectColor;
    UIColor             *m_segLineViewBgColor;
    UIColor             *m_borderColor;
    BOOL                m_bisneedRedAngel;
}

@property(nonatomic)NSInteger   segCount;
@property(nonatomic)NSInteger   index;
@property(nonatomic,strong)NSArray     *items;
@property(nonatomic,strong)UIColor      *btnBgColor;    //未选中部分背景颜色
@property(nonatomic,strong)UIColor      *btnBgSelectColor;  //选中部分背景颜色
@property(nonatomic,strong)UIColor      *btnTextColor;//未选中部分文字颜色
@property(nonatomic,strong)UIColor      *btnTextSelectColor;    //选中部分文字颜色
@property(nonatomic,strong)UIColor      *segLineViewBgColor;    //分割线颜色
@property(nonatomic,strong)UIColor      *borderColor;           //边界线颜色 默认为白色
@property(nonatomic)BOOL                needRedAngel;           //是否需要倒三角
@property(nonatomic,weak)id<JFSegmentControlViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withitems:(NSArray*)newitems;
@end
