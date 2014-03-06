//
//  feedStoreViewController.m
//  paperPrototype
//
//  Created by Ben Langholz on 3/5/14.
//  Copyright (c) 2014 Ben Langholz. All rights reserved.
//

#import "feedStoreViewController.h"

@interface feedStoreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *cuteCard;
@property (weak, nonatomic) IBOutlet UIImageView *allCityCard;
@property (weak, nonatomic) IBOutlet UIImageView *dragHereTarget;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIView *cuteCardView;
@property (nonatomic, assign) CGPoint cuteCardStartingPoint;
@property (nonatomic, assign) CGPoint allCityCardStartingPoint;


-(void)onLongPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end

@implementation feedStoreViewController

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
    [self.cuteCardView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGesture:)]];
    self.cuteCardStartingPoint = self.cuteCardView.center;
    self.allCityCardStartingPoint = self.allCityCard.center;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)onLongPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    CGPoint fingerPosisiton = [longPressGestureRecognizer locationInView:self.view];
//    NSLog(@"Long pressed!");

    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //Animate to point
        //Move all city card over to show drag point
        //start wiggling cards
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.cuteCardView.center = fingerPosisiton;
        } completion:nil];
        
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        self.cuteCardView.center = fingerPosisiton;
        NSLog(@"Pont is at %@", NSStringFromCGPoint(fingerPosisiton));
        
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if point in target animate to target and keep all city to the left
        //if if point outside target animate to origin and animate all city back to origin
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (fingerPosisiton.y < 315) {
                self.cuteCardView.center = self.allCityCardStartingPoint;
            } else if (fingerPosisiton.y > 315) {
                self.cuteCardView.center = self.cuteCardStartingPoint;
            }
        } completion:nil];
    }
}

@end
