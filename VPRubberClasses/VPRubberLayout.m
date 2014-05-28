//
//  VPRubberLayout.m
//  VPRubberTable
//
//  Created by Vitalii Popruzhenko on 5/27/14.
//  Copyright (c) 2014 Vitaliy Popruzhenko. All rights reserved.
//

#import "VPRubberLayout.h"

@interface VPRubberLayout ()
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;
@end

@implementation VPRubberLayout
- (instancetype)init {
    self = [super init];
    if (self){
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.collectionView setBounces:YES];
    CGSize itemSize = [self itemSize];
    itemSize.height = CELLS_SIZE+CELLS_ALLIGN+MAX_H;
    [self setItemSize:itemSize];
    [self setMinimumLineSpacing:-CELLS_ALLIGN];
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _visibleIndexPathsSet = [NSMutableSet set];
}

- (void)prepareLayout {
    [super prepareLayout];
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] lastObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] lastObject] indexPath]];
    }];
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        item.zIndex = center.y;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        springBehaviour.length = SPRING_LENGHT;
        springBehaviour.damping = SPRING_DAMPING;
        springBehaviour.frequency = SPRING_FREQUENCY;
        springBehaviour.action = ^{
            [(VPRubberCell *)[self.collectionView cellForItemAtIndexPath:item.indexPath] setNewHeight:self.latestDelta];
        };
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat scrollResistance = distanceFromTouch / SCROLL_RES;
            float newY = 0;
            
            if (self.latestDelta < 0) {
                newY = MAX([self fixDelta:self.latestDelta withResistance:1], [self fixDelta:self.latestDelta withResistance:scrollResistance]);
                center.y += newY;
            }
            else {
                newY = MIN([self fixDelta:self.latestDelta withResistance:1], [self fixDelta:self.latestDelta withResistance:scrollResistance]);
                center.y += newY;
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}
- (CGFloat)fixDelta:(CGFloat)delta withResistance:(CGFloat)res{
    if (delta*res >= MAX_H){
        return MAX_H;
    } else if (delta*res <= -MAX_H){
        return -MAX_H;
    } else {
        return delta*res;
    }
}
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];

    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / SCROLL_RES;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        
        CGPoint center = item.center;
        item.zIndex = center.y;

        if (delta < 0) {
            center.y += MAX([self fixDelta:delta withResistance:1], [self fixDelta:delta withResistance:scrollResistance]);
        }
        else {
            center.y += MIN([self fixDelta:delta withResistance:1], [self fixDelta:delta withResistance:scrollResistance]);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}


@end
