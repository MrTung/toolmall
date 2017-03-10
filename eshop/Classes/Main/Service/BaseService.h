//
//  BaseService.h
//  toolmall
//
//  Created by mc on 15/10/18.
//
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@protocol ServiceResponselDelegate <NSObject>

//@required
- (void)loadResponse:(NSString *) url response:(BaseModel *)response;

@optional

- (void)loadResponse:(NSString *)url data:(NSData *)data;

@end

@interface BaseService : NSObject

@property(nonatomic,weak) id <ServiceResponselDelegate> delegate;
@property(nonatomic,weak) UIView * parentView;

- (id)initWithDelegate:(id) _delegate parentView:(UIView *)_view;

- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj;
- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading;
- (void) request:(NSString *) api_url params:(NSDictionary*)params responseObj:(BaseModel*)responseObj showLoading:(Boolean)showLoading method:(NSString*)method;

@end


