//
//  Pokemon.m
//  PokemonFindDemo
//
//  Created by ZWu H on 16/7/26.
//  Copyright © 2016年 黄志武. All rights reserved.
//

#import "Pokemon.h"

@implementation Pokemon

- (id)initWithPokemonId:(NSInteger)pokemonId andName:(NSString *)name andLatitude:(float)latitude andLongitude:(float)longitude {
    if (self = [super init]) {
        self.pokemonId = pokemonId;
        self.name = name;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    
    return self;
}

+ (id)pokemonWithPokemonId:(NSInteger)pokemonId andName:(NSString *)name andLatitude:(float)latitude andLongitude:(float)longitude {
    return [[self alloc] initWithPokemonId:pokemonId andName:name andLatitude:latitude andLongitude:longitude];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.pokemonId = [[aDecoder decodeObjectForKey:@"pokemonId"] integerValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] floatValue];
        self.longitude = [[aDecoder decodeObjectForKey:@"longitude"] floatValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld", (long)self.pokemonId] forKey:@"pokemonId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.latitude] forKey:@"latitude"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.longitude] forKey:@"longitude"];
}

@end
