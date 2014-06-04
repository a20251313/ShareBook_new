//
//  MapViewController.m
//  
//
//  Created by Jian-Ye on 12-10-16.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "MapViewController.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#define span 40000

@interface MapViewController ()
{
    NSMutableArray *_annotationList;
    
    CalloutMapAnnotation *_calloutAnnotation;
	CalloutMapAnnotation *_previousdAnnotation;
    
}
-(void)setAnnotionsWithList:(NSArray *)list;

@end

@implementation MapViewController

@synthesize mapView=_mapView;
@synthesize target;
@synthesize delegate,arrayResuce = _arrayResuce;
DEF_SIGNAL(TOUCHANNITION)
- (void)dealloc
{
    [target release];
    [_mapView release];
    [_annotationList release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self viewDidLoad];
    }
    return  self;
}


- (void)viewDidLoad
{
    _annotationList = [[NSMutableArray alloc] init];
    
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f,CGRectGetHeight(self.frame))];
    _mapView.mapType=MKMapTypeStandard;
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
    [self addSubview:_mapView];
    RELEASE(_mapView);

//    [super viewDidLoad];
}

-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list) {
        
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        NSString *annotationTag = [dic objectForKey:@"circle_id"];
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span ,span );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        [annotation setTag:[annotationTag intValue]];
        [_mapView   addAnnotation:annotation];
    }
    
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[[CalloutMapAnnotation alloc] 
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude] autorelease];
        _calloutAnnotation.tag = ((BasicMapAnnotation *)view.annotation).tag;
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else if([view.annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        CalloutMapAnnotation *map = (CalloutMapAnnotation *)view.annotation;
        
        NSDictionary *dictInfo1 = nil;
        
        for (NSDictionary *dictInfo in _arrayResuce) {
            NSString *tempTag = [dictInfo objectForKey:@"circle_id"];
            
            if (map.tag == [tempTag intValue]) {
                dictInfo1 = dictInfo;
            }
        }

        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
            [delegate customMKMapViewDidSelectedWithInfo:dictInfo1];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            CalloutMapAnnotation *oldAnnotation = _calloutAnnotation; //saving it to be removed from the map later
            _calloutAnnotation = nil; //setting to nil to know that we aren't showing a callout anymore
            dispatch_async(dispatch_get_main_queue(), ^{
                [mapView removeAnnotation:oldAnnotation]; //removing the annotation a bit later
            });
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {

        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
            
            int tag = ((CalloutMapAnnotation *)annotation).tag;
            
            NSDictionary *dictInfo1 = nil;
            
            for (NSDictionary *dictInfo in _arrayResuce) {
                NSString *tempTag = [dictInfo objectForKey:@"circle_id"];
            
                if (tag == [tempTag intValue]) {
                    dictInfo1 = dictInfo;
                }
            }
            
            JingDianMapCell *cell = [[JingDianMapCell alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 60) dictInfo:dictInfo1];
            cell.targetObjc  = self;
            [annotationView.contentView addSubview:cell];
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
         MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation 
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"icon_pin.png"];
        }
		
		return annotationView;
    }
	return nil;
}
- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}

#pragma mark - back button signal
//- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
//{
//    if ([signal is:[DYBBaseViewController BACKBUTTON]])
//    {
//        [self.drNavigationController popViewControllerAnimated:YES];
//    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
//    }
//}

@end
