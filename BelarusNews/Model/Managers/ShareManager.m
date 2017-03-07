//
//  ShareManager.m
//  BelarusNews
//
//  Created by Admin on 1/5/17.
//  Copyright © 2017 YAUHENI DROBAU. All rights reserved.
//

#import "ShareManager.h"
#import "Macros.h"

@interface ShareManager ()

@end

@implementation ShareManager
SINGLETON(ShareManager)

-(NSString*)shareWithServiceID:(ShareServiceType)serviceID AndEntity:(NewsEntity *)entity {
    
    NSString *authLink;
    NSURL *imageUrl = [NSURL URLWithString:entity.urlImage];
    NSURL *url = [NSURL URLWithString:entity.linkFeed];
    if (serviceID == ShareServiceTypeFacebook){
        authLink = [NSString stringWithFormat:@"https://m.facebook.com/sharer.php?u=%@&image=%@", url,imageUrl];
    } else if (serviceID == ShareServiceTypeTwitter){
        authLink = [NSString stringWithFormat:@"http://twitter.com/intent/tweet?source=sharethiscom&url=%@", url];
    } else if (serviceID == ShareServiceTypeVK){
        authLink = [NSString stringWithFormat:@"http://vkontakte.ru/share.php?&url=%@&image=%@", url,imageUrl];
    } else if (serviceID == ShareServiceTypeOK){
        authLink = [NSString stringWithFormat:@"http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=%@", url];
    } else if (serviceID == ShareServiceTypeGooglePlus){
        authLink = [NSString stringWithFormat:@"https://plus.google.com/share?url=%@", url];
    }
    return authLink;
}
@end
