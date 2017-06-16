//
//  Views+AutoLayout.swift
//  Flexapp
//
//  Created by John Coates on 5/16/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

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
    
    func constraintsBetween(view: UIView, view2: UIView,
                            viewAttribute: NSLayoutAttribute) -> [NSLayoutConstraint]? {
        
        let allConstraints = self.constraints
        var constraints = [NSLayoutConstraint]()
        
        for constraint in allConstraints {
            guard let firstItem = constraint.firstItem as? UIView,
                  let secondItem = constraint.secondItem as? UIView else {
                    continue
            }
            
            if firstItem != view, firstItem != view2 {
                continue
            }
            if secondItem != view, secondItem != view2 {
                continue
            }
            
            if firstItem == view, constraint.firstAttribute == viewAttribute {
                constraints.append(constraint)
            } else if secondItem == view, constraint.secondAttribute == viewAttribute {
                constraints.append(constraint)
            }
        }
        
        if let superview = superview,
           let rest = superview.constraintsBetween(view: view,
                                                   view2: view2,
                                                   viewAttribute: viewAttribute) {
            constraints += rest
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
        
        if let superview = superview {
            if let rest = superview.constraintsInvolvingView(view, attribute: attribute) {
                constraints += rest
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
    
    func constraintsWithAttribute(_ attribute: NSLayoutAttribute) -> [NSLayoutConstraint]? {
        let allConstraints = self.constraints
        let constraints = allConstraints.filter { $0.firstAttribute == attribute || $0.secondAttribute == attribute }
        
        if constraints.count > 0 {
            return constraints
        } else {
            if let superview = superview {
                return superview.constraintsInvolvingView(self, attribute: attribute)
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
    
    func setHugging(priority: Priority, axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(priority.rawValue, for: axis)
    }
    
    func setCompressionResistant(priority: Priority, axis: UILayoutConstraintAxis) {
        setContentCompressionResistancePriority(priority.rawValue,
                                                for: axis)
    }
    
}

// MARK: - Table View

extension UITableView {
    
    // Set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAutoLayout(tableHeaderView view: UIView) {
        self.tableHeaderView = view
        forceLayout(forView: view)
        self.tableHeaderView = view
    }
    
    func setAutoLayout(tableFooterView view: UIView) {
        self.tableFooterView = view
        forceLayout(forView: view)
        self.tableFooterView = view
    }
    
    private func forceLayout(forView view: UIView) {
        view.left --> self.left
        view.right --> self.right
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = view.frame
        frame.size.height = height
        view.frame = frame
    }
    
}
