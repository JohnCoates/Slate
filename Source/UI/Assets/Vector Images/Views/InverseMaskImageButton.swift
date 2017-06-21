//
//  InverseMaskImageButton.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity function_body_length

import UIKit

class InverseMaskButtonImage: Button {
    
    // MARK: - Init
    
    var canvas: Canvas
    var paths: [CGPath]
    
    convenience init(asset: ImageAsset) {
        self.init(canvas: Canvas.from(asset: asset))
    }
    
    init(canvas: Canvas) {
        self.canvas = canvas
        self.paths = canvas.cgPaths()
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        rounding = 0.3
        contentView.backgroundColor = UIColor(red: 0.93, green: 0.93,
                                              blue: 0.93, alpha: 0.59)
        setUpIconProxy()
        setUpShape()
    }
    
    let shape = CAShapeLayer()
    
    func setUpShape() {
        shape.fillRule = kCAFillRuleEvenOdd
        layer.mask = shape
    }
    
    // MARK: - Masking
    
    func updateMask(withFrame frame: CGRect, inverse: Bool = true) {
        let maskPath = CGMutablePath()
        
        if inverse {
            maskPath.addRect(self.bounds)
        }
        for path in paths {
            let transformedPath = self.transformed(path: path, forFrame: frame)
            maskPath.addPath(transformedPath)
        }
        shape.path = maskPath
    }
    
    // ratio of width to superview
    var iconWidthRatio: CGFloat? {
        didSet {
            if let widthRatio = iconWidthRatio,
                let widthConstraint = iconProxy.constraintWithAttribute(.width) {
                NSLayoutConstraint.deactivate([widthConstraint])
                iconProxy.width.pin(to: contentView.width, times: widthRatio)
            }
        }
    }
    
    let iconProxy = UIView(frame: .zero)
    
    func setUpIconProxy() {
        iconProxy.isHidden = true
        contentView.addSubview(iconProxy)
        
        let heightRatio = CGFloat(canvas.height) / CGFloat(canvas.width)
        iconProxy.centerXY --> contentView.centerXY
        if let widthRatio = self.iconWidthRatio {
            iconProxy.width.pin(to: contentView.width, times: widthRatio)
        } else {
            iconProxy.width --> 19
        }
        iconProxy.height.pin(to: iconProxy.width, times: heightRatio)
    }
    
    // MARK: - Icon
    
    func transformed(path: CGPath, forFrame frame: CGRect) -> CGPath {
        let scale = frame.size.width / CGFloat(canvas.width)
        let translationFactor = CGFloat(canvas.width) / frame.size.width
        
        var affineTransform = CGAffineTransform.init(scaleX: scale, y: scale)
        affineTransform = affineTransform.translatedBy(x: frame.origin.x * translationFactor,
                                                       y: frame.origin.y * translationFactor)
        
        guard let transformedPath = path.copy(using: &affineTransform) else {
            fatalError("Couldn't make path mutable!")
        }
        return transformedPath
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        handlePathLayout(forFrame: iconProxy.frame)
    }
    
    func handlePathLayout(forFrame frame: CGRect) {
        updateMask(withFrame: frame)
    }
    
}

extension Canvas {
    
    func cgPaths() -> [CGPath] {
        return paths.map { $0.cgPath() }
    }
    
}

extension Path {
    
    func cgPath() -> CGPath {
        var instructions = self.instructions
        let first = instructions.removeFirst()
        
        let path: UIBezierPath
        switch first {
        case .initWith(let rect):
            path = UIBezierPath(rect: rect.cgRect)
        case .initWith2(let rect, let cornerRadius):
            path = UIBezierPath(roundedRect: rect.cgRect, cornerRadius: CGFloat(cornerRadius))
        case .initWith3(let ovalIn):
            path = UIBezierPath(ovalIn: ovalIn.cgRect)
        default:
            path = UIBezierPath()
            instructions.insert(first, at: 0)
        }
        
        for instruction in instructions {
            switch instruction {
            case .move(let to):
                path.move(to: to.cgPoint)
            case .addLine(let to):
                path.addLine(to: to.cgPoint)
            case .addCurve(let to, let control1, let control2):
                path.addCurve(to: to.cgPoint,
                              controlPoint1: control1.cgPoint,
                              controlPoint2: control2.cgPoint)
            case .close:
                path.close()
            case .fill(let color):
                let uiColor: UIColor = color.uiColor
                uiColor.setFill()
                path.fill()
            case .stroke(color: let color):
                let uiColor: UIColor = color.uiColor
                uiColor.setStroke()
                path.stroke()
            case .setLineWidth(let to):
                path.lineWidth = CGFloat(to)
            case .setLineCapStyle(let to):
                path.lineCapStyle = to.cgLineCap
            case .usesEvenOddFillRule:
                path.usesEvenOddFillRule = true
            case .initWith(_), .initWith2(_), .initWith3(_):
                fatalError("Unexpected double init")
            // Graphics Context
            case .contextSaveGState, .contextRestoreGState,
                 .contextTranslateBy(_), .contextRotate(_):
                fatalError("Context commands can't be processed into a cgPath")
            }
        }
        
        return path.cgPath
    }
    
}
