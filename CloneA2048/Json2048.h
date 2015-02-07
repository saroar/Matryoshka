//
//  Json2048.h
//  CloneA2048
//
//  Created by Mattias Jähnke on 2014-05-26.
//  Copyright (c) 2014 Nearedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Json2048;

@protocol Json2048Delegate <NSObject>

@optional

// Game flow and rules
- (void)json2048GameOver:(Json2048 *)json2048;
- (void)json2048Reached2048:(Json2048 *)json2048;
- (void)json2048DidReset:(Json2048 *)json2048;


//This is for show image when score is update
- (void)json2048UnlockMatryoshkaGrdPapa2048:(Json2048 *)json2048;
- (void)json2048UnlockMatryoshkaGrdMama2048:(Json2048 *)json2048;
- (void)json2048UnlockMatryoshkaPapa2048:(Json2048 *)json2048;
- (void)json2048UnlockMatryoshkaMama2048:(Json2048 *)json2048;
- (void)json2048UnlockMatryoshkaSister2048:(Json2048 *)json2048;
- (void)json2048UnlockMatryoshkaMe2048:(Json2048 *)json2048;

// Changed to the board
- (void)json2048:(Json2048 *)json2048 spawnedAtPos:(CGPoint)pos;
- (void)json2048:(Json2048 *)json2048 didMovePos:(CGPoint)fromPos toPos:(CGPoint)toPos;
- (void)json2048:(Json2048 *)json2048 didMergeFromPos:(CGPoint)fromPos AtPos:(CGPoint)atPos;
- (void)json2048:(Json2048 *)json2048 moveEndedWithEarnedScore:(NSUInteger)score;

@end

@interface Json2048 : NSObject

- (id)initWithJson:(NSArray *)array score:(NSUInteger)score;

@property (nonatomic, weak) id<Json2048Delegate> delegate;

@property (nonatomic, readonly) NSArray *json;
@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, readonly) NSUInteger freeSpaces;
@property (nonatomic, readonly) NSUInteger totalMoves;

- (void)reset;

- (void)swipeRight;
- (void)swipeLeft;
- (void)swipeUp;
- (void)swipeDown;

@end
