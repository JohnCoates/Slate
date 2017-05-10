//
//  ControlsMenuBar.swift
//  Slate
//
//  Created by John Coates on 4/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class ControlsMenuBar: UIView, UICollectionViewDataSource {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(ControlBarItemCell.self,
                      forCellWithReuseIdentifier: ControlBarItemCell.reuseIdentifier)
        view.isScrollEnabled = true
        view.alwaysBounceHorizontal = true
        view.dataSource = self
        view.clipsToBounds = false
//        view.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        return view
    }()
    
    private func initialSetup() {
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
        bringSubview(toFront: collectionView)
        
    }
    
    // MARK: - Controls
    
    var controls: [UIView] = {
        return [
            FrontBackCameraToggle()
        ]
    }()
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ControlBarItemCell.reuseIdentifier,
                                                  for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controls.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}
