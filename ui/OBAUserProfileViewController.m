//
//  OBAUserProfileViewController.m
//  org.onebusaway.iphone
//
//  Created by Kevin Pham on 3/22/15.
//  Copyright (c) 2015 OneBusAway. All rights reserved.
//

#import "OBAUserProfileViewController.h"
#import "OBASettingsViewController.h"
#import "OBAUser.h"

@interface OBAUserProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPoints;
@property (weak, nonatomic) IBOutlet UIView *profileBox;
@property (weak, nonatomic) IBOutlet UITableView *userActivity;
@property (weak, nonatomic) IBOutlet UICollectionView *badgeCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *picture1;
@property (weak, nonatomic) IBOutlet UIImageView *picture2;
@end

@implementation OBAUserProfileViewController

- (id)init {
    self = [super initWithNibName:@"OBAUserProfileViewController" bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"");
        self.tabBarItem.image = [UIImage imageNamed:@"profile"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGRect indicatorBounds = CGRectMake(12, 12, 36, 36);
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        indicatorBounds.origin.y += self.navigationController.navigationBar.frame.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
    }

    OBAUser *user = (OBAUser*)[PFUser currentUser];

    self.badgeCollectionView.delegate = self;

    self.view.backgroundColor = OBAGREEN;

    self.profileBox.layer.cornerRadius = 20;
    CGRect profileFrame = [self.view frame];
    profileFrame.origin.x = 25.0f;
    profileFrame.origin.y = 100.0f;
    [self.view addSubview:_profileBox];

    //User picture set-up
    self.userPicture.layer.cornerRadius = 50;
    self.userPicture.layer.masksToBounds = true;
    self.userPicture.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userPicture.backgroundColor = [UIColor lightGrayColor];
    self.userPicture.layer.borderWidth = 4;
    self.userPicture.contentMode = UIViewContentModeScaleAspectFill;

    [self.cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if (user.imageURL) {
        @weakify(self);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:user.imageURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @strongify(self);

            if (data.length > 0 && !error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);

                    UIImage *picture = [UIImage imageWithData:data];

                    if (picture) {
                        self.userPicture.image = picture;
                        self.cameraButton.hidden = YES;
                    }
                });
            }
        }];
        [dataTask resume];
    }

    self.userName.text = user.displayName ?: NSLocalizedString(@"A OneBusAway User", @"");

    self.userPoints.text = [NSString stringWithFormat:@"%@ Points", @(user.points.integerValue)];

    //THIS WILL BE DELETED AND REPLACED WITH COLLECTION VIEW
    self.picture1.layer.cornerRadius = 25;
    self.picture1.layer.masksToBounds = true;

    self.picture2.layer.cornerRadius = 25;
    self.picture2.layer.masksToBounds = true;

    
    //settings button
//    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
//  self.navigationItem.rightBarButtonItem = settingsButton;
}

//settings button pressed
-(void)settingsButtonPressed {
    OBASettingsViewController *vc = [[OBASettingsViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:true];
}


//Camera Button Pressed
-(void)cameraButtonPressed {
  UIImagePickerController *picturePicker = [[UIImagePickerController alloc] init];
  picturePicker.delegate = self;
  picturePicker.allowsEditing = true;
  picturePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
  [self.navigationController presentViewController:picturePicker animated:true completion:nil];
  
}

#pragma mark UserActivity CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
  return cell;
}

//MARK: Image Picker Controller Delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  self.userPicture.image = chosenImage;
    self.cameraButton.imageView.image = nil;
  
  //Save selected image locally
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyPicture.jpg"];
  
  NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.85);
  [imageData writeToFile:filePath atomically:YES];
  
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
  
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end