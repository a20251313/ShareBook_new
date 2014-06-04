




#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "DYBBaseViewController.h"
@protocol MapViewControllerDidSelectDelegate; 
@interface MapViewController : UIView<MKMapViewDelegate>
{
    MKMapView *_mapView;
    
    
    id<MapViewControllerDidSelectDelegate> delegate;
}
@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,retain)NSMutableArray *arrayResuce;

@property (nonatomic,retain)id target;
@property(nonatomic,assign)id<MapViewControllerDidSelectDelegate> delegate;
AS_SIGNAL(TOUCHANNITION)
- (void)resetAnnitations:(NSArray *)data;
@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;
- (void)customMKMapViewDidSelectedAnnitationWithInfo:(id)info;
@end