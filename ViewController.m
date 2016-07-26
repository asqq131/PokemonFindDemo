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
    
    _isSearchLapras = YES;
    if (_isSearchLapras) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:37.77075800 longitude:-122.48725300];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:37.77492950 longitude:-122.4194155];
        CLLocation *location3 = [[CLLocation alloc] initWithLatitude:37.77484901 longitude:-122.51171529];
        CLLocation *location4 = [[CLLocation alloc] initWithLatitude:37.810062 longitude:-122.421890];
        _moreLocationArray = [NSMutableArray arrayWithArray:@[location1, location2, location3, location4]];
        pokemonId = 131;
        
    } else if (_isSearchSnorlax) {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:37.76667776582661 longitude:-122.49135732650757];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:37.80602037076846 longitude:-122.46837615966797];
        CLLocation *location3 = [[CLLocation alloc] initWithLatitude:37.74259553070687 longitude:-122.41493582725523];
        CLLocation *location4 = [[CLLocation alloc] initWithLatitude:37.79875119770314 longitude:-122.47482419013977];
        CLLocation *location5 = [[CLLocation alloc] initWithLatitude:37.77168154377704 longitude:-122.47600436210632];
        CLLocation *location6 = [[CLLocation alloc] initWithLatitude:37.824022798368375 longitude:-122.36984252929688];
        CLLocation *location7 = [[CLLocation alloc] initWithLatitude:37.76297984117803 longitude:-122.47702360153197];
        CLLocation *location8 = [[CLLocation alloc] initWithLatitude:37.788335748021495 longitude:-122.43685483932494];
        CLLocation *location9 = [[CLLocation alloc] initWithLatitude:37.804024068552096 longitude:-122.42804646492004];
        CLLocation *location10 = [[CLLocation alloc] initWithLatitude:37.80851673221186 longitude:-122.41245210170747];
        CLLocation *location11 = [[CLLocation alloc] initWithLatitude:37.80226507389669 longitude:-122.4129295349121];
        CLLocation *location12 = [[CLLocation alloc] initWithLatitude:37.77311476694162 longitude:-122.44287371635437];
        _moreLocationArray = [NSMutableArray arrayWithArray:@[location1, location2, location3, location4, location5, location6, location7, location8, location9, location10, location11, location12]];
        pokemonId = 143;
    }
    _emptyLocationTipLabel.hidden = !(_moreLocationArray.count == 0);
    
    _longitudeTextField.text = longitude;
    _latitudeTextField.text = latitude;
    _pokemoIdTextField.text = [NSString stringWithFormat:@"%ld", (long)pokemonId];
    
    _moreLocationView.hidden = YES;
    _moreLocationTableView.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0].CGColor;
    _moreLocationTableView.layer.borderWidth = 0.5;
    _moreLocationTableView.tableFooterView = [[UIView alloc] init];
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
- (void)searchRequestWithLongitude:(NSString *)longitude andLatitude:(NSString *)latitude andPokemonId:(NSInteger)pokemonId {
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:longitude forKey:saveLongitude];
            [userDefaults setValue:latitude forKey:saveLatitude];
            [userDefaults setInteger:pokemonId forKey:savePokemonFindId];
            
            for (NSDictionary *dict in responseArray) {
                if ([dict[@"pokemonId"] integerValue] == pokemonId) {
                    [self play]; // 放音乐提示
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"目标位置" message:[NSString stringWithFormat:@"纬度:%f---经度:%f", [dict[@"latitude"] floatValue], [dict[@"longitude"] floatValue]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerView show];
                    
                    break;
                }
            }
            
            // 回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                // dosomething
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
    CLLocation *location = _moreLocationArray[indexPath.row];
    
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
    cell.textLabel.text = latitude;
    cell.detailTextLabel.text = longitude;
    
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
    NSInteger pokemonId = [[_pokemoIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue]; // 精灵ID
    
    if (!_moreLocationSwitch.on && !_rangeSwitch.on) {
        NSString *longitude = [_longitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 经度
        NSString *latitude = [_latitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 纬度
        
        if ([longitude isEqualToString:@""] || [latitude isEqualToString:@""] || !longitude || !latitude) return;
        
        [self showHudInView:self.view hint:nil];
        [self searchRequestWithLongitude:longitude andLatitude:latitude andPokemonId:pokemonId];
        
    } else if (_moreLocationSwitch.on) {
        // 异步
        if (_moreLocationArray.count > 0) [self showHudInView:self.view hint:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (CLLocation *location in _moreLocationArray) {
                NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
                NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
                
                [self searchRequestWithLongitude:longitude andLatitude:latitude andPokemonId:pokemonId];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先停止搜索" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    if (sender.isOn) {
        _moreLocationSwitch.on = NO;
        _moreLocationView.hidden = YES;
    }
}

#pragma mark 多重定位搜索
- (IBAction)moreLocationSwitchValueChanged:(UISwitch *)sender {
    if (_timer) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先停止搜索" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    _moreLocationView.hidden = !sender.isOn;
    if (sender.isOn) {
        _rangeSwitch.on = NO;
    }
}

#pragma mark 添加多重定位按钮事件
- (IBAction)addLocationAction:(UIButton *)sender {
    AddLocationViewController *addLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddLocationViewController"];
    
    addLocationViewController.selectLocationBlock = ^(CLLocation *location) {
        [_moreLocationArray addObject:location];
        [_moreLocationTableView reloadData];
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
