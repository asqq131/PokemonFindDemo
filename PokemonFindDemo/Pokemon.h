//
//  Pokemon.h
//  PokemonFindDemo
//
//  Created by ZWu H on 16/7/26.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pokemon : NSObject

@property (nonatomic, assign) NSInteger pokemonId; // 精灵ID
@property (nonatomic, copy) NSString *name; // 名字
@property (nonatomic, assign) float longitude; // 经度
@property (nonatomic, assign) float latitude; // 纬度

- (id)initWithPokemonId:(NSInteger)pokemonId andName:(NSString *)name andLatitude:(float)latitude andLongitude:(float)longitude;
+ (id)pokemonWithPokemonId:(NSInteger)pokemonId andName:(NSString *)name andLatitude:(float)latitude andLongitude:(float)longitude;

@end
