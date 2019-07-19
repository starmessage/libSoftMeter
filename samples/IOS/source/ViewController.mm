//
//  ViewController.m
//  SoftMeter application analytics IOS demo
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//    https://www.starmessagesoftware.com/softmeter
//

#include "../../../bin/libSoftMeter-IOS.framework/Headers/SoftMeter-C-Api.h"
#import "ViewController.h"

// The file extension of this source file must be .mm so that it is compiled as Obj-C++

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnExit;
@property (weak, nonatomic) IBOutlet UIButton *btnPressMe;
@property (retain, nonatomic) IBOutlet UITextView *IBOutlet_logFileView;

@end

@implementation ViewController


- (IBAction)onPress_ButtonPressMe:(id)sender
{
    // note: rate limits apply:
    // 300 hits per session (app run), 10 available for burst, replenished at a rate of 1 per 2 seconds
    sendEvent("IOS event", "Button pressed", 0);
    [self refreshLogView];
}


- (IBAction)onPress_ButtonExit:(id)sender {
    exit(0);
}

- (void) refreshLogView
{
    NSString *path = [NSString stringWithUTF8String:getLogFilename()];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    self.IBOutlet_logFileView.text = content;
    // [content release];
    // [path release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshLogView];
}


- (void)dealloc {
    [_IBOutlet_logFileView release];
    [super dealloc];
}
@end
