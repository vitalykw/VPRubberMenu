//
//  ViewController.m
//  VPRubberTable
//
//  Created by Vitalii Popruzhenko on 5/27/14.
//  Copyright (c) 2014 Vitaliy Popruzhenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    float previousScrollViewYOffset;
    NSMutableArray *itemSet;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    itemSet = [NSMutableArray new];
    for (int i = 1; i < 11; i++){
        [itemSet addObject:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d.png",i]]];
    }
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    //Dirty Hack for hiding visual glitch with bouncing of UICollectionView
    
    UIView *newView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    UIView *bot = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, newView.bounds.size.height/2)];
    [top setBackgroundColor:[self colorForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [bot setBackgroundColor:[self colorForIndexPath:[NSIndexPath indexPathForRow:[itemSet count]-1 inSection:0]]];
    [newView addSubview:top];
    [newView addSubview:bot];
    [self.view addSubview:newView];
    [self.view bringSubviewToFront:_myCollectionView];
    [_myCollectionView setBackgroundColor:[UIColor clearColor]];
    
    CGRect cf = _myCollectionView.frame;
    cf.origin.y -=CELLS_ALLIGN;
    cf.size.height +=(CELLS_ALLIGN);
    [_myCollectionView setFrame:cf];
    

    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemSet.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VPRubberCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [otherCell setBackgroundColor:[self colorForIndexPath:indexPath]];
    [otherCell.iconView setImage:[itemSet objectAtIndex:indexPath.row]];
    return otherCell;
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)ip{
    switch (ip.row) {
        case 0:
            return RGBColor(0, 170, 172);
            break;
        case 1:
            return RGBColor(0, 106, 109);
            break;
        case 2:
            return RGBColor(190, 50, 106);
            break;
        case 3:
            return RGBColor(50, 144, 14);
            break;
        case 4:
            return RGBColor(204, 67, 0);
            break;
        case 5:
            return RGBColor(26, 129, 182);
            break;
        case 6:
            return RGBColor(204, 178, 0);
            break;
        case 7:
            return RGBColor(125, 14, 162);
            break;
        case 8:
            return RGBColor(108, 0, 199);
            break;
        case 9:
            return RGBColor(32, 32, 32);
            break;
        default:
            return [UIColor clearColor];
            break;
    }
}

@end
