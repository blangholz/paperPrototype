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
@property (weak, nonatomic) IBOutlet UIView *allCityCardView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIView *cuteCardView;
@property (nonatomic, assign) CGPoint cuteCardStartingPoint;
@property (nonatomic, assign) CGPoint allCityCardStartingPoint;
@property (nonatomic, assign) float sizeRatio;
@property (weak, nonatomic) IBOutlet UIView *testView;
- (IBAction)onDoneButton:(id)sender;

- (void)onPanGestureRecgonizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)onDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer;

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
    
    self.cuteCard.userInteractionEnabled = YES;

    [self.cuteCardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureRecgonizer:)]];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.cuteCardView addGestureRecognizer:tapGestureRecognizer];
    
    self.cuteCardStartingPoint = self.cuteCardView.center;
    self.allCityCardStartingPoint = self.allCityCardView.center;
    
    self.sizeRatio = self.allCityCardView.frame.size.width/self.cuteCardView.frame.size.width;
    
//    self.cuteCardView.transform = CGAffineTransformMakeScale(self.sizeRatio, self.sizeRatio);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (IBAction)onDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;	
}

- (void)onDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self.view];
    if (self.cuteCardView.center.y > 500) {
        NSLog(@"Tap!");
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.cuteCardView.center = CGPointMake(160, 203);
        } completion:nil];
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.allCityCardView.center = CGPointMake(18, self.allCityCardStartingPoint.y);
        } completion:nil];
    }
}

- (void)onPanGestureRecgonizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint fingerPosisiton = [panGestureRecognizer locationInView:self.view];
//    NSLog(@"Long pressed!");

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //X Animate to point
        //X Move all city card over to show drag point
        //X start wiggling cards
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.cuteCardView.center = fingerPosisiton;
            self.allCityCardView.center = CGPointMake(18, self.allCityCardStartingPoint.y);
            self.cuteCard.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:nil];

        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.allCityCard.transform = CGAffineTransformMakeRotation(( -2 ) / 180.0 * M_PI );
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.allCityCard.transform = CGAffineTransformMakeRotation(( 4 ) / 180.0 * M_PI );
            } completion:nil];
        }];
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        self.cuteCardView.center = fingerPosisiton;
        NSLog(@"Pont is at %@", NSStringFromCGPoint(fingerPosisiton));
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if point in target animate to target and keep all city to the left
        //if if point outside target animate to origin and animate all city back to origin
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.allCityCard.transform = CGAffineTransformMakeRotation(0);
            self.cuteCard.transform = CGAffineTransformMakeScale(1, 1);
            if (fingerPosisiton.y < 315) {
                self.cuteCardView.center = CGPointMake(160, 203);
                self.allCityCardView.center = CGPointMake(18, self.allCityCardStartingPoint.y);
            } else if (fingerPosisiton.y > 315) {
                self.cuteCardView.center = self.cuteCardStartingPoint;
                self.allCityCardView.center = self.allCityCardStartingPoint;
            }
        } completion:nil];
//        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self.allCityCard.transform = CGAffineTransformMakeRotation(( 0 ) / 180.0 * M_PI );
//        } completion:nil];
    }
}




@end
