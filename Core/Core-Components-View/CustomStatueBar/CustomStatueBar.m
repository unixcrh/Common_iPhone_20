
#import "CustomStatueBar.h"

@implementation CustomStatueBar
@synthesize customStatueBarDelegate = _customStatueBarDelegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = frame;
        self.backgroundColor = [UIColor orangeColor];
        
        textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        textButton.frame = self.bounds;
        [textButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:textButton];
        textButton.clipsToBounds = NO;
        [textButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [textButton addTarget:self action:@selector(clickTextButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showStatusMessage:(NSString *)message{
    self.hidden = NO;
    self.alpha = 1.0f;    
    [textButton setTitle:message forState:UIControlStateNormal];

}

- (void)clickTextButton:(id)sender
{
    if (_customStatueBarDelegate && [_customStatueBarDelegate respondsToSelector:@selector(didClickStatueBar:)]) {
        [_customStatueBarDelegate didClickStatueBar:self];
    }else{
        [self hide];
    }
}

- (void)hide{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        self.hidden = YES;
    }];;

}
- (void)changeMessge:(NSString *)message{
    [self showStatusMessage:message];
    CGPoint origin = self.bounds.origin;
    CGSize size = self.bounds.size;
    textButton.frame = CGRectMake(origin.x + size.width, origin.y, size.width, size.height);
    [UIButton beginAnimations:nil context:NULL];
    [UIButton setAnimationDuration:1.5];
    textButton.frame = self.bounds;    
    [UIButton commitAnimations];
}
- (void)dealloc{
    [super dealloc];
}
@end
