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
#define savePokemonFindName @"savePokemonFindName"

#define defaultPokemonFindId 1
//#define defaultLongitude @"-122.477388381958"
//#define defaultLatitude @"37.79937429771308"

#define defaultLongitude @"-122.487253" // 经度
#define defaultLatitude @"37.770758" // 纬度

#define kMusicFile @"music.mp3"

@interface ViewController () <UITextFieldDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSTimer *_timer;
    
    NSMutableArray *_moreLocationArray;
    NSArray *_rangePokemonIds;
    NSArray *_rangePokemonNames;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_scrollView setContentOffset:CGPointMake(_pokemonSearchType == PokemonSearchTypeDefault ? 0 : kScreenSize.width, 0) animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"pokemon小精灵搜索";
    _moreLocationArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger pokemonId = [userDefaults integerForKey:savePokemonFindId];
    NSString *pokemonName = [userDefaults valueForKey:savePokemonFindName];
    NSString *latitude = [NSString stringWithFormat:@"%f", [userDefaults floatForKey:saveLatitude]]; // 纬度
    NSString *longitude = [NSString stringWithFormat:@"%f", [userDefaults floatForKey:saveLongitude]]; // 经度
    
    if (!longitude || !latitude) {
        longitude = defaultLongitude;
        latitude = defaultLatitude;
    }
    
    if (!pokemonId) {
        pokemonId = defaultPokemonFindId;
    }
    
    // 设置定点搜索编辑框内容
    _pokemoIdTextField.text = [NSString stringWithFormat:@"%ld", (long)pokemonId];
    _pokemonNameTextField.text = pokemonName ? pokemonName : @"";
    _longitudeTextField.text = longitude;
    _latitudeTextField.text = latitude;
    
    // 多重搜索tableview样式设置
    _moreLocationTableView.layer.borderColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0].CGColor;
    _moreLocationTableView.layer.borderWidth = 0.5;
    _moreLocationTableView.tableFooterView = [[UIView alloc] init];
    
    // 自定义添加搜索精灵坐标
    _isSearchLapras = YES;
    _isSearchSnorlax = NO;
    [self customAddLocation];
    _emptyLocationTipLabel.hidden = !(_moreLocationArray.count == 0);
    
    /**
     * 1/41
     * 妙蛙种子/超音蝠
     * 37.801035 -> 37.807003
     * -122.4779033 -> -122.4722385
     */
    _rangePokemonIdTextField.text = @"1/41";
    _rangePokemonNameTextField.text = @"妙蛙种子/超音蝠";
    _minLatitudeTextField.text = @"37.801035";
    _maxLatitudeTextField.text = @"37.807003";
    _minLongitudeTextField.text = @"-122.4779033";
    _maxLongitudeTextField.text = @"-122.4722385";
}

- (void)customAddLocation {
    NSInteger pokemonId = defaultPokemonFindId;
    
    // 菊石兽
    Pokemon *pokemon1 = [Pokemon pokemonWithPokemonId:138 andName:@"菊石兽" andLatitude:37.76512991848991 andLongitude:-122.51146316528319];
    // 化石盔
    Pokemon *pokemon2 = [Pokemon pokemonWithPokemonId:140 andName:@"化石盔" andLatitude:37.748453519925434 andLongitude:-122.50889897346498];
    // 镰刀盔
    Pokemon *pokemon3 = [Pokemon pokemonWithPokemonId:141 andName:@"镰刀盔" andLatitude:37.748453519925434 andLongitude:-122.50889897346498];
    [_moreLocationArray addObjectsFromArray:@[pokemon1, pokemon2, pokemon3]];
    
    if (_isSearchLapras) {
        pokemonId = 131;
        
        Pokemon *pokemon1 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.77075800 andLongitude:-122.48725300];
        Pokemon *pokemon2 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.77492950 andLongitude:-122.4194155];
        Pokemon *pokemon3 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.77484901 andLongitude:-122.51171529];
        Pokemon *pokemon4 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.810062 andLongitude:-122.421890];
        Pokemon *pokemon5 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.778296157302 andLongitude:-122.51442288082];
        Pokemon *pokemon6 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"乘龙" andLatitude:37.773916172517694 andLongitude:-122.51287400722502];
        [_moreLocationArray addObjectsFromArray:@[pokemon1, pokemon2, pokemon3, pokemon4, pokemon5, pokemon6]];
        
    }
    
    if (_isSearchSnorlax) {
        pokemonId = 143;
        
        Pokemon *pokemon1 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.76667776582661 andLongitude:-122.49135732650757];
        Pokemon *pokemon2 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.80602037076846 andLongitude:-122.46837615966797];
        Pokemon *pokemon3 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.74259553070687 andLongitude:-122.41493582725523];
        Pokemon *pokemon4 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.79875119770314 andLongitude:-122.47482419013977];
        Pokemon *pokemon5 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.77168154377704 andLongitude:-122.47600436210632];
        Pokemon *pokemon6 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.824022798368375 andLongitude:-122.36984252929688];
        Pokemon *pokemon7 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.76297984117803 andLongitude:-122.47702360153197];
        Pokemon *pokemon8 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.788335748021495 andLongitude:-122.43685483932494];
        Pokemon *pokemon9 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.804024068552096 andLongitude:-122.42804646492004];
        Pokemon *pokemon10 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.80851673221186 andLongitude:-122.41245210170747];
        Pokemon *pokemon11 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.80226507389669 andLongitude:-122.4129295349121];
        Pokemon *pokemon12 = [Pokemon pokemonWithPokemonId:pokemonId andName:@"卡比兽" andLatitude:37.77311476694162 andLongitude:-122.44287371635437];
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
- (void)searchRequestWithPokemon:(Pokemon *)pokemon {
    NSString *urlString = [NSString stringWithFormat:@"https://pokevision.com/map/data/%f/%f", pokemon.latitude, pokemon.longitude];
    
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
                [userDefaults setInteger:pokemon.pokemonId forKey:savePokemonFindId];
                [userDefaults setFloat:pokemon.latitude forKey:saveLatitude];
                [userDefaults setFloat:pokemon.longitude forKey:saveLongitude];
                
                if (pokemon.name && ![pokemon.name isEqualToString:@""]) {
                    [userDefaults setValue:pokemon.name forKey:savePokemonFindName];
                }
            }
            
            BOOL isFinded = NO;
            NSDictionary *targetDict;
            NSMutableString *rangeFindedMessage = [NSMutableString string];
            for (NSDictionary *dict in responseArray) {
                if (_rangeSwitch.isOn) {
                    for (int i = 0; i < _rangePokemonIds.count; i++) {
                        NSInteger pokemonId = [_rangePokemonIds[i] integerValue];
                        if ([dict[@"pokemonId"] integerValue] == pokemonId) {
                            isFinded = YES;
                            targetDict = dict;
                            
                            NSString *findedUrlString = [NSString stringWithFormat:@"https://pokevision.com/#/@%f,%f", [targetDict[@"latitude"] floatValue], [targetDict[@"longitude"] floatValue]];
                            NSString *pokemonName = i < _rangePokemonNames.count ? _rangePokemonNames[i] : @"";
                            
                            NSLog(@"%@ ---> %@", findedUrlString, pokemonName);
                            
                            // 拼装范围搜索提示语
                            NSString *tip = [NSString stringWithFormat:@"%@位于 ---> 纬度:%f---经度:%f\n", pokemonName, [targetDict[@"latitude"] floatValue], [targetDict[@"longitude"] floatValue]];
                            [rangeFindedMessage appendString:tip];
                            
                            break;
                        }
                    }
                    
                } else {
                    if ([dict[@"pokemonId"] integerValue] == pokemon.pokemonId) {
                        isFinded = YES;
                        targetDict = dict;
                        
                        NSString *findedUrlString = [NSString stringWithFormat:@"https://pokevision.com/#/@%f,%f", [targetDict[@"latitude"] floatValue], [targetDict[@"longitude"] floatValue]];
                        NSLog(@"%@", findedUrlString);
                        
                        break;
                    }
                }
            }
            
            // 回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isFinded) {
                    [self stopSearch:_stopBtn]; // 停止搜索
                    [self play]; // 放音乐提示
                    
                    NSString *targetName = pokemon.name ? pokemon.name : [NSString stringWithFormat:@"%ld", (long)pokemon.pokemonId];
                    NSString *title = _rangeSwitch.isOn ? @"目标" : [NSString stringWithFormat:@"目标%@位置", targetName];
                    NSString *message = _rangeSwitch.isOn ? rangeFindedMessage : [NSString stringWithFormat:@"纬度:%f---经度:%f", [targetDict[@"latitude"] floatValue], [targetDict[@"longitude"] floatValue]];
                    
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerView show];
                }
            });
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        NSLog(@"%@", error);
    }];
}

- (void)rangeSearchPokemon {
    // 精灵id
    NSString *rangePokemonIds = [_rangePokemonIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _rangePokemonIds = [rangePokemonIds componentsSeparatedByString:@"/"];
    
    // 精灵名称
    NSString *rangePokemonNames = [_rangePokemonNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _rangePokemonNames = [rangePokemonNames componentsSeparatedByString:@"/"];
    
    // 经纬度范围
    NSString *minLatitude = [_minLatitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *maxLatitude = [_maxLatitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *minLongitude = [_minLongitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *maxLongitude = [_maxLongitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 范围内随机经纬度
    CGFloat latitude = [self randFloatBetween:[minLatitude floatValue] and:[maxLatitude floatValue]];
    CGFloat longitude = [self randFloatBetween:[minLongitude floatValue] and:[maxLongitude floatValue]];
    
    if (_rangePokemonIds.count > 0) [self showHudInView:self.view hint:nil];
    [self searchRequestWithPokemon:[Pokemon pokemonWithPokemonId:0 andName:nil andLatitude:latitude andLongitude:longitude]];
}

#pragma mark 浮点随机数
- (float)randFloatBetween:(float)low and:(float)high {
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
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
    
    NSString *text;
    if (pokemon.name && ![pokemon.name isEqualToString:@""]) {
        text = [NSString stringWithFormat:@"%@(%@)", pokemon.name, pokemonId];
        
    } else {
        text = [NSString stringWithFormat:@"精灵ID(%@)", pokemonId];
    }
    
    cell.textLabel.text = text;
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
    if (!_moreLocationSwitch.isOn && !_rangeSwitch.isOn) {
        NSInteger pokemonId = [[_pokemoIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue]; // 精灵ID
        NSString *pokemonName = [_pokemonNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 精灵名称
        NSString *longitude = [_longitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 经度
        NSString *latitude = [_latitudeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 纬度
        
        if ([longitude isEqualToString:@""] || [latitude isEqualToString:@""] || !longitude || !latitude) return;
        
        [self showHudInView:self.view hint:nil];
        [self searchRequestWithPokemon:[Pokemon pokemonWithPokemonId:pokemonId andName:pokemonName andLatitude:[latitude floatValue] andLongitude:[longitude floatValue]]];
        
    } else if (_moreLocationSwitch.isOn) {
        // 异步
        if (_moreLocationArray.count > 0) [self showHudInView:self.view hint:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Pokemon *pokemon in _moreLocationArray) {
                [self searchRequestWithPokemon:pokemon];
            }
            
            // 回到主线程显示
            dispatch_async(dispatch_get_main_queue(), ^{
                // dosomething
            });
        });
        
    } else if (_rangeSwitch.isOn) {
        [self rangeSearchPokemon];
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
    [_scrollView setContentOffset:CGPointMake(sender.isOn ? -kScreenSize.width : 0, 0) animated:YES];
    
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
        _audioPlayer.numberOfLoops = -1; //设置为0不循环,-1为一直循环
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
