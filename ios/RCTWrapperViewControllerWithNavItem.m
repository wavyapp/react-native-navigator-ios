/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTWrapperViewControllerWithNavItem.h"

#import <UIKit/UIScrollView.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <React/RCTAutoInsetsProtocol.h>

#import "RCTNavItem.h"

@implementation RCTWrapperViewControllerWithNavItem

@synthesize navItem = _navItem;

- (instancetype)initWithNavItem:(RCTNavItem *)navItem
{
  if ((self = [super initWithContentView:navItem])) {
    _navItem = navItem;
  }
  return self;
}

static UIView *RCTFindNavBarShadowViewInView(UIView *view)
{
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *shadowView = RCTFindNavBarShadowViewInView(subview);
        if (shadowView) {
            return shadowView;
        }
    }
    return nil;
}

- (void)setNavItem:(RCTNavItem *)navItem;
{
  if (navItem != _navItem)
  {
    // stop observing of current item if possible
    [self stopNavigationItemChangeObserving];
    _navItem = navItem;
    // start observing for new nav item if possible
    [self startNavigationItemChangeObserving];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateNavigationBar:animated];
      // begin nav item observation if not already started
    [self startNavigationItemChangeObserving];
}

 - (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  // do not observing nav item changes anymore
  [self stopNavigationItemChangeObserving];
}

 - (void)dealloc {
  // remove possibly set nav item observer
  [self stopNavigationItemChangeObserving];
}


- (void)updateNavigationBar:(BOOL)animated
    {
    // TODO: find a way to make this less-tightly coupled to navigation controller
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        [self.navigationController
         setNavigationBarHidden:_navItem.navigationBarHidden
         animated:animated];

        UINavigationBar *bar = self.navigationController.navigationBar;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
        bar.barTintColor = _navItem.barTintColor;
        bar.tintColor = _navItem.tintColor;
        bar.translucent = _navItem.translucent;
        #if !TARGET_OS_TV
            bar.barStyle = _navItem.barStyle;
        #endif
        bar.titleTextAttributes = _navItem.titleTextColor ? @{
                                                              NSForegroundColorAttributeName: _navItem.titleTextColor,
                                                              NSFontAttributeName: [UIFont fontWithName:@"Whitney-Semibold" size:18.0]
                                                              } : nil;

        RCTFindNavBarShadowViewInView(bar).hidden = _navItem.shadowHidden;

        UINavigationItem *item = self.navigationItem;
        item.title = _navItem.title;
        item.titleView = _navItem.titleImageView;
#if !TARGET_OS_TV
        item.backBarButtonItem = _navItem.backButtonItem;
#endif //TARGET_OS_TV
        item.leftBarButtonItem = _navItem.leftButtonItem;
        item.rightBarButtonItem = _navItem.rightButtonItem;
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // There's no clear setter for navigation controllers, but did move to parent
    // view controller provides the desired effect. This is called after a pop
    // finishes, be it a swipe to go back or a standard tap on the back button
    [super didMoveToParentViewController:parent];
    if (parent == nil || [parent isKindOfClass:[UINavigationController class]]) {
        [self.navigationListener wrapperViewController:self
                         didMoveToNavigationController:(UINavigationController *)parent];
    }
}

- (void)startNavigationItemChangeObserving
{
  // starts observing for nav item property changes if not
  // not already listen for
  if (_navItem && !_navItemObserving) {
    _navItemObserving = true;
    [_navItem addObserver:self forKeyPath:@"propertiesChanged" options:NSKeyValueObservingOptionNew context:nil];
  }
}
 - (void)stopNavigationItemChangeObserving
{
  // stops observing the current nav item for property changes
  // if item is valid and observed before
  if (_navItem && _navItemObserving) {
    @try {
      _navItemObserving = false;
      [_navItem removeObserver:self forKeyPath:@"propertiesChanged"];
    }
    @catch (NSException * __unused exception) {}
  }
}
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
  if (object == _navItem) {
    [self updateNavigationBar:false];
  }
}

@end

