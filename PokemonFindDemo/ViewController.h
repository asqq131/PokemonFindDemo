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

@property (assign, nonatomic) PokemonSearchType pokemonSearchType;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UISwitch *rangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *moreLocationSwitch;

@property (weak, nonatomic) IBOutlet UIView *oneLocationView;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField; // 经度编辑框
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField; // 纬度编辑框
@property (weak, nonatomic) IBOutlet UITextField *pokemoIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pokemonNameTextField;

@property (weak, nonatomic) IBOutlet UIView *moreLocationView;
@property (weak, nonatomic) IBOutlet UITableView *moreLocationTableView;
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn;

@property (weak, nonatomic) IBOutlet UIView *rangeView;
@property (weak, nonatomic) IBOutlet UITextField *rangePokemonIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *rangePokemonNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *minLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *minLongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxLongitudeTextField;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器

- (IBAction)startSearch:(UIButton *)sender;
- (IBAction)stopSearch:(UIButton *)sender;
- (IBAction)rangeSwitchValueChanged:(UISwitch *)sender;
- (IBAction)moreLocationSwitchValueChanged:(UISwitch *)sender;
- (IBAction)addLocationAction:(UIButton *)sender;

@end

