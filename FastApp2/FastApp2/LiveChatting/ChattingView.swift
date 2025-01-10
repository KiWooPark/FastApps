//
//  ChattingView.swift
//  FastAPP2
//
//  Created by PKW on 1/10/25.
//

import UIKit

protocol ChattingViewDeleagte: AnyObject {
    // 채팅 뷰 닫기
    func liveChattingViewCloseTapped(_ chattingView: ChattingView)
}

class ChattingView: UIView {
    @IBOutlet weak var chattingCollectionView: UICollectionView!
    @IBOutlet weak var chattingTextField: UITextField!
    weak var delegate: ChattingViewDeleagte?
    
    private let viewModel: ChattingViewModel = .init()
    
    // 채팅뷰가 디바이스에 보이는 경우에만 업데이트 처리하기
    override var isHidden: Bool {
        didSet {
            self.toggleViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupChattingCollectionView()
        self.setupChattingTextField()
        self.toggleViewModel()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.chatReceived = { [weak self] in
            self?.chattingCollectionView.reloadData()
            self?.scrollToLatestIfNeeded()
        }
    }
    
    // 채팅 뷰모델을 뷰 상태에 따라 업데이트
    private func toggleViewModel() {
        if self.isHidden {
            self.viewModel.stop()
        } else {
            self.viewModel.start()
        }
    }
    
    // 최신 메시지 업데이트
    private func scrollToLatestIfNeeded() {
        let isBottomOffset = self.chattingCollectionView.bounds.maxY >= self.chattingCollectionView.contentSize.height - 200
        let isLastMessageMine = self.viewModel.messages.last?.isMine == true
        
        if isBottomOffset || isLastMessageMine {
            self.chattingCollectionView.scrollToItem(
                at: IndexPath(item: self.viewModel.messages.count - 1, section: 0),
                at: .bottom,
                animated: true
            )
        }
    }
    
    // 컬렉션 뷰 설정
    private func setupChattingCollectionView() {
        self.chattingCollectionView.dataSource = self
        self.chattingCollectionView.delegate = self
        self.chattingCollectionView.register(
            UINib(nibName: LiveChattingMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier
        )
        
        self.chattingCollectionView.register(
            UINib(nibName: LiveChattingMyMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier
        )
    }
    
    // 텍스트 필드 설정
    private func setupChattingTextField() {
        self.chattingTextField.delegate = self
        self.chattingTextField.attributedPlaceholder = NSAttributedString(
            string: "채팅에 참여하세요!",
            attributes: [.foregroundColor: UIColor(named: "chat-text") ?? .clear,
                         .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
        )
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.delegate?.liveChattingViewCloseTapped(self)
    }
}

extension ChattingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.viewModel.messages[indexPath.item]
        
        // 양 쪽 여백 16
        let width = collectionView.frame.width - 32
        
        if item.isMine {
            return LiveChattingMyMessageCollectionViewCell.size(width: width, text: item.text)
        } else {
            return LiveChattingMessageCollectionViewCell.size(width: width, text: item.text)
        }
    }
    
    // 여백 처리
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ChattingView: UICollectionViewDelegate {}

extension ChattingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.viewModel.messages[indexPath.item]
        
        // 내 메시지인지 분기처리
        if item.isMine {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? LiveChattingMyMessageCollectionViewCell {
                cell.setText(item.text)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier,
                for: indexPath
            )
            
            if let cell = cell as? LiveChattingMessageCollectionViewCell {
                cell.setText(item.text)
            }
            
            return cell
        }
    }
}

extension ChattingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        self.viewModel.sendMessage(text)
        textField.text = nil
        
        return true
    }
}
