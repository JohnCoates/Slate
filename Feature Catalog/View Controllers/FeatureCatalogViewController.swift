//
//  FeatureCatalogViewController.swift
//
//  Created by John Coates on 5/5/16.
//

import UIKit

class FeatureCatalogViewController: UITableViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Init
    
    init() {
        super.init(style: .grouped)
        title = "Features Catalog"
    }
    
    required init?(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - Setup
    
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    var hasAppeared = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
        
        guard !hasAppeared else {
            return
        }
        
        hasAppeared = true

        loadSavedSelection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Navigation Controller Delegate
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        guard let item = shownItem else {
            return
        }
        
        guard self !== viewController else {
            return
        }
        
        if item.hideNavigation {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        guard self === viewController else {
            // Enable Swipe back
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            return
        }
        
        if navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        saveSelection(item: item)
        execute(item: item)
    }
    
    // MARK: - Save/Load Selection
    
    func loadSavedSelection() {
        if let item = savedSelection() {
            execute(item: item)
        }
    }
    
    func saveSelection(item: FeatureCatalogItem) {
        UserDefaults.standard.set(item.identifier, forKey: "feature")
    }
    
    func savedSelection() -> FeatureCatalogItem? {
        guard let feature = UserDefaults.standard.string(forKey: "feature") else {
            return nil
        }
        
        for section in sections {
            for item in section.items where item.identifier == feature {
                return item
            }
        }
        
        return nil
    }
    
    // MARK: - Execute Item
    
    var shownItem: FeatureCatalogItem?
    
    func execute(item: FeatureCatalogItem) {
        shownItem = item
        
        if let viewController = item.creationBlock?() {
            navigationController?.pushViewController(viewController, animated: true)
        } else if let action = item.actionBlock {
            action()
        }
    }
    
    // MARK: - Items
    
    lazy var sections: [Section] = {
        return [
            self.captureScreen(),
            self.kitsTab(),
            self.database(),
            self.vectors(),
            self.buttons()
        ]
    }()
    
    struct Section {
        let title: String
        let items: [FeatureCatalogItem]
        
        init(title: String, items: [FeatureCatalogItem]) {
            for item in items {
                item.section = title
            }
            self.title = title
            self.items = items
        }
    }
    
    func captureScreen() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Capture Screen",
                               creationBlock: {CaptureViewController()}),
            FeatureCatalogItem(name: "Edit Bar",
                               creationBlock: {
                                let vc = CaptureViewController()
                                // trigger view load
                                _ = vc.view
                                vc.editBar.isHidden = false
                                return vc
            }),
            FeatureCatalogItem(name: "Camera Permission",
                               actionBlock: { PermissionsWindow.show(kind: .camera,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Camera Denied Permission",
                               actionBlock: { PermissionsWindow.show(kind: .cameraDenied,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Photos Permission",
                               actionBlock: { PermissionsWindow.show(kind: .photos,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Photos Denied Permission",
                               actionBlock: { PermissionsWindow.show(kind: .photosDenied,
                                                                     animated: true)
            }),
            FeatureCatalogItem(name: "Permissions Button Indicator",
                               creationBlock: {
                                let frame = CGRect(x: 160.5, y: 321.5, width: 134.5, height: 44)
                                return PermissionsButtonIndicatorViewController(buttonFrame: frame)
            }),
            FeatureCatalogItem(name: "AV Preview", creationBlock: { AVPreviewCaptureViewController() }),
            FeatureCatalogItem(name: "Scaled", hideNavigation: true,
                               creationBlock: { LayoutPreviewCaptureViewController(kit: Kit.default()) })
            ]
        
        return Section(title: "Capture Screen", items: items)
    }
    
    func kitsTab() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Kits",
                               creationBlock: { KitsViewController() }),
            FeatureCatalogItem(name: "Edit Kit",
                               creationBlock: { EditKitViewController(kit: Kit()) }),
            FeatureCatalogItem(name: "Edit Layout",
                               creationBlock: { EditKitLayoutViewController(kit: Kit.default()) }),
            FeatureCatalogItem(name: "Photo Settings",
                               creationBlock: { KitPhotoSettingsViewController(kit: Kit.default()) })
            
        ]
        
        return Section(title: "Kits Tab", items: items)
    }
    
    func database() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Components",
                               creationBlock: { ComponentListingsViewController() }),
            FeatureCatalogItem(name: "Kits",
                               creationBlock: { KitListingsViewController() })
        ]
        
        return Section(title: "Database", items: items)
    }
    
    func buttons() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Inverted Mask Button",
                               creationBlock: { InvertedMaskButtonViewController(kind: .checkmark) }),
            FeatureCatalogItem(name: "Flip Camera Button",
                               creationBlock: { InvertedMaskButtonViewController(kind: .flipCamera) }),
            FeatureCatalogItem(name: "Button Indicator",
                               creationBlock: { InvertedMaskButtonViewController(kind: .buttonIndicator) })
        ]
        
        return Section(title: "Buttons", items: items)
    }
    
    func vectors() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Assets",
                               creationBlock: { VectorImagesTableViewController() })
            ]
        
        return Section(title: "Vector Images", items: items)
    }
    
    // MARK: - Navigation Swipe Back
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
