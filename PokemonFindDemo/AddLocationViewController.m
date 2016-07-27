//
//  AddLocationViewController.m
//  PokemonFindDemo
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "AddLocationViewController.h"
#import "Pokemon.h"

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
    NSInteger pokemonId = [[_pokemoIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue]; // 精灵ID
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 精灵名
    NSString *longitude = [_longitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 经度
    NSString *latitude = [_latitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 纬度
    
    if ([longitude isEqualToString:@""] || [latitude isEqualToString:@""] || !longitude || !latitude) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请填写经/纬度" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    Pokemon *pokemon = [Pokemon pokemonWithPokemonId:pokemonId andName:name andLatitude:[latitude floatValue] andLongitude:[longitude floatValue]];
    _selectLocationBlock(pokemon);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
