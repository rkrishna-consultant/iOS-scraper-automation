
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ClickDelegates;



@interface CustomPopUp : UIView{
    
      UIView *childPopUp;
      id<ClickDelegates> _click_delegate;
      UIViewController *_parent;
  
    
    
}

@property (nonatomic, retain) id<ClickDelegates> _click_delegate;
@property (nonatomic, retain) UIViewController *_parent;
@property (nonatomic, retain) UITextField *textField;


-(void) initAlertwithParent : (UIViewController *) parent withDelegate : (id<ClickDelegates>) theDelegate;

-(IBAction)OnOKClick :(id) sender;

-(void) hide;

-(void) show;

@end


// Delegate

@protocol ClickDelegates<NSObject>

@optional

-(void) okClicked:(NSString*) identifier;
-(void) cancelClicked;

@end
