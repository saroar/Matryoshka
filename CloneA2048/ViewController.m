//
//  ViewController.m
//  CloneA2048
//
//  Created by Mattias Jähnke on 2014-05-26.
//  Copyright (c) 2014 Nearedge. All rights reserved.
//

#import "ViewController.h"
#import "Json2048.h"
#import "GameBoardView.h"
#import "GameTileView.h"
#import "FrontPageViewController.h"

@interface ViewController ()<Json2048Delegate>
@property (nonatomic, weak) IBOutlet GameBoardView *board;

@property (weak, nonatomic) IBOutlet UIButton *autoRunButton;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;





@end

static int GameOverlayLabelTag = 12;
static int GameOverlayButtonTag = 13;

@implementation ViewController {
    Json2048 *_game;
    NSUInteger _bestScore;
    NSTimer *_testTimer;
    
    UIView *_messageOverlayView;
    
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:@"next" sender:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scoreLabel.layer.cornerRadius = 5;
    _bestLabel.layer.cornerRadius = 5;
    _titleLabel.layer.cornerRadius = 5;
    _autoRunButton.layer.cornerRadius = 5;
    _board.layer.cornerRadius = 5;
    _resetButton.layer.cornerRadius =5;
    
    NSNumber *lastGameScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"2048CurrentScore"];
    
	_game = [[Json2048 alloc] initWithJson:[[NSUserDefaults standardUserDefaults] objectForKey:@"2048CloneJson"] score:lastGameScore ? [lastGameScore unsignedIntegerValue] : 0];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:163.0f/255.0f blue:136.0f/255.0f alpha:1.0f];
    
    
    /*
    // Winning game
    _game = [[Json2048 alloc] initWithJson:@[[@[@0,@0,@0,@0] mutableCopy],
                                            [@[@1024,@0,@0,@0] mutableCopy],
                                            [@[@0,@0,@0,@0] mutableCopy],
                                             [@[@1024,@0,@0,@0] mutableCopy]] score:0];
    
    //Losing game
    _game = [[Json2048 alloc] initWithJson:@[[@[@1,@2,@3,@4] mutableCopy],
                                             [@[@5,@6,@7,@8] mutableCopy],
                                             [@[@9,@10,@11,@12] mutableCopy],
                                             [@[@13,@14,@15,@0] mutableCopy]] score:0];*/
    
    _board.size = [_game.json.firstObject count];
    
    [_board updateValuesWithValueArray:_game.json canSpawn:YES];
    
    _game.delegate = self;

    [self _addSwipeInDirection:UISwipeGestureRecognizerDirectionDown gameAction:@selector(swipeDown)];
    [self _addSwipeInDirection:UISwipeGestureRecognizerDirectionRight gameAction:@selector(swipeRight)];
    [self _addSwipeInDirection:UISwipeGestureRecognizerDirectionUp gameAction:@selector(swipeUp)];
    [self _addSwipeInDirection:UISwipeGestureRecognizerDirectionLeft gameAction:@selector(swipeLeft)];
    
    _bestScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"2048CloneHighscore"] unsignedIntegerValue];
    [self _updateScoreLabel];
    
    
    //Costomizing color NavBar

    
}

#pragma mark - User interaction

- (void)newGameButtonTapped:(id)sender {
    [self _removeOverlay];
    [self resetGame:sender];
    if (_testTimer) {
        [self _autoMove];
    }
}

- (void)continuePlayingButtonTapped:(id)sender {
    [self _removeOverlay];
}

- (IBAction)resetGame:(id)sender {
    [_game reset];
    [self _removeOverlay];
    grdpapa.hidden = YES;
    grdmama.hidden = YES;
    papa.hidden = YES;
    mama.hidden = YES;
    sister.hidden = YES;
    me.hidden = YES;
    udid.hidden = YES;
}



#pragma mark - Json2048 Delegation

- (void)json2048:(Json2048 *)json2048 spawnedAtPos:(CGPoint)pos {
    [_board updateValuesWithValueArray:_game.json canSpawn:YES];
    [self _saveGameState];
}

- (void)json2048GameOver:(Json2048 *)json2048 {
    [self _displayMessageWithTitle:@"Game over!" subtitle:@"Tap to try again" tapSelector:@selector(newGameButtonTapped:)];
}

//extra test for show message . i will delete if will get  any error
- (void)json2048UnlockMatryoshkaGrdPapa2048:(Json2048 *)json2048 {
    grdpapa.hidden = NO;
    
    [self _displayMessageWithTitle:@"Grd Papa!" subtitle:@"Tap to play Unlock GrdMama" tapSelector:@selector(continuePlayingButtonTapped:)];
}

- (void)json2048UnlockMatryoshkaGrdMama2048:(Json2048 *)json2048 {
    grdmama.hidden = NO;
    [self _displayMessageWithTitle:@"Grd Mam!" subtitle:@"Tap to play Unlock Papa" tapSelector:@selector(continuePlayingButtonTapped:)];
}

- (void)json2048UnlockMatryoshkaPapa2048:(Json2048 *)json2048 {
    papa.hidden = NO;
    [self _displayMessageWithTitle:@"Papa!" subtitle:@"Tap to play Unlock Mama" tapSelector:@selector(continuePlayingButtonTapped:)];
}

- (void)json2048UnlockMatryoshkaMama2048:(Json2048 *)json2048 {
    mama.hidden = NO;
    [self _displayMessageWithTitle:@"Mama!" subtitle:@"Tap to play Unlock ur Sister" tapSelector:@selector(continuePlayingButtonTapped:)];
}

- (void)json2048UnlockMatryoshkaSister2048:(Json2048 *)json2048 {
    sister.hidden = NO;
    [self _displayMessageWithTitle:@"My Sister!" subtitle:@"Tap to play Unlock ur self" tapSelector:@selector(continuePlayingButtonTapped:)];
}

- (void)json2048UnlockMatryoshkaMe2048:(Json2048 *)json2048 {
    me.hidden = NO;
    udid.hidden = NO;
    [self _displayMessageWithTitle:@"You win Yes You did:)!" subtitle:@"U win" tapSelector:@selector(continuePlayingButtonTapped:)];
}



//this is end about show Image and Game finished :)

//Start < This is show Message about whom you unlock you Family member





- (void)json2048Reached2048:(Json2048 *)json2048 {
    [self _displayMessageWithTitle:@"You Unlock Matryoshka Family!" subtitle:@"Tap to continue playing" tapSelector:@selector(continuePlayingButtonTapped:)];

    
}

- (void)_displayMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle tapSelector:(SEL)selector {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", title] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:36]}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:subtitle attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName : [UIColor colorWithWhite:0 alpha:0.3f]}]];
    
    
    if (!_messageOverlayView) {
        _messageOverlayView = [[UIView alloc] initWithFrame:_board.frame];
        _messageOverlayView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5f];
        UILabel *gameOverLabel = [[UILabel alloc] initWithFrame:_messageOverlayView.bounds];
        gameOverLabel.tag = GameOverlayLabelTag;
        gameOverLabel.textAlignment = NSTextAlignmentCenter;
        gameOverLabel.font = [UIFont boldSystemFontOfSize:30];
        gameOverLabel.numberOfLines = 2;
        [_messageOverlayView addSubview:gameOverLabel];
    }
    
    if ([_messageOverlayView viewWithTag:GameOverlayButtonTag]) {
        [[_messageOverlayView viewWithTag:GameOverlayButtonTag] removeFromSuperview];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.tag = GameOverlayButtonTag;
    button.frame = _messageOverlayView.bounds;
    [_messageOverlayView addSubview:button];
    
    if (!_messageOverlayView.superview) {
        [self.view addSubview:_messageOverlayView];
        _messageOverlayView.alpha = 0;
        
        [UIView animateWithDuration:0.2f animations:^{
            _messageOverlayView.alpha = 1;
        }];
    }
    
    ((UILabel *)[_messageOverlayView viewWithTag:GameOverlayLabelTag]).attributedText = str;
    
    [_testTimer invalidate];
    _testTimer = nil;
}

- (void)_removeOverlay {
    [UIView animateWithDuration:0.1f animations:^{
        _messageOverlayView.alpha = 0;
    } completion:^(BOOL finished) {
        [_messageOverlayView removeFromSuperview];
    }];
}

- (void)json2048:(Json2048 *)json2048 didChangeScore:(NSUInteger)score {
    [self _updateScoreLabel];
}

#pragma mark Handle Json2048 moves to allow UI animation

- (void)json2048DidReset:(Json2048 *)json2048 {
    [self _updateScoreLabel];
}

- (void)json2048:(Json2048 *)json2048 didMovePos:(CGPoint)fromPos toPos:(CGPoint)toPos {
    [_board moveTileAtPosition:fromPos toPosition:toPos];
}

- (void)json2048:(Json2048 *)json2048 didMergeFromPos:(CGPoint)fromPos AtPos:(CGPoint)atPos {
    [_board moveAndRemoveTileAtPosition:fromPos toPosition:atPos];
}

- (void)json2048:(Json2048 *)json2048 moveEndedWithEarnedScore:(NSUInteger)score {
    if (score > 0) {
        [self _animateScoreChangeNotificationWithText:[NSString stringWithFormat:@"+ %lu", (unsigned long)score]];
    }
    [self _updateScoreLabel];
    [_board updateValuesWithValueArray:_game.json canSpawn:NO];
    [_board animateTiles];
}

#pragma mark - Internal

- (void)_addSwipeInDirection:(UISwipeGestureRecognizerDirection)direction gameAction:(SEL)action {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:_game action:action];
    swipe.direction = direction;
    [self.view addGestureRecognizer:swipe];
}

- (void)_updateScoreLabel {
    if (_game.score > _bestScore) {
        _bestScore = _game.score;
        [[NSUserDefaults standardUserDefaults] setObject:@(_bestScore) forKey:@"2048CloneHighscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self _styleAttributedTextInLabel:_scoreLabel title:@"Score" value:[NSString stringWithFormat:@"%lu",(unsigned long)_game.score]];
    [self _styleAttributedTextInLabel:_bestLabel title:@"Best" value:[NSString stringWithFormat:@"%lu", (unsigned long)_bestScore]];
}

- (void)_styleAttributedTextInLabel:(UILabel *)label title:(NSString *)title value:(NSString *)value {
    NSMutableAttributedString *res = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:238/255.0f green:228/255.0f blue:214/255.0f alpha:1]}];
    [res appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", value] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:1]}]];
    label.attributedText = res;
}

- (void)_saveGameState {
    [[NSUserDefaults standardUserDefaults] setObject:_game.json forKey:@"2048CloneJson"];
    [[NSUserDefaults standardUserDefaults] setObject:@(_game.score) forKey:@"2048CurrentScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)_animateScoreChangeNotificationWithText:(NSString *)text {
    UILabel *scoreChangeLabel = [[UILabel alloc] initWithFrame:_scoreLabel.frame];
    scoreChangeLabel.text = text;
    scoreChangeLabel.textAlignment = NSTextAlignmentCenter;
    scoreChangeLabel.textColor = [UIColor whiteColor];
    scoreChangeLabel.font = _scoreLabel.font;
    [self.view addSubview:scoreChangeLabel];
    [UIView animateWithDuration:0.8f animations:^{
        scoreChangeLabel.alpha = 0;
        CGRect f = scoreChangeLabel.frame;
        f.origin.y += 50;
        scoreChangeLabel.frame = f;
    } completion:^(BOOL finished) {
        [scoreChangeLabel removeFromSuperview];
    }];
}

#pragma mark -

- (void)_autoMove {
    if (!_testTimer || !_testTimer.isValid) {
        _testTimer = [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(_autoMove) userInfo:nil repeats:YES];
    }
    int a = arc4random() % 4;
    switch (a) {
        case 0:
            [_game swipeDown];
            break;
        case 1:
            [_game swipeLeft];
            break;
        case 2:
            [_game swipeRight];
            break;
        case 3:
            [_game swipeUp];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:163.0f/255.0f blue:136.0f/255.0f alpha:1.0f];
    //self.navigationController.navigationBar.barTintColor. = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}







@end
