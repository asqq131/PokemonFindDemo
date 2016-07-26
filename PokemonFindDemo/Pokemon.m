//
//  Pokemon.m
//  PokemonFindDemo
//
//  Created by ZWu H on 16/7/26.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "Pokemon.h"

@implementation Pokemon

- (id)initWithPokemonId:(NSInteger)pokemonId andLatitude:(float)latitude andLongitude:(float)longitude {
    if (self = [super init]) {
        self.pokemonId = pokemonId;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    
    return self;
}

+ (id)pokemonWithPokemonId:(NSInteger)pokemonId andLatitude:(float)latitude andLongitude:(float)longitude {
    return [[self alloc] initWithPokemonId:pokemonId andLatitude:latitude andLongitude:longitude];
}

@end
