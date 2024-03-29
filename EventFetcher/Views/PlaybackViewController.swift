//
//  PlaybackViewController.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import AVKit


// Can be done simpler by AVPlayerViewController, but in simulator view is black until user moves it a little bit, so I've created a custom video handler as an example
// TODO: Landscape Viewimport AVFoundation

class PlaybackViewController: UIViewController {
    
    var viewModel: PlaybackViewModel!
    var playerView = UIView()
    var playPauseButton: UIButton!
    var activityIndicator: UIActivityIndicatorView?
    let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  viewModel.player = nil
        setupViews()
        setupConstrains()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let playerLayer = AVPlayerLayer(player: viewModel.player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)

        if let gradientButtonLayer = playPauseButton.layer.sublayers?.first as? CAGradientLayer {
            gradientButtonLayer.frame = playPauseButton.bounds
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.player?.play()
        let newButtonWidth: CGFloat = 60
        UIView.animate(withDuration: 1.2,
                       delay: 1.5,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: ({
            self.playPauseButton.isHidden = false
            self.playPauseButton.frame = CGRect(x: 0, y: 0, width: newButtonWidth, height: newButtonWidth)
            self.playPauseButton.center = self.view.center
        }), completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidStartPlaying), name: .AVPlayerItemDidPlayToEndTime, object: viewModel.player?.currentItem)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let playerLayer = AVPlayerLayer(player: viewModel.player)
        playerLayer.frame = CGRect(origin: CGPoint.zero, size: size)
        playerView.layer.addSublayer(playerLayer)
    }
    
    deinit {
        viewModel.player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
    }

    
    func setupViews() {
        let gradientView = UIView(frame: view.bounds)
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.gray.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.3, 0.7, 1.0]
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        viewModel.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)

        
        view.addSubview(activityIndicator ?? UIView())
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playPauseButton = UIButton(type: .system)
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        playPauseButton.isHidden = true
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playPauseButton)
        
        let gradientButtonLayer = CAGradientLayer()
        gradientButtonLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.0).cgColor]
        gradientButtonLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // top center
        gradientButtonLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // bottom center
        gradientButtonLayer.cornerRadius = playPauseButton.frame.size.width / 2

        playPauseButton.layer.insertSublayer(gradientButtonLayer, at: 0)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
    }
    
    func setupConstrains() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalTo: playPauseButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            playerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            playPauseButton.widthAnchor.constraint(equalToConstant: 30),
            playPauseButton.heightAnchor.constraint(equalTo: playPauseButton.widthAnchor)
        ])
    }
    
    @objc func playPauseButtonTapped() {
        viewModel.playPause()
        if viewModel.player?.rate == 0 {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc func playerDidStartPlaying() {
        activityIndicator?.stopAnimating()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "playbackBufferEmpty" {
            if let isBuffering = viewModel.player?.currentItem?.isPlaybackBufferEmpty, isBuffering {
                activityIndicator?.startAnimating()
            } else {
                activityIndicator?.stopAnimating()
            }
        }
    }
}
