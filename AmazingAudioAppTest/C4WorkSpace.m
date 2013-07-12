//
//  C4WorkSpace.m
//  AmazingAudioAppTest
//
//  Created by Adam Tindale on 2013-07-10.
//
// contains many lines of borrowed code from exmaples in TAAE and libpd

#import "C4WorkSpace.h"
#import "z_libpd.h"
#import "TheAmazingAudioEngine.h"

@implementation C4WorkSpace 
{
    AEAudioController * controller; 
    AEBlockChannel * channel;
    float * input;
}

-(void)setup {
    
    controller = [[AEAudioController alloc]
                       initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
                       inputEnabled:YES]; // don't forget to autorelease if you don't use ARC!

    libpd_init();
    libpd_init_audio((int)controller.numberOfInputChannels, 2, (int)controller.audioDescription.mSampleRate);
    libpd_start_message(1);
    libpd_add_float(1.0f);
    libpd_finish_message("pd", "dsp");
    
    NSString * patchName = @"boop.pd";
    NSString * pathName = [[NSBundle mainBundle] resourcePath];
    const char * base = [patchName cStringUsingEncoding:NSASCIIStringEncoding];
    const char * path = [pathName cStringUsingEncoding:NSASCIIStringEncoding];
    void * pdpatch = libpd_openfile(base, path);
    
    channel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                      UInt32           frames,
                                                      AudioBufferList *audio)
    {
        libpd_process_short(frames/64, audio->mBuffers[0].mData, audio->mBuffers[0].mData);
    }];
    
    [channel setAudioDescription:[AEAudioController interleaved16BitStereoAudioDescription]];
    [controller addChannels:[NSArray arrayWithObject:channel]];
    
    NSError *error = NULL;
    BOOL result = [controller start:&error];
    if ( !result ) {
        // Report error
    } 
}

@end
