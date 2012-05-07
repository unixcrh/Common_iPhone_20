//
//  AudioManager.m
//  Shuriken
//
//  Created by Orange on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PPDebug.h"

AudioManager* backgroundMusicManager;
AudioManager* soundManager;

static AudioManager* globalGetAudioManager()
{
    if (backgroundMusicManager == nil) {
        backgroundMusicManager = [[AudioManager alloc] init];
    }
    return backgroundMusicManager;
}

@implementation AudioManager
@synthesize backgroundMusicPlayer = _backgroundMusicPlayer;
@synthesize sounds = _sounds;
@synthesize isSoundOn = _isSoundOn;
@synthesize isMusicOn = _isMusicOn;

- (void)setBackGroundMusicWithName:(NSString*)aMusicName
{
    NSString* name;
    NSString* type;
    NSString *soundFilePath;
    NSArray* nameArray = [aMusicName componentsSeparatedByString:@"."];
    if ([nameArray count] == 2) {
        name = [nameArray objectAtIndex:0];
        type = [nameArray objectAtIndex:1];
        soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    } else {
        soundFilePath = [[NSBundle mainBundle] pathForResource:aMusicName ofType:@"mp3"];
    }
    if (soundFilePath) {
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        [self.backgroundMusicPlayer initWithContentsOfURL:soundFileURL error:nil];
        self.backgroundMusicPlayer.numberOfLoops = -1; //infinite
    }
    
}

- (void)initSounds:(NSArray*)soundNames
{
    SystemSoundID soundId;
    self.isSoundOn = YES;
    for (NSString* soundName in soundNames) {
        NSString* name;
        NSString* type;
        NSString *soundFilePath;
        NSArray* nameArray = [soundName componentsSeparatedByString:@"."];
        if ([nameArray count] == 2) {
            name = [nameArray objectAtIndex:0];
            type = [nameArray objectAtIndex:1];
            soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
        } else {
            soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"WAV"];
        }
        if (soundFilePath) {
            NSURL* soundURL = [NSURL fileURLWithPath:soundFilePath];
            
            //Register sound file located at that URL as a system sound
            OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundId);
            [self.sounds addObject:[NSNumber numberWithInt:soundId]];
            if (err != kAudioServicesNoError) {
                PPDebug(@"<AudioManager>Could not load %@, error code: %ld", soundURL, err);
            }
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundMusicPlayer = [[AVAudioPlayer alloc] init];
        _sounds = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [_backgroundMusicPlayer release];
    [_sounds release];
    [super dealloc];
}

+ (AudioManager*)defaultManager
{
    return globalGetAudioManager();
}

- (void)playSoundById:(NSInteger)aSoundIndex
{
    if (self.isSoundOn) {
        if (aSoundIndex < 0 || aSoundIndex >= [self.sounds count]){
            PPDebug(@"<playSoundById> but sound index (%d) out of range", aSoundIndex);
            return;
        }

        NSNumber* num = [self.sounds objectAtIndex:aSoundIndex];
        SystemSoundID soundId = num.intValue;
        AudioServicesPlaySystemSound(soundId);
        PPDebug(@"<AudioManager>play sound-%d, systemId=%d", aSoundIndex, num.intValue);
    }    
}

- (void)backgroundMusicStart
{
    //[self setBackGroundMusicWithName:@"sword.mp3"];
    //[self.backgroundMusicPlayer play];
    
}

- (void)backgroundMusicPause
{
    //[self.backgroundMusicPlayer pause];
}

- (void)backgroundMusicContinue
{
    //[self.backgroundMusicPlayer play];
}

- (void)backgroundMusicStop
{
    //[self.backgroundMusicPlayer stop];
}

- (void)vibrate
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
@end
