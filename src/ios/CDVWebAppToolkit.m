#import "CDVWebAppToolkit.h"
#import <Cordova/CDV.h>
#import "CDVConnection.h"

@interface CDVWebAppToolkit ()

@end

@implementation CDVWebAppToolkit

- (void)pluginInitialize
{
    [super pluginInitialize];

    [self addActionBar];

    // observe notifications from network-information plugin to detect when device is offline
    //[[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(updateConnectivityStatus:)
    //                                             name:kReachabilityChangedNotification
    //                                           object:nil];
}

// receives the parsed manifest from the Javascript side - not implemented
- (void)initialize:(CDVInvokedUrlCommand *)command {
}

- (void)share:(CDVInvokedUrlCommand *)command {
}

- (void)shareUrl:(NSString *)url :(NSString *)message {
    NSURL *myWebsite = [NSURL URLWithString:url];

    NSArray *objectsToShare = @[message, myWebsite];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    activityVC.excludedActivityTypes = excludeActivities;

    [[self viewController] presentViewController:activityVC animated:YES completion:nil];
}

- (void)shareAction {
    NSString *currentURL = self.webView.request.URL.absoluteString;

    NSString *textToShare = @"Look at this awesome website!";

    [self shareUrl:currentURL :textToShare];
}

- (void)addActionBar {
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 55.0)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(navigateBack)];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(shareAction)];

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"App Title"];
    item.leftBarButtonItem = leftButton;
    item.rightBarButtonItem = rightButton;

    item.hidesBackButton = YES;

    [navBar pushNavigationItem:item animated:NO];

    [[[self viewController] view] addSubview: navBar];
}

- (void) navigateBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}


@end