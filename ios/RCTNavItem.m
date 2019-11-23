/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTNavItem.h"

@implementation RCTNavItem

@synthesize backButtonItem = _backButtonItem;
@synthesize leftButtonItem = _leftButtonItem;
@synthesize rightButtonItem = _rightButtonItem;

- (UIImageView *)titleImageView
{
  if (_titleImage) {
    return [[UIImageView alloc] initWithImage:_titleImage];
  } else {
    return nil;
  }
}

-(instancetype)init
{
  if (self = [super init]) {
    _leftButtonSystemIcon = NSNotFound;
    _rightButtonSystemIcon = NSNotFound;
  }
  return self;
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle
{
  _backButtonTitle = backButtonTitle;
  _backButtonItem = nil;
}

- (void)setBackButtonIcon:(UIImage *)backButtonIcon
{
  _backButtonIcon = backButtonIcon;
  _backButtonItem = nil;
}

- (UIBarButtonItem *)backButtonItem
{
    _backButtonItem =[[UIBarButtonItem alloc]initWithTitle:_backButtonTitle
                      style:UIBarButtonItemStyleDone
                      target: nil
                      action: nil];
    NSDictionary *textAttribute = @{
          NSFontAttributeName: [UIFont fontWithName:@"Whitney-Medium" size:16.0],
    };
    [_backButtonItem setTitleTextAttributes: textAttribute forState:UIControlStateNormal];
    [_backButtonItem setTitleTextAttributes: textAttribute forState:UIControlStateHighlighted];
  return _backButtonItem;
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
  _leftButtonTitle = leftButtonTitle;
  _leftButtonItem = nil;
}

- (void)setLeftButtonIcon:(UIImage *)leftButtonIcon
{
  _leftButtonIcon = leftButtonIcon;
  _leftButtonItem = nil;
}

- (void)setLeftButtonSystemIcon:(UIBarButtonSystemItem)leftButtonSystemIcon
{
  _leftButtonSystemIcon = leftButtonSystemIcon;
  _leftButtonItem = nil;
}

- (UIBarButtonItem *)leftButtonItem
{
  if (!_leftButtonItem) {
    if (_leftButtonIcon) {
      _leftButtonItem =
      [[UIBarButtonItem alloc] initWithImage:_leftButtonIcon
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleLeftButtonPress)];

    } else if (_leftButtonTitle.length) {
      _leftButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:_leftButtonTitle
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleLeftButtonPress)];

    } else if (_leftButtonSystemIcon != NSNotFound) {
      _leftButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:_leftButtonSystemIcon
                                                    target:self
                                                    action:@selector(handleLeftButtonPress)];
      NSDictionary *textAttribute = @{
            NSFontAttributeName: [UIFont fontWithName:@"Whitney-Medium" size:16.0],
      };
      [_leftButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
      [_leftButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateHighlighted];
    } else {
      _leftButtonItem = nil;
    }
  }
  return _leftButtonItem;
}

- (void)handleLeftButtonPress
{
  if (_onLeftButtonPress) {
    _onLeftButtonPress(nil);
  }
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle
{
  _rightButtonTitle = rightButtonTitle;
  _rightButtonItem = nil;
}

- (void)setRightButtonIcon:(UIImage *)rightButtonIcon
{
  _rightButtonIcon = rightButtonIcon;
  _rightButtonItem = nil;
}

- (void)setRightButtonSystemIcon:(UIBarButtonSystemItem)rightButtonSystemIcon
{
  _rightButtonSystemIcon = rightButtonSystemIcon;
  _rightButtonItem = nil;
}

- (UIBarButtonItem *)rightButtonItem
{
  if (!_rightButtonItem) {
    if (_rightButtonIcon) {
      _rightButtonItem =
      [[UIBarButtonItem alloc] initWithImage:_rightButtonIcon
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleRightButtonPress)];

    } else if (_rightButtonTitle.length) {
      _rightButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:_rightButtonTitle
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleRightButtonPress)];

    } else if (_rightButtonSystemIcon != NSNotFound) {
      _rightButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:_rightButtonSystemIcon
                                      target:self
                                      action:@selector(handleRightButtonPress)];
    NSDictionary *textAttribute = @{
          NSFontAttributeName: [UIFont fontWithName:@"Whitney-Medium" size:16.0],
    };
    [_rightButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    [_rightButtonItem setTitleTextAttributes:textAttribute forState:UIControlStateHighlighted];
    } else {
      _rightButtonItem = nil;
    }
  }
  return _rightButtonItem;
}

- (void)handleRightButtonPress
{
  if (_onRightButtonPress) {
    _onRightButtonPress(nil);
  }
}

- (id)propertiesChanged {
  return nil;
}
 + (NSSet *)keyPathsForValuesAffectingPropertiesChanged {
  // all properties that effects the navigation bar
  NSString * const properties[] = {
   @"title",
   @"titleImage",
   @"leftButtonIcon",
   @"leftButtonTitle",
   @"rightButtonIcon",
   @"rightButtonTitle",
   @"backButtonIcon",
   @"backButtonTitle",
   @"navigationBarHidden",
   @"shadowHidden",
   @"tintColor",
   @"barTintColor",
   @"titleTextColor",
   @"translucent",
   @"titleImageView",
   @"backButtonItem",
   @"leftButtonItem",
   @"rightButtonItem",
   @"onLeftButtonPress",
   @"onRightButtonPress",
  };
   NSUInteger numProps = (NSUInteger) (sizeof(properties) / sizeof(NSString*));
  return [NSSet setWithObjects:properties count:numProps];
}


@end
