#import "OBAApplicationDelegate.h"
#import "OBAProgressIndicatorView.h"
#import "UITableViewController+oba_Additions.h"

@interface OBARequestDrivenTableViewController : UITableViewController

- (id)initWithApplicationDelegate:(OBAApplicationDelegate *)appDelegate;

@property (nonatomic, strong) OBAApplicationDelegate *appDelegate;

@property (nonatomic, strong) NSString *progressLabel;
@property (nonatomic) BOOL showUpdateTime;

@property (nonatomic) BOOL refreshable;
@property (nonatomic) NSInteger refreshInterval;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id<OBAModelServiceRequest> request;
@property (nonatomic, copy, readonly) OBADataSourceProgress progressCallback;

- (BOOL)isLoading;
- (void)refresh;

/**
    Subclasses must override this method to initiate a "refresh" operation.
    Once the operation completes or fails, the two methods below must be called
    to update the refresh control state.
 */
- (id<OBAModelServiceRequest>)handleRefresh;

/**
    Must be called with an HTTP status code to property update the UI of the
    refresh control.  Completion means any HTTP code that is not a result of a networking error.
 */
- (void)refreshCompleteWithCode:(NSUInteger)statusCode;
/**
    If a network operation failed with an error, this method must be called to complete the refresh.
 */
- (void)refreshFailedWithError:(NSError *)error;

@end
