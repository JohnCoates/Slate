//
//  ResolutionSettingViewController.swift
//  Slate
//
//  Created by John Coates on 10/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

struct TableRow {
    var title: String
    
    var accessory: Accessory = .none
    
    enum Accessory {
        case none
        case checkmark
    }
}

struct Section {
//    var rows
}

protocol TableDataSource {
    
}

private protocol CellProtocol: class {
    var title: String { get set }
    var showCheckmark: Bool { get set }
    var showDisclosure: Bool { get set }
    var cellView: UITableViewCell { get }
}

extension CellProtocol where Self: UITableViewCell {
    var cellView: UITableViewCell {
        return self
    }
}

extension EditKitSettingCell: CellProtocol { }
extension EditKitInputCell: CellProtocol { }

extension CellProtocol {
    var showCheckmark: Bool {
        get {
            return false
        }
        set {
            
        }
    }
}

class ResolutionSettingViewController: SettingsTableViewController, UITextFieldDelegate, TextFieldHandler {
    
    fileprivate struct Row {
        var title: String
        var style: Style
        var selected: Bool = false
        var intValue: Int = 0
        var rawKind: Int = 0
        
        init(title: String, style: Style, resolution: PhotoResolution) {
            self.title = title
            self.style = style
            self.rawKind = resolution.kind
        }
        
        init(title: String, style: Style,
             dimension: Dimension, value: Int) {
            self.title = title
            self.style = style
            self.intValue = value
            self.rawKind = dimension.rawValue
        }
    }
    
    private enum Section {
        case resolution
        case custom
        
        var name: String {
            switch self {
            case .resolution:
                return "Resolution"
            case .custom:
                return "Custom"
            }
        }
    }
    
    // MARK: - Settings Generators
    
    private func rows(forSection section: Section) -> [Row] {
        let settings = kit.photoSettings
        
        switch section {
        case .resolution:
            
            var notSet = Row(title: "Default", style: .radioSelectable, resolution: .notSet )
            var maximium = Row(title: "Maximum", style: .radioSelectable, resolution: .maximum)
            var custom = Row(title: "Custom", style: .radioSelectable, resolution: .custom(width: 1280, height: 720))
            
            switch settings.resolution {
            case .notSet:
                notSet.selected = true
            case .maximum:
                maximium.selected = true
            case .custom:
                custom.selected = true
            }
                
            return [notSet, maximium, custom]
        case .custom:
            guard case let .custom(width, height) = settings.resolution else {
                return []
            }
            
            return [
                Row(title: "Width", style: .numericInput,
                    dimension: .width, value: Int(width)),
                Row(title: "Height", style: .numericInput,
                    dimension: .height, value: Int(height))
            ]
        }
    }
    
    private var cachedRows = [Int: [Row]]()
    private func rows(forSectionIndex sectionIndex: Int) -> [Row] {
        if let cached = cachedRows[sectionIndex] {
            return cached
        }
        
        let section = sections[sectionIndex]
        let rows = self.rows(forSection: section)
        cachedRows[sectionIndex] = rows
        return rows
    }
    
    private func clearRowCaches() {
        cachedRows.removeAll(keepingCapacity: true)
    }
    
    private var sections: [Section] {
        switch kit.photoSettings.resolution {
        case .custom:
            return [.resolution, .custom]
        default:
            return [.resolution]
            
        }
    }
    
    // MARK: - Init
    
    let kit: Kit
    
    init(kit: Kit) {
        self.kit = kit
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resolution"
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16,
                                                bottom: 0, right: 0)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16,
                                               bottom: 0, right: 16)
        tableView.separatorColor = Theme.Kits.separatorColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: .saveTapped)
    }
    
    // MARK: - Table View Setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.registerCell(type: EditKitSettingCell.self)
        tableView.registerCell(type: EditKitInputCell.self)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return rows(forSection: sections[section]).count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.name
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = rows(forSection: section)[indexPath.row]
        
        return cell(forTableView: tableView,
                    section: section, row: row, indexPath: indexPath)
    }
    
    private func cell(forTableView: UITableView,
                      section: Section, row: Row,
                      indexPath: IndexPath) -> UITableViewCell {
        let cell: CellProtocol
        
        switch section {
        case .resolution:
            cell = tableView.dequeueReusableCell(for: indexPath) as EditKitSettingCell
        case .custom:
            let inputCell: EditKitInputCell = tableView.dequeueReusableCell(for: indexPath)
            cell = inputCell
            var nextKey = false
            switch row.rawKind {
            case Row.Dimension.width.rawValue:
                nextKey = true
                inputCell.value = "\(Int(customSize.width))"
            default:
                inputCell.value = "\(Int(customSize.height))"
            }
            inputCell.textField.indexPath = indexPath
            inputCell.textField.tableView = tableView
            
            configure(cellInput: inputCell.textField, nextKey: nextKey)
        }
        
        cell.title = row.title
        cell.showCheckmark = row.selected
        cell.showDisclosure = false
        return cell.cellView
    }
    
    private func configure(cellInput input: UITextField, nextKey: Bool) {
        input.keyboardType = .numbersAndPunctuation
        input.keyboardAppearance = .dark
        input.autocorrectionType = .no
        
        input.returnKeyType = nextKey ? .next : .done
        
        input.delegate = self
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    lazy var customSize: CGSize = {
        if case let .custom(width, height) = self.kit.photoSettings.resolution {
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: 1280, height: 720)
    }()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .resolution:
            let row = rows(forSectionIndex: indexPath.section)[indexPath.row]
            let resolution = PhotoResolution(kind: row.rawKind, size: customSize)
            select(resolution: resolution)
        case .custom:
            break
        }
    }
    
    private func select(resolution: PhotoResolution) {
        kit.photoSettings.resolution = resolution
        clearRowCaches()
        tableView.reloadData()
    }
    
    // MARK: - User Interaction
    
    @objc func saveTapped() {
        print("save tapped")
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Text Field Handler
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cellTextField = textField as? TableCellTextField {
            return handleReturn(forTextField: cellTextField)
        }
        
        return false
    }
}

// MARK: - Row Extension

extension ResolutionSettingViewController.Row {
    enum Style {
        case radioSelectable
        case numericInput
    }
    
    enum Dimension: Int {
        case width
        case height
    }
}

// MARK: - Selector Extension

private typealias LocalClass = ResolutionSettingViewController

fileprivate extension Selector {
    static let saveTapped = #selector(LocalClass.saveTapped)
}
