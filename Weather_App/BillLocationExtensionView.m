//
//  BillLocationExtensionView.m
//  Weather_App
//
//  Created by Rocky Young on 2018/4/5.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "BillLocationExtensionView.h"
#import <MapKit/MapKit.h>
#import "Masonry.h"

@interface BillLocationExtensionView ()<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView * mapView;
@property (nonatomic ,strong) UIView * mapMaskView;
@end

@implementation BillLocationExtensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        self.mapView = [[MKMapView alloc] init];
        self.mapView.zoomEnabled = NO;
        self.mapView.scrollEnabled = NO;
        self.mapView.rotateEnabled = NO;
        self.mapView.showsUserLocation = YES;
        self.mapView.delegate = self;
        [self addSubview:self.mapView];
        [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.mapMaskView = [[UIView alloc] init];
        self.mapMaskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
        [self addSubview:self.mapMaskView];
        [self.mapMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - MKMapViewDelegate

@end
