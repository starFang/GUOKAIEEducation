//
//  ImageGV.m
//  ImageGesture
//
//  Created by qanzone on 13-9-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "ImageGV.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageGV

@synthesize imageView = _imageView;
@synthesize lastRotation = _lastRotation;
@synthesize scale = _scalel;
@synthesize backLayer = _backLayer;
@synthesize delegate;
@synthesize imageNameNew; 
- (void)dealloc
{
    [_panGesture release];
    [_pinchGesture release];
    [_rotationGesture release];
    [self.imageView release];
    self.imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        startRect = frame;
        isImageBig = NO;
        [self initImage];
        self.lastRotation = 0;
        [self initGesture];
        [self initIView];
    }
    return self;
}

-(void)initIView
{
    iView = [[IViewGV alloc]init];
    iView.delegate = self;
    iView.alpha = 0.0f;
    [iView titleAndClose:@"测验 4.2 Lorem Ipsum dolor amet, consectetur"];
    [self addSubview:iView];
}

- (void)initGesture
{
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureForImage:)];
    _panGesture.maximumNumberOfTouches = 2;
    _panGesture.minimumNumberOfTouches = 2;
    _panGesture.delegate = self;
//    [self.imageView addGestureRecognizer:_panGesture];
    
    _pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureForImage:)];
    _pinchGesture.delegate = self;
//    [self.imageView addGestureRecognizer:_pinchGesture];
    
    _rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGestureForImage:)];
    _rotationGesture.delegate = self;
//    [self.imageView addGestureRecognizer:_rotationGesture];
    
    _tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.imageView addGestureRecognizer:_tapOneGesture];
    [_tapOneGesture requireGestureRecognizerToFail:_panGesture];
}

static int indexTap;
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [delegate tapImageBig:self.imageNameNew];
    [self endTwoState:gestureRecognizer];
    if (isImageBig == YES)
    {
        if (indexTap%2 == 1)
        {
            iView.alpha = 1.0;
            iView.hidden = NO;
        }else{
            iView.alpha = 0.0;
        }
        indexTap++;
    }
}
-(void)closeTheImage
{
    
    [self endOneState:nil];
    
}
-(void)initImage
{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.userInteractionEnabled = YES;
    firstPoint = self.imageView.center;
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    [[self.imageView layer]setShadowOffset:CGSizeMake(0, 0)];
    [[self.imageView layer] setShadowRadius:10.0];
//    [[self.imageView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.imageView layer] setShadowOpacity:0.0];
}

- (void)loadImage:(NSString *)imageName
{
    self.imageNameNew = imageName;
//    NSString * imagePath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1"] stringByAppendingPathComponent:imageName];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath])
    {
        NSData * imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage * image = [UIImage imageWithData:imageData];
        imageW = image.size.width;
        imageH = image.size.height;
    [self.imageView setImage:image];
    }else{
        UIImage * image = [UIImage imageNamed:@"1.png"];
        imageW = image.size.width;
        imageH = image.size.height;
        [self.imageView setImage:image];
    }
}

-(void)panGestureForImage:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    
    switch ([gestureRecognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self panBegan:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self panMoved:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self panEnded:gestureRecognizer];
            break;
        default:
            break;
    }
    
}

- (void)panBegan:(UIPanGestureRecognizer*)gestureRecognizer
{
    [self startState:gestureRecognizer];
}
- (void)panMoved:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    gestureRecognizer.view.center = CGPointMake(location.x +distancePoint.x,  location.y +distancePoint.y);
}
- (void)panEnded:(UIPanGestureRecognizer*)gestureRecognizer
{
    
    [self endAnimalState:gestureRecognizer];
    [self endState:gestureRecognizer];
    
}
-(void)pinchGestureForImage:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self pinchBegin:gestureRecognizer];
        }
            break;
         case UIGestureRecognizerStateChanged:
        {
            [self pinchChange:gestureRecognizer];
        }
            break;
            case UIGestureRecognizerStateEnded:
        {
            [self pinchEnd:gestureRecognizer];
        }
            break;
        default:
            break;
    }
    
    
}

-(void)pinchBegin:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self startState:gestureRecognizer];
}
-(void)pinchChange:(UIPinchGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    gestureRecognizer.view.center = CGPointMake(location.x, location.y);
    gestureRecognizer.view.transform = CGAffineTransformScale(gestureRecognizer.view.transform, gestureRecognizer.scale, gestureRecognizer.scale);
    gestureRecognizer.scale = 1.0;
}
-(void)pinchEnd:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self endState:gestureRecognizer];
}

-(void)rotationGestureForImage:(UIRotationGestureRecognizer *)gesture
{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self rotationBegin:gesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self rotationChange:gesture];
        }
            break;
            case UIGestureRecognizerStateEnded:
        {
            [self rotationEnd:gesture];
        }
            break;
        default:
            break;
    }

}

-(void)rotationBegin:(UIRotationGestureRecognizer *)gestureRecoginzer
{
    [self startState:gestureRecoginzer];
}
-(void)rotationChange:(UIRotationGestureRecognizer *)gestureRecoginzer
{
    CGPoint location = [gestureRecoginzer locationInView:self];
    gestureRecoginzer.view.center = CGPointMake(location.x, location.y);
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGFloat rotation = 0.0 - (self.lastRotation - gestureRecoginzer.rotation);
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
    self.imageView.transform = newTransform;
    self.lastRotation = gestureRecoginzer.rotation;
}

-(void)rotationEnd:(UIRotationGestureRecognizer *)
gestureRecoginzer
{
    
    [self endState:gestureRecoginzer];
}

-(void)endAnimalState:(UIGestureRecognizer *)gestureRecoginzer
{
    CGPoint location = [gestureRecoginzer locationInView:self];
    lastPoint = CGPointMake(location.x +distancePoint.x,  location.y +distancePoint.y);
}
- (void)startState:(UIGestureRecognizer *)gestureRecognizer
{
    [delegate panImage:self.imageNameNew];
    if (isImageBig == NO)
    {
        [self startOneState:gestureRecognizer];
    }else{
        [self startTwoState:gestureRecognizer];
    }
}

- (void)startOneState:(UIGestureRecognizer *)gestureRecognizer
{
    [self  bringSubviewToFront:self.imageView];
    [self  bringSubviewToFront:iView];
    [[self.imageView layer] setShadowOpacity:1.0];
    
    CGPoint locationImage = [gestureRecognizer locationInView:_imageView];
    distancePoint = CGPointMake(self.imageView.center.x-locationImage.x, self.imageView.center.y-locationImage.y);

    CGPoint location = [gestureRecognizer locationInView:self];
    firstPoint = CGPointMake(location.x + distancePoint.x,  location.y + distancePoint.y);

}
- (void)startTwoState:(UIGestureRecognizer *)gestureRecognizer
{
    [self  bringSubviewToFront:self.imageView];
    [self  bringSubviewToFront:iView];
    [[self.imageView layer] setShadowOpacity:1.0];
    
    CGPoint locationImage = [gestureRecognizer locationInView:self];
    distancePoint = CGPointMake(self.imageView.center.x-locationImage.x, self.imageView.center.y-locationImage.y);

    CGPoint location = [gestureRecognizer locationInView:self];
    firstPoint = CGPointMake(location.x + distancePoint.x,  location.y + distancePoint.y);

}

- (void)endState:(UIGestureRecognizer *)gestureRecoginzer
{
    if (isImageBig == NO)
    {
        if (gestureRecoginzer.view.frame.size.width >= startRect.size.width * 2  && gestureRecoginzer.view.frame.size.height >= startRect.size.height * 2)
        {
            [self endTwoState:gestureRecoginzer];
        }else{
            [self endOneState:gestureRecoginzer];
        }
    }else{
    
        if (gestureRecoginzer.view.frame.size.width >= imageW  && gestureRecoginzer.view.frame.size.height >= imageH)
        {
            [self endTwoState:gestureRecoginzer];
        }else{
            [self endOneState:gestureRecoginzer];
        }
    }
    
}

-(void)endOneState:(UIGestureRecognizer *)gestureRecoginzer
{
    iView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
//    self.imageView.transform = CGAffineTransformScale(gestureRecoginzer.view.transform, 1.0, 1.0);
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.frame =startRect;
    self.imageView.frame = self.bounds;
    [[self.imageView layer] setShadowOpacity:0.0];
    self.lastRotation = 0;
    isImageBig = NO;
    distancePoint = CGPointMake(0, 0);
    [UIView commitAnimations];
    
    [delegate removeFromTheView:self.imageNameNew];
}

-(void)endTwoState:(UIGestureRecognizer *)gestureRecoginzer
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8f];
    
    self.imageView.transform = CGAffineTransformScale(gestureRecoginzer.view.transform, 1.0, 1.0);
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.frame = CGRectMake(0, 0, 1024, 768);
    self.imageView.frame = CGRectMake(self.center.x-imageW/2, self.center.y-imageH/2, imageW, imageH);
    self.imageView.center = self.center;
    
    [[self.imageView layer] setShadowOpacity:0.0];
    self.lastRotation = 0;
    isImageBig = YES;
    distancePoint = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}



@end
