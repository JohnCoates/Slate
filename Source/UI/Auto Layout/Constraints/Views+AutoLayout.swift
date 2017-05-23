//
//  Views+AutoLayout.swift
//  Flexapp
//
//  Created by John Coates on 5/16/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

// Placed outside of extension because placing it inside is
// causing syntax highlighting crashes
enum FixedLayoutPriority {
    case ultraLow
    case low
    case high
    case ultraHigh
    case required
    
    fileprivate var rawValue: UILayoutPriority {
            switch self {
            case .ultraLow:
                return UILayoutPriorityDefaultLow - 1
            case .low:
                return UILayoutPriorityDefaultLow
            case .high:
                return UILayoutPriorityDefaultHigh
            case .ultraHigh:
                return UILayoutPriorityDefaultHigh + 1
            case .required:
                return UILayoutPriorityRequired
            }
    }
}

extension UIView {
    
    // MARK: - Constraints
    
    func constraintsInvolvingView(_ view: UIView) -> [NSLayoutConstraint]? {
        
        let allConstraints = self.constraints
        var constraints = [NSLayoutConstraint]()
            
        for constraint in allConstraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                constraints.append(constraint)
            } else if let secondItem = constraint.secondItem as? UIView, secondItem == view {
                constraints.append(constraint)
            }
        }
        
        if constraints.count == 0 {
            return nil
        }
        
        return constraints
    }
    
    func constraintsInvolvingView(_ view: UIView,
                                  attribute: NSLayoutAttribute) -> [NSLayoutConstraint]? {
        
        let allConstraints = self.constraints
        var constraints = [NSLayoutConstraint]()
        
        for constraint in allConstraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                if constraint.firstAttribute == attribute {
                    constraints.append(constraint)
                }
            } else if let secondItem = constraint.secondItem as? UIView, secondItem == view {
                if constraint.secondAttribute == attribute {
                    constraints.append(constraint)
                }
            }
        }
        
        if constraints.count == 0 {
            return nil
        }
        
        return constraints
    }
    
    func constraintInvolvingView(_ view: UIView,
                                 attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let allConstraints = self.constraints
        
        for constraint in allConstraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                if constraint.firstAttribute == attribute {
                    return constraint
                }
            } else if let secondItem = constraint.secondItem as? UIView, secondItem == view {
                if constraint.secondAttribute == attribute {
                    return constraint
                }
            }
        }
        
        return nil
    }
    
    func constraintInvolvingView(_ view: UIView,
                                 attribute: NSLayoutAttribute,
                                 relation: NSLayoutRelation) -> NSLayoutConstraint? {
        let allConstraints = self.constraints
        
        for constraint in allConstraints {
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                if constraint.firstAttribute == attribute &&
                    constraint.relation == relation {
                    return constraint
                }
            } else if let secondItem = constraint.secondItem as? UIView, secondItem == view {
                if constraint.secondAttribute == attribute &&
                    constraint.relation == relation {
                    return constraint
                }
            }
        }
        
        return nil
    }
    
    func constraintWithAttribute(_ attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let allConstraints = self.constraints
        let index = allConstraints.index { $0.firstAttribute == attribute || $0.secondAttribute == attribute }
        
        if let index = index {
            return allConstraints[index]
        } else {
            if let superview = superview {
                return superview.constraintInvolvingView(self, attribute: attribute)
            } else {
                return nil
            }
        }
    }
    
    func constraintWithAttribute(_ attribute: NSLayoutAttribute,
                                 relation: NSLayoutRelation) -> NSLayoutConstraint? {
        let allConstraints = self.constraints
        let index = allConstraints.index {
            ($0.firstAttribute == attribute || $0.secondAttribute == attribute) &&
                $0.relation == relation
        }
        
        if let index = index {
            return allConstraints[index]
        } else {
            return nil
            
        }
    }
    
    // MARK: - Content Hugging
    
    func setHugging(priority: FixedLayoutPriority, axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(priority.rawValue, for: axis)
    }
    
    func setCompressionResistant(priority: FixedLayoutPriority, axis: UILayoutConstraintAxis) {
        setContentCompressionResistancePriority(priority.rawValue,
                                                for: axis)
    }
    
}

// MARK: - Table View

extension UITableView {
    // Set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAutoLayout(tableHeaderView header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
    }
    
    func setAutoLayout(tableFooterView view: UIView) {
        self.tableFooterView = view
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = view.frame
        frame.size.height = height
        frame.origin = CGPoint.zero
        view.frame = frame
        self.tableFooterView = view
    }
}
