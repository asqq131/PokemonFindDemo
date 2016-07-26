//
//  AddLocationViewController.m
//  PokemonFindDemo
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "AddLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AddLocationViewController ()

@end

@implementation AddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加定位搜索坐标";
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(comfingAction:)];
    self.navigationItem.rightBarButtonItem = barBtnItem;
}

- (void)comfingAction:(UIBarButtonItem *)sender {
    NSString *longitude = [_longitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 经度
    NSString *latitude = [_latitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 纬度
    
    if ([longitude isEqualToString:@""] || [latitude isEqualToString:@""] || !longitude || !latitude) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请填写经/纬度" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    _selectLocationBlock(location);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
