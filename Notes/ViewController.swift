//
//  ViewController.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var backgroundLabel : UILabel = UILabel()
    var notes: Results<Note>!
    var notificationToken: NotificationToken?
    let searchController = UISearchController(searchResultsController: nil)
    var isSorted: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupBackgroundView()
        setupRealm()
        setupNavigation()
        setupSearchController()
    }
    
    func setupBackgroundView() {
        backgroundLabel.text = "You haven't added any notes yet.\n Tap the + button to add a new notes."
        backgroundLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundLabel.numberOfLines = 0
        backgroundLabel.textAlignment = NSTextAlignment.center
        backgroundLabel.sizeToFit()
        backgroundLabel.isHidden = false
        
        self.tableView.backgroundView = backgroundLabel
    }
    
    func setupRealm() {
        let realm = RealmService.shared.realm
        notes = realm.objects(Note.self)
        notificationToken = realm.observe { (notification, realm) in
            
            if RealmService.shared.isEdit {
                self.tableView.reloadData()
            }
        }
        
    }

    func setupNavigation() {
        navigationItem.title = "Заметки"
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddView))
        let iconImage = UIImage(named: "SortIcon")
        let sortItem = UIBarButtonItem(image: iconImage, landscapeImagePhone: iconImage, style: .plain, target: self, action: #selector(sortNotes))
        navigationItem.rightBarButtonItems = [addItem, sortItem]
    }
    
    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    @objc func openAddView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        vc.configuration(with: .add)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sortNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "От старых к новым", style: .default){ [weak self] _ in
            self?.isSorted = true
            self?.reloadData()
        })
        alert.addAction(UIAlertAction(title: "От новых к старым", style: .default){ [weak self] _ in
            self?.isSorted = false
            self?.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func reloadData() {
        let realm = RealmService.shared.realm
        notes = realm.objects(Note.self).sorted(byKeyPath: "date", ascending: isSorted)
        tableView.reloadData()
    }
    
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.isEmpty {
            backgroundLabel.isHidden = false
            self.tableView.separatorStyle = .none
            return 0
        }
        
        backgroundLabel.isHidden = true
        self.tableView.separatorStyle = .singleLine
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let simpleMark = notes[indexPath.row]
        cell.configure(with: simpleMark)
        return cell
    }
}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        let note = notes[indexPath.row]
        vc.configuration(simpleMark: note, with: .view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let note = notes[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
            vc.configuration(simpleMark: note, with: .edit)
            self?.navigationController?.pushViewController(vc, animated: true)
            completion(true)
        }
        action.backgroundColor = .green
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let note = notes[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") {[weak self] (action, view, completion) in
            RealmService.shared.delete(note)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        return action
    }
}

// MARK: - Search Result Updating

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let realm = RealmService.shared.realm
        if searchBarIsEmpty() {
            notes = realm.objects(Note.self).sorted(byKeyPath: "date", ascending: isSorted)
        } else {
            let predicat = NSPredicate(format: "text CONTAINS [c] %@", text)
            notes = realm.objects(Note.self).filter(predicat).sorted(byKeyPath: "date", ascending: isSorted)
            
        }
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

// MARK: - Search Bar Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItems?[1].isEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItems?[1].isEnabled = true
    }
}


