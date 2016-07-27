//
//  ViewController.m
//  PokemonFindDemo
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AddLocationViewController.h"
#import "UIViewController+HUD.h"
#import "WConstants.h"
#import "Pokemon.h"

#define timeInterval 30

#define saveLongitude @"saveLongitude"
#define saveLatitude @"saveLatitude"
#define savePokemonFindId @"savePokemonFindId"

#define defaultPokemonFindId 1
//#define defaultLongitude @"-122.477388381958"
//#define defaultLatitude @"37.79937429771308"

#define defaultLongitude @"-122.487253" // 经度
#define defaultLatitude @"37.770758" // 纬度

#define kMusicFile @"music.mp3"

@interface ViewController () <UITextFieldDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSTimer *_timer;
    
    NSMutableArray *_moreLocationArray;
    
    BOOL _isSearchSnorlax; // 是否搜索卡比兽
    BOOL _isSearchLapras; // 是否搜索乘龙
}

@property (weak, nonatomic) IBOutlet UILabel *emptyLocationTipLabel;

@end

@implementation ViewController

/** 
 *  乘龙
 *  37.77075800    -122.48725300
 *  37.77492950    -122.4194155
 *  37.77484901    -122.51171529
 *  37.810062      -122.421890
 **/

/**
*  卡比兽
*  37.76667776582661    -122.49135732650757
*  37.80602037076846    -122.46837615966797
*  37.74259553070687    -122.41493582725523
*  37.79875119770314    -122.47482419013977
*  37.77168154377704    -122.47600436210632
*  37.824022798368375   -122.36984252929688
*  37.76297984117803    -122.47702360153197
*  37.788335748021495   -122.43685483932494
*  37.804024068552096   -122.42804646492004
*  37.80851673221186    -122.41245210170747
*  37.80226507389669    -122.4129295349121
*  37.77311476694162    -122.44287371635437
**/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"pokemon小精灵搜索";
    _moreLocationArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [userDefaults valueForKey:saveLongitude]; // 经度
    NSString *latitude = [userDefaults valueForKey:saveLatitude]; // 纬度
    NSInteger pokemonId = [userDefaults integerForKey:savePokemonFindId];
    
    if (!longitude || !latitude) {
        longitude = defaultLongitude;
        latitude = defaultLatitude;
    }
    
    if (!pokemonId) {
        pokemonId = defaultPokemonFindId;
    }
    
    _longitudeTextField.text = longitude;
    _latitudeTextField.text = latitude;
    _pokemoIdTextField.text = [NSString stringWithFormat:@"%ld", (long)pokemonId];
    
    _moreLocationTableView.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0].CGColor;
    _moreLocationTableView.layer.borderWidth = 0.5;
    _moreLocationTableView.tableFooterView = [[UIView alloc] init];
    
    _rangeSwitch.enabled = NO;
    
    // 自定义添加搜索精灵坐标
    _isSearchLapras = YES;
    _isSearchSnorlax = YES;
    [self customAddLocation];
    _emptyLocationTipLabel.hidden = !(_moreLocationArray.count == 0);
}

- (void)customAddLocation {
    NSInteger pokemonId = defaultPokemonFindId;
    
    if (_isSearchLapras) {
        pokemonId = 131;
        
        Pokemon *pokemon1 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.77075800 andLongitude:-122.48725300];
        Pokemon *pokemon2 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.77492950 andLongitude:-122.4194155];
        Pokemon *pokemon3 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.77484901 andLongitude:-122.51171529];
        Pokemon *pokemon4 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.810062 andLongitude:-122.421890];
        Pokemon *pokemon5 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.778296157302 andLongitude:-122.51442288082];
        [_moreLocationArray addObjectsFromArray:@[pokemon1, pokemon2, pokemon3, pokemon4, pokemon5]];
        
    }
    
    if (_isSearchSnorlax) {
        pokemonId = 143;
        
        Pokemon *pokemon1 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.76667776582661 andLongitude:-122.49135732650757];
        Pokemon *pokemon2 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.80602037076846 andLongitude:-122.46837615966797];
        Pokemon *pokemon3 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.74259553070687 andLongitude:-122.41493582725523];
        Pokemon *pokemon4 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.79875119770314 andLongitude:-122.47482419013977];
        Pokemon *pokemon5 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.77168154377704 andLongitude:-122.47600436210632];
        Pokemon *pokemon6 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.824022798368375 andLongitude:-122.36984252929688];
        Pokemon *pokemon7 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.76297984117803 andLongitude:-122.47702360153197];
        Pokemon *pokemon8 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.788335748021495 andLongitude:-122.43685483932494];
        Pokemon *pokemon9 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.804024068552096 andLongitude:-122.42804646492004];
        Pokemon *pokemon10 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.80851673221186 andLongitude:-122.41245210170747];
        Pokemon *pokemon11 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.80226507389669 andLongitude:-122.4129295349121];
        Pokemon *pokemon12 = [Pokemon pokemonWithPokemonId:pokemonId andLatitude:37.77311476694162 andLongitude:-122.44287371635437];
        [_moreLocationArray addObjectsFromArray:@[pokemon1, pokemon2, pokemon3, pokemon4, pokemon5, pokemon6, pokemon7, pokemon8, pokemon9, pokemon10, pokemon11, pokemon12]];
    }
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTimer {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    
    _timer = nil;
}

/**
 *  播放音频
 */
- (void)play {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
}

/**
 *  暂停播放
 */
- (void)pause {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
    }
}

#pragma mark 搜索请求
- (void)searchRequestWithPokemonId:(NSInteger)pokemonId andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
    NSString *urlString = [NSString stringWithFormat:@"https://pokevision.com/map/data/%@/%@", latitude, longitude];
    
    NSLog(@"%@", urlString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideHud];
        
//        NSLog(@"%@", responseObject);
        NSArray *responseArray = ((NSDictionary *)responseObject)[@"pokemon"];
        NSLog(@"%@", responseObject[@"status"]);
        
        // 异步
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (_pokemonSearchType == PokemonSearchTypeDefault) { // 默认是单点定位搜索的话，存储搜索条件
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:longitude forKey:saveLongitude];
                [userDefaults setValue:latitude forKey:saveLatitude];
                [userDefaults setInteger:pokemonId forKey:savePokemonFindId];
            }
            
            BOOL isFinded = NO;
            NSDictionary *targetDict;
            for (NSDictionary *dict in responseArray) {
                if ([dict[@"pokemonId"] integerValue] == pokemonId) {
                    isFinded = YES;
                    targetDict = dict;
                    
                    break;
                }
            }
            
            // 回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isFinded) {
                    [self stopSearch:_stopBtn]; // 停止搜索
                    [self play]; // 放音乐提示
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"目标位置" message:[NSString stringWithFormat:@"纬度:%f---经度:%f", [targetDict[@"latitude"] floatValue], [targetDict[@"longitude"] floatValue]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerView show];
                }
            });
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        NSLog(@"%@", error);
    }];
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _moreLocationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    _emptyLocationTipLabel.hidden = YES;
    Pokemon *pokemon = _moreLocationArray[indexPath.row];
    
    NSString *pokemonId = [NSString stringWithFormat:@"%ld", (long)pokemon.pokemonId];
    NSString *longitude = [NSString stringWithFormat:@"%f", pokemon.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f", pokemon.latitude];
    
    cell.textLabel.text = pokemonId;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_moreLocationArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    _emptyLocationTipLabel.hidden = !(_moreLocationArray.count == 0);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 找到小精灵
        [self pause];
    }
}

#pragma mark event

- (void)timerLoop {
    if (!_moreLocationSwitch.on && !_rangeSwitch.on) {
        NSInteger pokemonId = [[_pokemoIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue]; // 精灵ID
        NSString *longitude = [_longitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 经度
        NSString *latitude = [_latitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 纬度
        
        if ([longitude isEqualToString:@""] || [latitude isEqualToString:@""] || !longitude || !latitude) return;
        
        [self showHudInView:self.view hint:nil];
        [self searchRequestWithPokemonId:pokemonId andLatitude:latitude andLongitude:longitude];
        
    } else if (_moreLocationSwitch.on) {
        // 异步
        if (_moreLocationArray.count > 0) [self showHudInView:self.view hint:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Pokemon *pokemon in _moreLocationArray) {
                [self searchRequestWithPokemonId:pokemon.pokemonId andLatitude:[NSString stringWithFormat:@"%f", pokemon.latitude] andLongitude:[NSString stringWithFormat:@"%f", pokemon.longitude]];
            }
            
            // 回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                // dosomething
            });
        });
    }
}

- (IBAction)startSearch:(UIButton *)sender {
    if (sender.selected) return;
    
    [self.view endEditing:YES];
    
    [sender setTitle:@"已启动" forState:UIControlStateNormal];
    [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    
    _scrollView.userInteractionEnabled = _pokemonSearchType == PokemonSearchTypeMoreLocation;
    _longitudeTextField.enabled = NO;
    _latitudeTextField.enabled = NO;
    _pokemoIdTextField.enabled = NO;
    
    sender.selected = YES;
    _stopBtn.selected = NO;
    
    [self startTimer];
}

- (IBAction)stopSearch:(UIButton *)sender {
    if (sender.selected) return;
    
    [self.view endEditing:YES];
    
    [sender setTitle:@"已停止" forState:UIControlStateNormal];
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    
    _scrollView.userInteractionEnabled = YES;
    _longitudeTextField.enabled = YES;
    _latitudeTextField.enabled = YES;
    _pokemoIdTextField.enabled = YES;
    
    sender.selected = YES;
    _startBtn.selected = NO;
    
    [self stopTimer];
}

#pragma mark 范围搜索
- (IBAction)rangeSwitchValueChanged:(UISwitch *)sender {
    if (_timer) {
        sender.on = !sender.isOn;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先停止搜索" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    _pokemonSearchType = sender.isOn ? PokemonSearchTypeRange : PokemonSearchTypeDefault;
    
    if (sender.isOn) {
        _moreLocationSwitch.on = NO;
    }
}

#pragma mark 多重定位搜索
- (IBAction)moreLocationSwitchValueChanged:(UISwitch *)sender {
    if (_timer) {
        sender.on = !sender.isOn;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先停止搜索" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
//    _moreLocationView.hidden = !sender.isOn;
    _pokemonSearchType = sender.isOn ? PokemonSearchTypeMoreLocation : PokemonSearchTypeDefault;
    [_scrollView setContentOffset:CGPointMake(sender.isOn ? kScreenSize.width : 0, 0) animated:YES];
    
    if (sender.isOn) {
        _rangeSwitch.on = NO;
    }
}

#pragma mark 添加多重定位按钮事件
- (IBAction)addLocationAction:(UIButton *)sender {
    AddLocationViewController *addLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddLocationViewController"];
    
    addLocationViewController.selectLocationBlock = ^(Pokemon *pokemon) {
        [_moreLocationArray addObject:pokemon];
        [_moreLocationTableView reloadData];
        [_scrollView setContentOffset:CGPointMake(kScreenSize.width, 0) animated:NO];
    };
    
    [self.navigationController pushViewController:addLocationViewController animated:YES];
}

#pragma mark gettign setting

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:kMusicFile ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0; //设置为0不循环
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay]; //加载音频文件到缓存
        
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    
    return _audioPlayer;
}

@end
