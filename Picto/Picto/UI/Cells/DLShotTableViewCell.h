//
//  DLShotTableViewCell.h
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLShot.h"

typedef enum : NSUInteger {
    DLButtonTypeMore,
    DLButtonTypeShare,
    DLButtonTypeComment,
    DLButtonTypeLike
} DLButtonType;

@class DLShotTableViewCell;

@protocol DLShotTableViewCellDelegate <NSObject>
- (void)shotTableViewCell:(DLShotTableViewCell *)shotCell buttonPressed:(DLButtonType)buttonType forShot:(DLShot *)shot;
@end

@interface DLShotTableViewCell : UITableViewCell

@property (assign, nonatomic) id<DLShotTableViewCellDelegate> delegate;

- (void)addShotData:(DLShot *)shot;
- (DLShotTableViewCell *)updateCell;

@end
