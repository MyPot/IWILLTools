# IWILLTools

iOS 开发常用工具、代码。

主要就是一些iOS开发中会经常用到的一些代码。使用**Swift**构建，基于iOS8.0，相信很多代码在iOS7上也是可以正常工作的。这部分代码并不适合当作第三方库添加到项目中，最好作为参考使用，所以我也就没添加**Carthage**和**CocoaPods**的支持。

## TransitionAnimate

Controller间的转场动画，目前添加了Push & Pop以及模态的转场动画。

主要参考的这篇文章， [ 关于自定义转场动画，我都告诉你 ](http://www.cocoachina.com/ios/20150719/12600.html)。

第三种**Segue**的方式这里没做。

## UICollectionViewLayout

实现了圆圈的布局，另外一个还未实现。

[ UICollectionViewLayout ](http://blog.csdn.net/majiakun1/article/details/17204921)。

## Cache

缓存默认存储在**IWCache**文件夹中。

`func cacheExistsWithdestinationPath(url: NSURL) -> (filePath: String, isExists: Bool)`方法会判断URL是否缓存过。

`func dataWithURL(url: NSURL, finish: Finish)`方法会缓存这个URL。

## AudioPlayer

音频播放：支持播放本地音频和网络音频。

本地音频支持播放完成后的回调。

远程音频支持播放进度和缓存。

## VideoPlayer

TODO...

## Net

使用**NSURLSession**完成网络请求、下载和上传。

实现了网络请求、下载。上传还未测试。

## Type

类型。

## Extension

拓展。

## Utility

文件工具类和设备信息工具类。



之后会不断的进行完善。
