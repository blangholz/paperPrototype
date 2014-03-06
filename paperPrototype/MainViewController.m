//
//  MainViewController.m
//  paperPrototype
//
//  Created by Ben Langholz on 3/1/14.
//  Copyright (c) 2014 Ben Langholz. All rights reserved.
//

#import "MainViewController.h"
#import "feedStoreViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *blackBackground;
@property (nonatomic) float panStartingYPoint;
@property (nonatomic) float alphaZeroToOne;
@property (nonatomic) float containerStartingYPoint;
@property (weak, nonatomic) IBOutlet UIImageView *stories;
@property (nonatomic, strong) feedStoreViewController *feedViewController;
- (IBAction)editSectionButton:(id)sender;
- (IBAction)tapNextViewButton:(id)sender;

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)onScrollPan:(UIPanGestureRecognizer *)scrollPanGestureRecognizer;
- (void)onPanNews:(UIPanGestureRecognizer *)newsPanGestureRecognizer;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.blackBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1136/2)];
    self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:self.blackBackground];
    
    self.container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.container];
    
    UIButton *nextViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextViewButton.frame = CGRectMake(10, 100, 40, 40);
    [nextViewButton setTitle:@"Test" forState:UIControlStateNormal];
    [nextViewButton addTarget:self action:@selector(tapNextViewButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextViewButton];
    
    //Images for headline
//    NSArray *misoHeadline = [NSArray arrayWithObjects:
//                             [UIImage imageNamed:@"paperHeadline"],
//                             [UIImage imageNamed:@"2"],
//                             [UIImage imageNamed:@"3"],
//                             [UIImage imageNamed:@"4"],
//                             [UIImage imageNamed:@"5"], nil];
    
    UIImage *misoHeadline = [UIImage imageNamed:@"paperHeadline"];
    UIImageView *headline = [[UIImageView alloc] initWithImage:misoHeadline];
    [self.container addSubview:headline];

    [self.container addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(1447, 254);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.container addGestureRecognizer:panGestureRecognizer];
    
    UIPanGestureRecognizer *scrollPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollPan:)];
    [self.stories addGestureRecognizer:scrollPanGestureRecognizer];
    
    //Scroll vs pan
//    UIPanGestureRecognizer *newsPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanNews:)];newsPanGestureRecognizer.delegate = self;
//    [self.scrollView addGestureRecognizer:newsPanGestureRecognizer];
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    float velocityY = velocity.y;
    float scalePercent = .05;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //figure out where the pangesture started
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        
        self.containerStartingYPoint = self.container.frame.origin.y;
        NSLog(@"Frame Began = %f", self.containerStartingYPoint);
        
        self.panStartingYPoint = point.y;
//        NSLog(@"Pan Starting Y Point = %f", self.panStartingYPoint);

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //pan current possition - pan starting position = container position
//        NSLog(@"Gesture changed: %@ Velocity changed: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
        
        float difference = (point.y-self.panStartingYPoint);
        NSLog(@"difference: %f", difference);
        
        self.container.frame = CGRectMake(0, difference+self.containerStartingYPoint, 320, 1136/2);
        
//      converting number x from range a-b to number y in range c-d
        float frictionedScroll = (-10) + ((difference)-(-100))/(0-(-100)) * (0-(-10));
        
        if (difference+self.containerStartingYPoint < 0) {
            self.container.frame = CGRectMake(0, frictionedScroll, self.view.frame.size.width, self.view.frame.size.height);
            NSLog(@"Scrolling up!");
        }
        
//      NSLog(@"0-1 for alpha formula %f",(1 + (self.container.frame.origin.y-0)/(512-0) * (0-1)));
        self.alphaZeroToOne = (1 + (self.container.frame.origin.y-0)/(512-0) * (0-1));
        self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.alphaZeroToOne];
        float zeroToOneToScalePercent = self.alphaZeroToOne*scalePercent;
        
        self.profileBackground.frame = CGRectMake(320*(zeroToOneToScalePercent/2), 568*(zeroToOneToScalePercent/2), self.view.frame.size.width-(self.view.frame.size.width*zeroToOneToScalePercent), self.view.frame.size.height-(self.view.frame.size.height*zeroToOneToScalePercent));
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if velocity positive go up if velvocity negitive go down
        NSLog(@"Gesture ended: %f, Velocity y: %f", point.y, velocityY);
        
        if (velocityY < 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 0, 320, 1136/2);
                self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                self.profileBackground.frame = CGRectMake(320*(scalePercent/2), 568*(scalePercent/2), self.view.frame.size.width-(self.view.frame.size.width*scalePercent), self.view.frame.size.height-(self.view.frame.size.height*scalePercent));
            } completion:nil];
        } else if (velocityY > 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 521, 320, 1136/2);
                self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                self.profileBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
        }
        
    }
}

//- (void)onScrollPan:(UIPanGestureRecognizer *)scrollPanGestureRecognizer {
//    CGPoint point = [scrollPanGestureRecognizer locationInView:self.view];
//    CGPoint velocity = [scrollPanGestureRecognizer velocityInView:self.view];
//    
//    if (scrollPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
//    } else if (scrollPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
//    } else if (scrollPanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
//    }
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (otherGestureRecognizer == self.scrollView.panGestureRecognizer) {
//        return YES;
//    }
//    return NO;
//}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)tapNextViewButton:(id)sender {
    NSLog(@"test");
    self.feedViewController = [[feedStoreViewController alloc] init];
    [self.navigationController pushViewController:self.feedViewController animated:YES];
}


@end
