//
//  AddLocationViewController.h
//  PokemonFindDemo
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pokemon;
@interface AddLocationViewController : UIViewController

@property (nonatomic, copy) void(^selectLocationBlock)(Pokemon *pokemon);

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pokemoIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField; // 经度编辑框
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField; // 纬度编辑框

@end
