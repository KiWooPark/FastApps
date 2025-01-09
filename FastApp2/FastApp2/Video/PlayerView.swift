//
//  PlayerView.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import AVFoundation
import UIKit

protocol PlayerViewDeleagte: AnyObject {
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double)
    func playerViewReadyToPlay(_ playerView: PlayerView)
    func playerViewDidFinishToPlay(_ playerView: PlayerView)
}

class PlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var avPlayerLayer: AVPlayerLayer? {
        return self.layer as? AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            self.avPlayerLayer?.player
            
        }
        set {
            if let oldPlayer = self.avPlayerLayer?.player {
                self.unsetPlayer(player: oldPlayer)
            }
            
            self.avPlayerLayer?.player = newValue
            
            if let player = newValue {
                self.setup(player: player)
            }
        }
    }

    // 재생중인지 확인 변수
    var isPlaying: Bool {
        guard let player else {
            return false
        }

        // 일시정지가 아닐때
        return player.rate != 0
    }

    // 총 플레이 시간
    var totalPlayTime: Double {
        return self.player?.currentItem?.duration.seconds ?? 0
    }

    private var playObservation: Any?
    private var statusObservation: NSKeyValueObservation?
    weak var delegatet: PlayerViewDeleagte?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupNotification()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupNotification()
    }

    func setVideo(url: URL) {
        self.player = AVPlayer(
            playerItem: AVPlayerItem(
                asset: AVURLAsset(url: url)
            )
        )
    }

    func play() {
        self.player?.play()
    }

    func pause() {
        self.player?.pause()
    }

    func seek(to percent: Double) {
        self.player?.seek(
            to: CMTime(
                seconds: percent * self.totalPlayTime,
                preferredTimescale: 1
            )
        )
    }

    func forward(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }

        self.player?.seek(
            to: CMTime(
                seconds: currentTime + seconds,
                preferredTimescale: 1
            )
        )
    }

    func rewind(to seconds: Double = 10) {
        guard let currentTime = self.player?.currentItem?.currentTime().seconds else { return }

        self.player?.seek(
            to: CMTime(
                seconds: currentTime - seconds,
                preferredTimescale: 1
            )
        )
    }
}

extension PlayerView {
    func setup(player: AVPlayer) {
        // 재생된 시간 실시간 체크
        self.playObservation = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 10), // 0.5초마다 옵저빙
            queue: .main
        ) { [weak self, weak player] time in
            guard let self else { return }

            // 현재 재생 시간
            guard
                let currentTime = player?.currentItem,
                currentTime.status == .readyToPlay,
                let timeRange = (currentTime.loadedTimeRanges as? [CMTimeRange])?.first // 현재 재생 가능한 시간(남은시간?)
            else {
                return
            }

            let playableTime = timeRange.start.seconds + timeRange.duration.seconds
            let playTime = time.seconds

            self.delegatet?.playerView(self, didPlay: playTime, playableTime: playableTime)
        }

        self.statusObservation = player.currentItem?.observe(
            \.status,
            changeHandler: { [weak self] item, _ in
                guard let self else { return }

                switch item.status {
                case .readyToPlay:
                    self.delegatet?.playerViewReadyToPlay(self)
                case .failed, .unknown:
                    print("failed to play \(item.error?.localizedDescription ?? "")")
                @unknown default:
                    print("failed to play \(item.error?.localizedDescription ?? "")")
                }
            }
        )
    }
    
    private func unsetPlayer(player: AVPlayer) {
        self.statusObservation?.invalidate()
        self.statusObservation = nil
        if let playObservation {
            player.removeTimeObserver(playObservation)
        }
    }
    
    // 동영상이 종료되었을때 알려줄 노티피케이션
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didPlayToEnd(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    @objc
    private func didPlayToEnd(_ notification: Notification) {
        self.delegatet?.playerViewDidFinishToPlay(self)
    }
}
