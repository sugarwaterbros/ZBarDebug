# ZBarSDK with ARC enabled application crash! source of crash and avoiding crash.

## Problem
ZBarSDK 1.3.1 linked with ARC enabled application cause over release
(reference count -1) in `ZBarReaderViewImpl_Simulator.m: - (void)onStopVideo`
as screenshot.

![Zombie-Messaged-Screenshot](https://raw.github.com/sugarwaterbros/ZBarDebug/master/Zombie-Messaged.png)


## How to see the problem
1. Download xcode project
2. Choose Scheme "ZBarDebugArc>iPhone 5.1 Simulator"
3. Execute Xcode menu "Product>Profile" to run on Instruments
4. Select "Zombie" on Instruments startup dialog then click Profile button
5. Application start on Simulator titled "ZBarDebug ARC" and 4 disclosure rows
6. Click "Sample 3", ZBarReaderView  will appear (do nothing)
7. Click back button on Navigation bar
8. Milliseconds later, "Zombie Messaged" wil happen


## The Source of Problem 
ARC application may release object much earlier than Non-ARC application.
On my case the source of problem may be: 
 
    ZBarReaderViewImpl_Simulator.m: line 134-144 
        134: - (void) stop 
        135: { 
        136:     if(!started) 
        137:         return; 
        138:     [super stop]; 
        139:     running = NO; 
        140: 
        141:     [self performSelector: @selector(onVideoStop) 
        142:                withObject: nil 
        143:                afterDelay: 0.5]; 
        144: } 
 
After 0.5 delay, the ViewController has already been released in ARC application.

May the other lines use afterDelay cause crash ?
Why Non-ARC application never crash ?
I don't know the reason why the selector must be delayed,
but it may keep ARC application away from ZBarSDK.


## Avoid the problem
Keep viewController which manage the view including ZBarReaderView in some where after disposing the view. My code is `ZBarViewController.m` line 152.


Or set nil to ZBarReaderView readerDelegate when the viewController become unretained.
My code is `Sample5ViewController.m` line 172.


## ZBarSDK & Tools
* ZBarSDK 1.3.1
* MacOS X 10.6.8
* Xcode 4.2 build 4C199


## Application
xcode project includes 5 ZBar samples

* Sample 1: use ZBarReaderViewController, runs fine on both ARC and non-ARC
* Sample 2: embedded ZBarReaderView in xib with some other parts, crash on ARC
* Sample 3: ONLY ZBarReaderView in xib, crash on ARC
* Sample 4: Sample 2 class and xib but keep viewController, **NOT** crash on ARC
* Sample 5: set nil to readerDelegate when the viewController become unretained, **NOT** crash under ARC


## Project Targets
1. ZBarDebugNoARC -- application without ARC, runs fine!
    - Build Settings
        - Apple LLVM Compiler 3.0 - Language
            - Objective-C Automatic Reference Counting **NO**
        - Apple LLVM Compiler 3.0 - Preprocessing
            - ```NOARC=1```

2. ZBarDebugARC -- application with ARC, Sample 2&3 will crash
    - Build Settings
        - Apple LLVM Compiler 3.0 - Language
            - Objective-C Automatic Reference Counting **YES**

