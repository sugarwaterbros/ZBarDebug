# ZBarSDKをARCを有効にしたアプリケーションにリンクするとクラッシュ、原因の推測と回避策

## 問題点
ARCを有効にしたアプリケーションにZBarSDK 1.3.1をリンクすると
`ZBarReaderViewImpl_Simulator.m: - (void)onStopVideo`で
スクリーンショットの様にリリース超過（参照カウントが-1）が発生する。

![Zombie-Messaged-Screenshot](https://raw.github.com/sugarwaterbros/ZBarDebug/master/Zombie-Messaged.png)

## 再現方法
1. Xcodeプロジェクトをダウンロードする
2. Schemeの"ZBarDebugArc>iPhone 5.1 Simulator"を選ぶ
3. Xcodeメニュー"Product>Profile"でInstrumentsを起動
4. Instrumentsの起動ダイアログで"Zombie"を選んでProfileボタンをクリック
5. シミュレータでアプリケーションが起動、タイトルは"ZBarDebug ARC"、
4行のDisclosure表示がある
6. "Sample 3"をクリック、ZBarReaderViewを含むViewが表示される（何もしない）
7. ナビゲーションバーのバックボタンをクリック
8. 少しの時間の後、"Zombie Messaged"が発生する

## 原因（推察）
ARCを有効にしたアプリケーションでは、ARC無しのアプリケーションと比べて、
オブジェクトが早くリリースされるのかもしれない。
今回のケースで問題の原因は、以下の箇所と思われる。
 
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
 
ARCが有効なアプリケーションでは、0.5秒には既にViewControllerがリリースされている
ことになる。

他のafterDelayを使った行はクラッシュするだろうか？
ARC無しのアプリケーションは、なぜクラッシュしないのだろう？
selectorを遅延実行する理由は知らないが、遅延実行がZBarSDKをARCアプリケーションから使えなくするかもしれない。

## 回避方法
ZBarReaderViewを含むViewのviewControllerをViewが消去された後もどこかに保存しておく。実際のコードは`ZBarViewController.m`の152行目あたり。

## ZBarSDK & Tools
* ZBarSDK 1.3.1
* MacOS X 10.6.8
* Xcode 4.2 build 4C199

## アプリケーションプログラム
4通りのサンプルを実装

* Sample 1: ZBarReaderViewControllerを使用、ARCでもnon-ARCでも正常動作
* Sample 2: xibでZBarReaderViewと他の部品を含むViewを作る, ARCでクラッシュ
* Sample 3: ZBarReaderViewだけのxib, ARCでクラッシュ
* Sample 4: Sample 2のクラスとxibを使用、viewControllerを保存、ARCで正常動作


## Project Targets
1. ZBarDebugNoARC -- ARC無しターゲット、全て正常動作
    - Build Settings
        - Apple LLVM Compiler 3.0 - Language
            - Objective-C Automatic Reference Counting **NO**
        - Apple LLVM Compiler 3.0 - Preprocessing
            - ```NOARC=1```

2. ZBarDebugARC -- ARCを有効にしたターゲット, Sample 2と3はクラッシュ
    - Build Settings
        - Apple LLVM Compiler 3.0 - Language
            - Objective-C Automatic Reference Counting **YES**

