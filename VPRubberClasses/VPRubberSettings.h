//
//  VPRubberSettings.h
//  VPRubberTable
//
//  Created by Vitalii Popruzhenko on 5/27/14.
//  Copyright (c) 2014 Vitaliy Popruzhenko. All rights reserved.
//

#import "VPRubberLayout.h"
#import "VPRubberCell.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define RGBColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define CELLS_ALLIGN 100
#define CELLS_SIZE 130

#define MAX_H 35

#define SCROLL_RES 1100.0f;

#define SPRING_LENGHT 0.8f
#define SPRING_DAMPING 0.5f;
#define SPRING_FREQUENCY 0.8f;

