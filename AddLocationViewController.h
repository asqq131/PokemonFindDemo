//
//  AddLocationViewController.h
//  PokemonFindDemo
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@interface AddLocationViewController : UIViewController

@property (nonatomic, copy) void(^selectLocationBlock)(CLLocation *location);

@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField; // 经度编辑框
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField; // 纬度编辑框

@end
