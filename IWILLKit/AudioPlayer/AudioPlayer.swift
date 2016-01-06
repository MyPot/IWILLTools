//
//  AudioPlayer.swift
//  IWILLKit
//
//  Created by Lynch Wong on 12/29/15.
//  Copyright © 2015 Lynch Wong. All rights reserved.
//

import AVFoundation

/// 音频播放
public class AudioPlayer: NSObject {
    
    /// 背景音乐和音效播放完成后会执行的闭包类型
    public typealias LocalCompleteHandler = () -> ()
    
    public typealias ProgressHandler = (CGFloat) -> ()
    
    /// 背景音乐和音效播放完成后会执行的闭包
    public var completeHandler: LocalCompleteHandler!
    
    /// 播放音效音乐的AVAudioPlayer，只支持播放本地的，要播放远程的可以先下载再播放或者使用其它的方法
    public var soundEffectPlayer: AVAudioPlayer!
    
    /// 播放背景音乐，AVAudioPlayer只支持播放本地的，要播放远程的可以先下载再播放或者使用其它的方法
    public var backgroundMusicPlayer: AVAudioPlayer!
    
    public var remotePlayer: AVPlayer!

    /**
     播放本地音效，只支持本地音效。
     
     - parameter url:      音效的URL，[[NSBundle mainBundle] URLForResource:@"unlock" withExtension:@"mp3"]
     - parameter complete: 播放结束、错误、打断后的回调
     */
    public func playSoundEffect(url: NSURL, completeHandler: LocalCompleteHandler? = nil) {
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOfURL: url)
            
            if let handler = completeHandler {
                self.completeHandler = handler
                soundEffectPlayer.delegate = self
            }
            
            soundEffectPlayer.numberOfLoops = 0
            soundEffectPlayer.prepareToPlay()
            soundEffectPlayer.play()
        } catch let error as NSError {
            print("Could not create audio player: \(error.localizedDescription)")
        }
    }
    
    /**
     暂停正在播放音效
     */
    public func pauseSoundEffect() {
        guard let player = soundEffectPlayer else {
            print("播放器不存在")
            return
        }
        if player.playing {
            player.pause()
        }
    }
    
    /**
     恢复暂停的音效
     */
    public func resumeSoundEffect() {
        guard let player = soundEffectPlayer else {
            print("播放器不存在")
            return
        }
        if !player.playing {
            player.play()
        }
    }
    
    /**
     播放本地背景音乐，只支持本地
     
     - parameter url:      音乐URL，[[NSBundle mainBundle] URLForResource:@"unlock" withExtension:@"mp3"]
     - parameter complete: 播放结束、错误、打断后的回调
     */
    public func playBackgroundMusic(url: NSURL, completeHandler: LocalCompleteHandler? = nil) {
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url)
            
            if let handler = completeHandler {
                self.completeHandler = handler
                backgroundMusicPlayer.delegate = self
            }
            
            backgroundMusicPlayer.numberOfLoops = 0
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print("Could not create audio player: \(error.localizedDescription)")
        }
    }
    
    /**
     暂停正在播放的背景音乐
     */
    public func pauseBackgroundMusic() {
        guard let player = backgroundMusicPlayer else {
            return
        }
        if player.playing {
            player.pause()
        }
    }
    
    /**
     恢复暂停的背景音乐
     */
    public func resumeBackgroundMusic() {
        guard let player = backgroundMusicPlayer else {
            return
        }
        if !player.playing {
            player.play()
        }
    }
    
    /**
     直接播放远程音频，不进行缓存，ProgressHandler 闭包的参数为当前播放进度。
     
     - parameter url:             远程音频 NSURL
     - parameter progressHandler: 处理当前播放进度
     */
    public func playRemoteSoundWithURL(url: NSURL, progressHandler: ProgressHandler? = nil) {
        //根据 NSURL 生成 AVPlayerItem
        let playerItem = AVPlayerItem(URL: url)
        //初始化播放器
        remotePlayer = AVPlayer(playerItem: playerItem)
        if let handler = progressHandler {//如果进度处理闭包存在就进行调用
            remotePlayer.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 10), queue: dispatch_get_main_queue(), usingBlock: { time in
                let current = CMTimeGetSeconds(time)
                let total = CMTimeGetSeconds(playerItem.duration)
                let progress = CGFloat(current / total)
                if !isnan(progress) {
                    handler(progress)
                }
            })
        }
        remotePlayer.play()//播放音频
    }
    
    /**
     播放远程音频，会对音频文件进行缓存，ProgressHandler 闭包的参数为当前播放进度。
     
     - parameter url:             远程音频 NSURL
     - parameter progressHandler: 处理当前播放进度
     */
    public func playRemoteSoundUseCacheWithURL(url: NSURL, progressHandler: ProgressHandler? = nil) {

        //首先判断当前的 NSURL 是否缓存过
        let result = IWCache.sharedInstance.cacheExistsWithdestinationPath(url)
        
        //如果缓存过
        if result.isExists {
            
            //缓存过且不需要监控进度，我们直接使用播放本地音频的方法进行播放然后退出
            guard let handler = progressHandler else {
                playSoundEffect(NSURL(fileURLWithPath: result.filePath))
                return
            }
            
            //缓存过且需要监控进度，播放然后退出
            playCachedRemoteSoundWithURL(url, filePath: result.filePath, progressHandler: handler)
            
            return
        }
        
        //如果没有缓存过，我们进行缓存
        IWCache.sharedInstance.dataWithURL(url) {
            
            //缓存过程中有错误
            if $1 != nil {
                //缓存发生错误时我们使用不需要缓存的方法来播放
                self.playRemoteSoundWithURL(url, progressHandler: progressHandler)
                return
            }
            
            //没有发生错误
            if let filePath = $0 {
                
                //缓存成功且不需要监控进度，使用播放本地音频的方法直接播放然后退出
                guard let handler = progressHandler else {
                    self.playSoundEffect(NSURL(fileURLWithPath: filePath))
                    return
                }
                
                //缓存过且需要监控进度，播放然后退出
                self.playCachedRemoteSoundWithURL(url, filePath: filePath, progressHandler: handler)
            }
            
        }
    }
    
    /**
     私有方法，播放已经缓存过的音频的方法。
     
     - parameter url:             远程音频URL
     - parameter filePath:        缓存过后，保存文件的路径
     - parameter progressHandler: 处理当前播放进度
     */
    private func playCachedRemoteSoundWithURL(url: NSURL, filePath: String, progressHandler: ProgressHandler) {
        //由于我们缓存过后保存的文件为 NSData ，而 AVPlayerItem 不支持使用 NSData 初始化
        //直接传递 filePath 生成的 NSURL 给 AVPlayerItem 并没有效果，可能是因为文件类型不对，我们下载的音频文件为 MP3
        //所以我们先使用 NSData 读出数据，然后再写入文件，最后将文件的 NSURL 初始化 AVPlayerItem
        
        //文件数据
        let data = NSData(contentsOfFile: filePath)
        //文件名称，加上了MP3的后缀，这里比较局限
        let fileName = url.absoluteString.md5 + ".mp3"
        //写入文件的路径
        let destinationPath = (IWCache.sharedInstance.iwCachePath as NSString).stringByAppendingPathComponent(fileName)
        //将 文件数据data 写入目标路径
        FileUtils.createFileAt(destinationPath, fileContent: data, attributes: nil)
        
        //根据写入文件路径生成 NSURL
        let fileURL = NSURL(fileURLWithPath: destinationPath)
        
        let playerItem = AVPlayerItem(URL: fileURL)
        remotePlayer = AVPlayer(playerItem: playerItem)
        remotePlayer.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 10), queue: dispatch_get_main_queue(), usingBlock: { time in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(playerItem.duration)
            let progress = CGFloat(current / total)
            if !isnan(progress) {
                progressHandler(progress)
            }
        })
        remotePlayer.play()
    }
    
}

// MARK: - AVAudioPlayerDelegate，播放结束、错误、打断后执行完成时的闭包，completeClosure

extension AudioPlayer: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        completeHandler()
    }
    
    public func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        completeHandler()
    }
    
    public func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        completeHandler()
    }
    
}
