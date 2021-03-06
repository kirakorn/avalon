#include "avalon/FacebookAds.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>

namespace avalon {
class FBIOSInterstitial;
class FBIOSBanner;
}

@interface FBIOSBannerViewDelegate : NSObject<FBAdViewDelegate>
{
    avalon::FBIOSBanner *_bannerView;
}
- (id) initWithBannerView:(avalon::FBIOSBanner*)bannerView;
@end

@interface FBIOSInterstitialDelegate : NSObject<FBInterstitialAdDelegate>
{
    avalon::InterstitialDelegate *_delegate;
    avalon::FBIOSInterstitial *_interstitial;
}
- (id) initWithDelegate:(avalon::InterstitialDelegate*) delegate andInterstitial:(avalon::FBIOSInterstitial*)interstitial;
@end

namespace avalon {

class FBIOSInterstitial:public FBInterstitial
{
public:
    
    FBIOSInterstitial(const std::string &placementID, avalon::InterstitialDelegate *delegate):FBInterstitial(placementID),_visible(false)
    {
        _interstitial = [[::FBInterstitialAd alloc] initWithPlacementID:[NSString stringWithUTF8String:placementID.c_str()]];
        _interstitial.delegate = [[FBIOSInterstitialDelegate alloc] initWithDelegate:delegate andInterstitial:this];
        [_interstitial loadAd];
    }
    ~FBIOSInterstitial()
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_interstitial.delegate];
        [_interstitial.delegate release];
        [_interstitial release];
    }
    
    virtual State getState() const override
    {
        if([_interstitial isAdValid])
            return State::READY;
        return State::LOADING;
    }
    
    bool isReady() const
    {
        return [_interstitial isAdValid];
    }
    
    virtual bool hide() override
    {
        return false;
    }
    
    virtual bool show() override
    {
        if(![_interstitial isAdValid])
            return false;
        _visible = [_interstitial showAdFromRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        return _visible;
    }
    
    void loadAd()
    {
        [_interstitial loadAd];
    }
    
    void setVisible(bool value)
    {
        _visible = value;
    }
    
private:;
    ::FBInterstitialAd *_interstitial;
    bool _visible;
};

class FBIOSBanner:public FBBanner
{
public:
    FBIOSBanner(const std::string &placementID, FBAdSize size, BannerDelegate *delegate):FBBanner(placementID, size),_ready(false),_delegate(delegate)
    {
        ::FBAdSize bannerSize;
        switch (size) {
            case FBAdSize::AdSize320x50:
                bannerSize = kFBAdSize320x50;
                break;
            case FBAdSize::AdSizeHeight50Banner:
                bannerSize = kFBAdSizeHeight50Banner;
                break;
            case FBAdSize::AdSizeHeight90Banner:
                bannerSize = kFBAdSizeHeight90Banner;
                break;
            default:
                assert((false, "Banner type not recognized"));
                break;
        }
        
        _bannerView = [[::FBAdView alloc] initWithPlacementID:[NSString stringWithUTF8String:placementID.c_str()] adSize:bannerSize rootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        _bannerView.delegate = [[FBIOSBannerViewDelegate alloc] initWithBannerView:this];
        [_bannerView loadAd];
    }
    
    ~FBIOSBanner()
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_bannerView.delegate];
        [_bannerView.delegate release];
        [_bannerView release];
    }
    
    virtual bool isReady() const override
    {
        return _ready;
    }
    
    virtual bool isVisible() const override
    {
        return [_bannerView isDescendantOfView:[UIApplication sharedApplication].keyWindow];
    };

    bool show(const CGRect &rect, BannerScaleType scaleType, BannerGravityType gravity)
    {
        if(!_ready)
            return false;
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_bannerView];
        
        CGRect bounds = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
        
        float xScale = 1.0f;
        float yScale = 1.0f;
        
        switch (scaleType) {
            case BannerScaleType::Fill:
                xScale = bounds.size.width / _bannerView.bounds.size.width;
                yScale = bounds.size.height / _bannerView.bounds.size.height;
                break;
                
            case BannerScaleType::Proportional:
                xScale = bounds.size.width / _bannerView.bounds.size.width;
                yScale = bounds.size.height / _bannerView.bounds.size.height;
                xScale = std::min(xScale, yScale);
                yScale = xScale;
                break;
                
            default:
                break;
        }
        
        _bannerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, xScale, yScale);
        
        switch (gravity) {
            case BannerGravityType::TopLeft:
                _bannerView.layer.anchorPoint = CGPointMake(0, 0);
                _bannerView.center = CGPointMake(rect.origin.x, rect.origin.y);
                break;
            case BannerGravityType::CenterLeft:
                _bannerView.layer.anchorPoint = CGPointMake(0, 0.5);
                _bannerView.center = CGPointMake(rect.origin.x, (rect.origin.y + rect.size.height)/2);
                break;
            case BannerGravityType::BottomLeft:
                _bannerView.layer.anchorPoint = CGPointMake(0, 1.0);
                _bannerView.center = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
                break;
            case BannerGravityType::TopCenter:
                _bannerView.layer.anchorPoint = CGPointMake(0.5, 0);
                _bannerView.center = CGPointMake((rect.origin.x + rect.size.width)/2, rect.origin.y);
                break;
            case BannerGravityType::Center:
                _bannerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                _bannerView.center = CGPointMake((rect.origin.x + rect.size.width)/2, (rect.origin.y + rect.size.height)/2);
                break;
            case BannerGravityType::BottomCenter:
                _bannerView.layer.anchorPoint = CGPointMake(0.5, 1.0);
                _bannerView.center = CGPointMake((rect.origin.x + rect.size.width)/2, rect.origin.y + rect.size.height);
                break;
            case BannerGravityType::TopRight:
                _bannerView.layer.anchorPoint = CGPointMake(1.0, 0);
                _bannerView.center = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y );
                break;
            case BannerGravityType::CenterRight:
                _bannerView.layer.anchorPoint = CGPointMake(1.0, 0.5);
                _bannerView.center = CGPointMake(rect.origin.x + rect.size.width, (rect.origin.y + rect.size.height)/2);;
                break;
            case BannerGravityType::BottomRight:
                _bannerView.layer.anchorPoint = CGPointMake(1.0, 1.0);
                _bannerView.center = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);;
                break;
                
            default:
                break;
        }
        return true;
    }
    
    virtual bool show(int x, int y, int width, int height, BannerScaleType scaleType, BannerGravityType gravity) override
    {
        CGRect rect = CGRectMake(x, y, width, height);
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) {
            float scale = [[UIScreen mainScreen] scale];
            rect.origin.x /= scale;
            rect.origin.y /= scale;
            rect.size.width /= scale;
            rect.size.height /= scale;
        }
        
        CGRect bounds = [UIApplication sharedApplication].keyWindow.rootViewController.view.bounds;
        
        rect.origin.y = bounds.size.height - rect.size.height - rect.origin.y;
        
        return show(rect, scaleType, gravity);
    }
    
    virtual bool show(BannerScaleType scaleType, BannerGravityType gravity) override
    {
        return show([UIApplication sharedApplication].keyWindow.rootViewController.view.bounds, scaleType, gravity);
    }
    
    virtual bool hide() override
    {
        if(!isVisible())
            return false;
        [_bannerView removeFromSuperview];
        return true;
    }
    
    void loadAd()
    {
        [_bannerView loadAd];
    }
    
    void adViewDidClick()
    {
        if(_delegate)
            _delegate->bannerUserInteraction(this);
        _bannerView.hidden = YES;
    }
    void adViewDidFinishHandlingClick()
    {
        if(_delegate)
            _delegate->bannerDidLeaveModalMode(this);
        _bannerView.hidden = NO;
    }
    void adViewDidLoad()
    {
        _ready = true;
        if(_delegate)
            _delegate->bannerDidLoadAd(this);
    }
    void adViewdidFailWithError(NSError *error)
    {
        _ready = false;
        if(_delegate)
            _delegate->bannerDidFailLoadAd(this, error.code == 1001?avalon::AdsErrorCode::NO_FILL:avalon::AdsErrorCode::INTERNAL_ERROR, (int)error.code, [[error localizedDescription] UTF8String]);
    }
    void adViewWillLogImpression()
    {
        
    }
    
private:
    bool _ready;
    ::FBAdView *_bannerView;
    BannerDelegate *_delegate;
};

class FBIOSAds: public FBAds
{
public:
    
    virtual const std::string& getVersion() const override
    {
        return _version;
    }
    
    virtual FBInterstitial* createInterstitial(const std::string &placementID, InterstitialDelegate *delegate) override
    {
        return new FBIOSInterstitial(placementID, delegate);
    }
    virtual FBBanner* createBanner(const std::string &placementID, FBAdSize adSize, BannerDelegate *delegate) override
    {
        return new FBIOSBanner(placementID, adSize, delegate);
    }

    virtual void addTestDevice(const std::string &deviceHash) override
    {
        [FBAdSettings addTestDevice:[NSString stringWithUTF8String:deviceHash.c_str()]];
    }

    virtual void addTestDevices(const std::vector<std::string> &deviceHash) override
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:deviceHash.size()];
        for(size_t i=0;i<deviceHash.size();++i)
            [array addObject:[NSString stringWithUTF8String:deviceHash[i].c_str()]];
        [FBAdSettings addTestDevices:array];
    }

    virtual void clearTestDevices() override
    {
        [FBAdSettings clearTestDevices];
    }

    virtual void setIsChildDirected(bool isChildDirected) override
    {
        [FBAdSettings setIsChildDirected:isChildDirected];
    }
    
    FBIOSAds():_version([FB_AD_SDK_VERSION UTF8String])
    {
    }
    
    
private:
    std::string _version;
};

FBAds *FBAds::getInstance()
{
    static FBIOSAds *instance = new FBIOSAds();
    return instance;
}
    
}

@implementation FBIOSBannerViewDelegate

- (id) initWithBannerView:(avalon::FBIOSBanner*)bannerView
{
    self = [super init];
    if (self) {
        self->_bannerView = bannerView;
    }
    
    return self;
}

- (void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}

- (void)adViewDidClick:(FBAdView *)adView
{
    _bannerView->adViewDidClick();
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView
{
    _bannerView->adViewDidFinishHandlingClick();
}

- (void)adViewDidLoad:(FBAdView *)adView
{
    _bannerView->adViewDidLoad();
}

- (void)loadAd
{
    _bannerView->loadAd();
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error
{
    _bannerView->adViewdidFailWithError(error);
    [self performSelector:@selector(loadAd) withObject:nil afterDelay:(error.code == 1001 || error.code == 1002)?60:10];
}

- (void)adViewWillLogImpression:(FBAdView *)adView
{
    _bannerView->adViewWillLogImpression();
}

@end



@implementation FBIOSInterstitialDelegate

- (id) initWithDelegate:(avalon::InterstitialDelegate*) delegate andInterstitial:(avalon::FBIOSInterstitial*)interstitial
{
    self = [super init];
    if (self) {
        self->_delegate = delegate;
        self->_interstitial = interstitial;
    }
    
    return self;
}

- (void) dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    if(_delegate)
        _delegate->interstitialUserInteraction(_interstitial, true);
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    if(_delegate)
        _delegate->interstitialDidHide(_interstitial);
    _interstitial->setVisible(false);
    _interstitial->loadAd();
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    if(_delegate)
        _delegate->interstitialDidLoadAd(_interstitial);
}

- (void)loadAd
{
    _interstitial->loadAd();
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [self performSelector:@selector(loadAd) withObject:nil afterDelay:(error.code == 1001 || error.code == 1002)?60:10];
    if(_delegate)
        _delegate->interstitialDidFailLoadAd(_interstitial, error.code == 1001?avalon::AdsErrorCode::NO_FILL:avalon::AdsErrorCode::INTERNAL_ERROR, (int)error.code, [[error localizedDescription] UTF8String]);
}

@end
