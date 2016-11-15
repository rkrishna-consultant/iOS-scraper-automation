

#import "CustomPopUp.h"
#import "Util.h"

@implementation CustomPopUp{
    
    float popUpX;
    CGRect popUpRect;
}

@synthesize _click_delegate, _parent,textField;


-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate{
    
    self._click_delegate = theDelegate;
    self._parent = parent;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect rect = CGRectMake(0, 0, screenWidth, screenHeight);
    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    
    childPopUp = [UIView new];
    float popUpHeight = screenHeight/3;
    
    popUpX = 20.0;
    
    popUpRect = CGRectMake(popUpX, (screenHeight - popUpHeight)/2, screenWidth - (popUpX * 2), popUpHeight);
    childPopUp.center = self.center;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [self setBorderOnly:childPopUp withBGColor:[UIColor lightGrayColor] withCornerRadius:5.0 andBorderWidth:0.0 andBorderColor:[UIColor greenColor] WithAlpha:1];
    childPopUp.frame = popUpRect;
    [self addSubview:childPopUp];
  
    [self addLabel];
    [self addTextView];
    
    [self addButton];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
    
}

-(void) show{

    [self._parent.view addSubview:self];
}

-(void) addLabel{
    
    // Add Label
    UILabel *lblForDisplay=[[UILabel alloc]initWithFrame:CGRectMake(popUpX, popUpX+20, popUpRect.size.width - popUpX, popUpX)];
    lblForDisplay.backgroundColor=[UIColor clearColor];
    lblForDisplay.textColor=[UIColor whiteColor];
    lblForDisplay.text=@"Add Bundle Identifier";
    [childPopUp addSubview:lblForDisplay];
    
}

-(void) addTextView{
    
    // Add Label
   textField=[[UITextField alloc]initWithFrame:CGRectMake(popUpX, popUpX+popUpX+ 30, popUpRect.size.width - 40, 40)];
   // txtForDisplay.backgroundColor=[UIColor clearColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter bundle identifier";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    textField.delegate = self;
    
    [childPopUp addSubview:textField];
    
}



-(void) addButton{
    
    // Add Button
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(popUpX+70, childPopUp.frame.size.height - 70, popUpRect.size.width - 200, 40)];
    okBtn.backgroundColor=[UIColor blueColor];
    [self setBorderOnly:okBtn  withBGColor:[UIColor whiteColor] withCornerRadius:5.0 andBorderWidth:0.0 andBorderColor:[UIColor whiteColor] WithAlpha:1];
    [okBtn setTitle:@"Add" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(OnOKClick:) forControlEvents:UIControlEventTouchDown];
    [childPopUp addSubview:okBtn];
    
}

-(IBAction)OnOKClick :(id) sender{
    
    NSString *bundleID = [textField text];
    [_click_delegate okClicked:bundleID];
    
}

-(void) show : (UIViewController *) parent{
    
}

-(void) hide{
    
    [self removeFromSuperview];
    
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}


-(void) setBorderOnly:(UIView *) theView withBGColor:(UIColor *) color withCornerRadius :(float) radius andBorderWidth :(float) borderWidth andBorderColor :(UIColor *) bgColor WithAlpha:(float) curAlpha
{
    theView.layer.borderWidth = borderWidth;
    theView.layer.cornerRadius = radius;
    theView.layer.borderColor = [color CGColor];
    UIColor *c = [color colorWithAlphaComponent:curAlpha];
    theView.layer.backgroundColor = [c CGColor];
}

@end
