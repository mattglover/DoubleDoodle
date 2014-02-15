#import <Kiwi/Kiwi.h>

#import "DDDDoodleContainerViewController.h"

SPEC_BEGIN(DoodleConainerViewControllerSpec)

describe(@"DDDDoodleContainerViewController", ^{
    
    __block DDDDoodleContainerViewController *sut;
    
    // Fixtures and Setup/Tear Down
    beforeEach(^{
        sut = [[DDDDoodleContainerViewController alloc] init];
    });
    
    afterEach(^{
        sut = nil;
    });
    
    context(@"when created", ^{
        
        it(@"should not be nil", ^{
            
        });
        
        context(@"with a designated initialiser with XML", ^{
            
            it(@"should have it's correct properties set", ^{
                
            });
        });
        
    });
});

SPEC_END