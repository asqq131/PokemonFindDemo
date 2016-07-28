//
//  ViewController.h
//  PokemonFindDemo
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PokemonSearchType) {
    PokemonSearchTypeDefault,
    PokemonSearchTypeMoreLocation,
    PokemonSearchTypeRange
};

@class AVAudioPlayer;
@interface ViewController : UIViewController

@property (assign, nonatomic) PokemonSearchType pokemonSearchType; // 搜索类型
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // 滑动scrollview

@property (weak, nonatomic) IBOutlet UIButton *startBtn; // 启动搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *stopBtn; // 停止搜索按钮
@property (weak, nonatomic) IBOutlet UISwitch *rangeSwitch; // 范围搜索开关
@property (weak, nonatomic) IBOutlet UISwitch *moreLocationSwitch; // 多重定位搜索开关

@property (weak, nonatomic) IBOutlet UIView *oneLocationView; // 单定位搜索view
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField; // 经度编辑框
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField; // 纬度编辑框
@property (weak, nonatomic) IBOutlet UITextField *pokemoIdTextField; // 精灵ID编辑框
@property (weak, nonatomic) IBOutlet UITextField *pokemonNameTextField; // 精灵名称编辑框

@property (weak, nonatomic) IBOutlet UIView *moreLocationView; // 多重定位搜索view
@property (weak, nonatomic) IBOutlet UITableView *moreLocationTableView; // 精灵数据tableview
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn; // 添加精灵按钮

@property (weak, nonatomic) IBOutlet UIView *rangeView; // 范围搜索view
@property (weak, nonatomic) IBOutlet UITextField *rangePokemonIdTextField; // 精灵ID编辑框
@property (weak, nonatomic) IBOutlet UITextField *rangePokemonNameTextField; // 精灵名称编辑框
@property (weak, nonatomic) IBOutlet UITextField *minLatitudeTextField; // 最小纬度值编辑框
@property (weak, nonatomic) IBOutlet UITextField *maxLatitudeTextField; // 最大纬度值编辑框
@property (weak, nonatomic) IBOutlet UITextField *minLongitudeTextField; // 最小经度值编辑框
@property (weak, nonatomic) IBOutlet UITextField *maxLongitudeTextField; // 最大经度值编辑框

@property (nonatomic,strong) AVAudioPlayer *audioPlayer; //播放器

- (IBAction)startSearch:(UIButton *)sender;
- (IBAction)stopSearch:(UIButton *)sender;
- (IBAction)rangeSwitchValueChanged:(UISwitch *)sender;
- (IBAction)moreLocationSwitchValueChanged:(UISwitch *)sender;
- (IBAction)addLocationAction:(UIButton *)sender;

@end

