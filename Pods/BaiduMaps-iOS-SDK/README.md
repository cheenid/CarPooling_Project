the BaiduMaps-iOS-SDK is pull to CocoaPod spec. wait for it.

> BaiduMaps-iOS-SDK is for iphone, not for iphonesimulator, your can copy BaiduMaps-iOS-SDK.podspec to  ~/.cocoapods/repos/master/BaiduMaps-iOS-SDK/2.2.1/, If you do not have this folder “BaiduMaps-iOS-SDK/2.2.1/”, you should creat it. Test "pod search BaiduMaps-iOS-SDK" in shell. 

-> BaiduMaps-iOS-SDK (2.2.1)
   Baidu Maps SDK for iOS
   pod 'BaiduMaps-iOS-SDK', '~> 2.2.1'
   - Homepage: http://developer.baidu.com/map/sdk-ios.htm
   - Source:   https://github.com/tiandabao/BaiduMaps-iOS-SDK.git
   - Versions: 2.2.1 [master repo]

if you find it, Congratulations, your can add "pod 'BaiduMaps-iOS-SDK', '~> 2.2.1'" to your Podfile file.


添加完成之后，要手动添加".a" 文件， 静态库中采用 ObjectC++实现,因此需要您保证您工程中至少有一个.mm 后缀的源文件(您可以将任意一个.m 后缀的文件改名为.mm),或者在工程属性中指定编译方式,即将 XCode 的TARGETS -> Build Settings -> App LLVM 5.1 - Language ->  Compile Sources As 设置为"Objective-C++"
