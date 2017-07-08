//
//  DLLoginView.h
//  Picto
//
//  Created by Mark Gage on 2017-07-07.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DLLoginStatusOK,
    DLLoginStatusError,
    DLLoginStatusCancel,
    DLLoginStatusSkip
} DLLoginStatus;

@class DLLoginView;

@protocol DLLoginViewDelegate <NSObject>
- (void)loginView:(DLLoginView *)loginView loginStatus:(DLLoginStatus)status;
@end

@interface DLLoginView : UIView
@property (assign, nonatomic) id<DLLoginViewDelegate> delegate;
@end
