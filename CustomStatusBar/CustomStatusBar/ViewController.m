//
//  ViewController.m
//  CustomStatusBar
//
//  Created by 宣佚 on 15/8/19.
//  Copyright (c) 2015年 Liuxuanyi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, readonly) UIView *statusBarBackgroundView;
@property (nonatomic, readonly) UICollectionView *collectionView;

@end

@implementation ViewController

@synthesize collectionView;
@synthesize statusBarBackgroundView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout *layout;
    layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(290.0f, 2000.0f)];
    [layout setSectionInset:UIEdgeInsetsMake(30.0f, 15.0f, 15.0f, 15.0f)];
    
    collectionView = [[UICollectionView alloc] initWithFrame:[[self view] bounds] collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAlwaysBounceVertical:YES];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [[self view] addSubview:collectionView];
    
    UIImage *background = [UIImage imageNamed:@"space"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
    [collectionView setBackgroundView:backgroundView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //关键代码
    if (!statusBarBackgroundView) {
        
        CGRect barRect = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 28.0f);
        
        statusBarBackgroundView = [[collectionView backgroundView] resizableSnapshotViewFromRect:barRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                           nil];
        [gradientLayer setColors:colors];
        [gradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 0.6f)];
        [gradientLayer setFrame:[statusBarBackgroundView bounds]];
        
        [[statusBarBackgroundView layer] setMask:gradientLayer];
        [[self view] addSubview:statusBarBackgroundView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//自动滚动
- (void)scroll {
    
    const float speed = 0.1;
    const float increment = 5;
    const float bottomY = [collectionView contentSize].height - CGRectGetHeight([collectionView bounds]);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(speed * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if ([collectionView contentOffset].y < bottomY && ![collectionView isDragging]) {
            [collectionView scrollRectToVisible:CGRectMake(0, CGRectGetMaxY([collectionView bounds]) + increment, 1, 1) animated:YES];
            [self scroll];
        }
    });
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f], NSFontAttributeName,
                                (id)[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    NSAttributedString *attrText;
    attrText = [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
                                               attributes:attributes];
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setAttributedText:attrText];
    [cell addSubview:label];
    
    CGRect textRect = CGRectZero;
    textRect.size = [label sizeThatFits:[cell bounds].size];
    [label setFrame:textRect];
    
    return cell;
}

@end
