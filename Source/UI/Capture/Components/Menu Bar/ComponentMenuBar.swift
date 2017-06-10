//
//  ControlsMenuBar.swift
//  Slate
//
//  Created by John Coates on 4/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class ComponentMenuBar: UIView,
    UICollectionViewDataSource, ComponentItemCellDelegate {
    
    weak var delegate: ComponentMenuBarDelegate?
    
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
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceHorizontal = true
        view.dataSource = self
        view.clipsToBounds = false
        view.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 0)
//        view.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.05)
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
    
    var components: [Component.Type] = {
        return [
            CaptureComponent.self,
            CameraPositionComponent.self
        ]
    }()
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControlBarItemCell.reuseIdentifier,
                                                  for: indexPath)
        
        let component = components[indexPath.row]
        if let itemCell = cell as? ControlBarItemCell {
            itemCell.collectionView = collectionView
            itemCell.control = component.createView()
            itemCell.delegate = self
            itemCell.component = component
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return components.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Component Item Cell Delegate
    
    func add(component: Component.Type, atFrame frame: CGRect, fromView view: UIView) {
        self.delegate?.add(component: component, atFrame: frame, fromView: view)
    }
    
}
