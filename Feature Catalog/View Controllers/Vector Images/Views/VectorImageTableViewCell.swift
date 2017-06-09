//
//  VectorImageTableViewCell.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class VectorImageTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    var canvas: Canvas? {
        didSet {
            reset()
            if let canvas = canvas {
                setUp(withCanvas: canvas)
            }
        }
    }
    
    func reset() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func setUp(withCanvas canvas: Canvas) {
        let image = VectorImageCanvasIcon(canvas: canvas)
        let icon = CanvasIconView(icon: image)
        icon.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        
        contentView.addSubview(icon)
        
        icon.edges --> contentView.edges
    }
    
    private func initialSetup() {
        contentView.height --> 100
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }

}
