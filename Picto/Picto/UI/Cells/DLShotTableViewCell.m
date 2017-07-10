//
//  DLShotTableViewCell.m
//  Picto
//
//  Created by Mark Gage on 2017-07-08.
//  Copyright © 2017 Mark Gage. All rights reserved.
//

#import "DLShotTableViewCell.h"
#import "UIKit+AFNetworking.h"

@interface DLShotTableViewCell ()
@property (strong, nonatomic) DLShot *shot;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *byLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyImageView;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *gifBadgeLabel;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *commentView;


@end

@implementation DLShotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.baseView.layer setCornerRadius:3.0];
    [self.baseView.layer setBorderColor:[UIColor colorWithRed:(179.0/255.0) green:(179.0/255.0) blue:(179.0/255.0) alpha:1.0].CGColor];
    [self.baseView.layer setBorderWidth:0.5];
    
    [self.shotImageView.layer setBorderColor:[UIColor colorWithRed:(179.0/255.0) green:(179.0/255.0) blue:(179.0/255.0) alpha:1.0].CGColor];
    [self.shotImageView.layer setBorderWidth:0.5];
    
    [self.profilePicImageView.layer setCornerRadius:5.0];
    [self.profilePicImageView.layer setMasksToBounds:YES];
    
    [self.companyImageView.layer setCornerRadius:15];
    [self.companyImageView.layer setBorderWidth:2.0];
    [self.companyImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.companyImageView.layer setMasksToBounds:YES];
    [self.companyImageView setAlpha:0];
    
    [self.gifBadgeLabel.layer setCornerRadius:3.0];
    [self.gifBadgeLabel.layer setMasksToBounds:YES];
    [self.gifBadgeLabel setAlpha:0];
    
    UITapGestureRecognizer *commentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonPressed:)];
    [commentTapGesture setNumberOfTapsRequired:1];
    [self.commentView addGestureRecognizer:commentTapGesture];
    
    UITapGestureRecognizer *likeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonPressed:)];
    [likeTapGesture setNumberOfTapsRequired:1];
    [self.likeView addGestureRecognizer:likeTapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addShotData:(DLShot *)shot
{
    self.shot = shot;
}

- (DLShotTableViewCell *)updateCell
{
    [self.titleLabel setText:self.shot.title];
    [self.shotImageView setImageWithURL:[NSURL URLWithString:self.shot.imageURLString]];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.shot.user.avatarURL]];
    
    NSMutableString *byString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"by %@",self.shot.user.name]];
   
    if (self.shot.team) {
        [byString appendString:[NSString stringWithFormat:@" for %@",self.shot.team.companyName]];
        [self.companyImageView setImageWithURL:[NSURL URLWithString:self.shot.team.companyAvatarURL]];
        [self.companyImageView setAlpha:1.0];
    } else {
        [self.companyImageView setAlpha:0];
    }
    
    if (self.shot.team) {
        [self.byLabel setAttributedText:[self decorateForName:self.shot.user.name andTeam:self.shot.team.companyName From:byString]];
    } else {
        [self.byLabel setAttributedText:[self decorateForName:self.shot.user.name andTeam:@"" From:byString]];
    }
    
    [self.viewCountLabel setText:[NSString stringWithFormat:@"%d",self.shot.viewCount]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d",self.shot.commentCount]];
    [self.likeCountLabel setText:[NSString stringWithFormat:@"%d",self.shot.likeCount]];
    [self.createdAtLabel setText:[NSString stringWithFormat:@"%@",self.shot.createdAt]];
    
    if (self.shot.isAnimated) {
        [self.gifBadgeLabel setAlpha:1];
    } else {
        [self.gifBadgeLabel setAlpha:0];
    }
    
    return self;
}

- (NSMutableAttributedString *)decorateForName:(NSString *)name andTeam:(NSString *)team From:(NSString *)string
{
    NSString *expressionString = name;
    if (team.length>0) {
        expressionString = [expressionString stringByAppendingString:[NSString stringWithFormat:@"|%@",team]];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expressionString
                                                                           options:0
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, string.length)];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSRange wordRange = [match rangeAtIndex:0];
        UIColor *tagColor = [UIColor colorWithRed:(234.0/255.0)
                                            green:(76.0/255.0)
                                             blue:(137.0/255.0)
                                            alpha:1.0];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:tagColor range:wordRange];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0] range:wordRange];
        
    }
    return attributedString;
}

- (IBAction)moreButtonPressed:(id)sender
{
    NSLog(@"more pressd");
    if ([self delegate] && [self.delegate respondsToSelector:@selector(shotTableViewCell:buttonPressed:forShot:)]) {
        [self.delegate shotTableViewCell:self
                           buttonPressed:DLButtonTypeMore
                                 forShot:self.shot];
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSLog(@"share pressed");
    if ([self delegate] && [self.delegate respondsToSelector:@selector(shotTableViewCell:buttonPressed:forShot:)]) {
        [self.delegate shotTableViewCell:self
                           buttonPressed:DLButtonTypeShare
                                 forShot:self.shot];
        
    }
}

- (void)commentButtonPressed:(id)sender
{
    NSLog(@"comment pressed");
    if ([self delegate] && [self.delegate respondsToSelector:@selector(shotTableViewCell:buttonPressed:forShot:)]) {
        [self.delegate shotTableViewCell:self
                           buttonPressed:DLButtonTypeComment
                                 forShot:self.shot];
        
    }
}

- (void)likeButtonPressed:(id)sender
{
    NSLog(@"like pressed");
    if ([self delegate] && [self.delegate respondsToSelector:@selector(shotTableViewCell:buttonPressed:forShot:)]) {
        [self.delegate shotTableViewCell:self
                           buttonPressed:DLButtonTypeLike
                                 forShot:self.shot];
        
    }
}
@end
