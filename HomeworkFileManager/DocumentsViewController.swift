//
//  DocumentsViewController.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 28.08.2022.
//

import UIKit

class DocumentsViewController: UIViewController {
    private lazy var list = UITableView()
        .with {
            $0.rowHeight = 120
            $0.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.id)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.dataSource = self
            $0.delegate = self
        }
    
    // MARK: - Properties
    private lazy var photosURLs: [URL] = [] {
        didSet { list.reloadData() }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        configureNavigationBar()
        loadImages()
    }
    
    // MARK: - Metods
    private func loadImages() {
        guard let photosURLs = (try? FileManager
            .default
            .contentsOfDirectory(
                at: FileManager.documentDirectoryURL,
                includingPropertiesForKeys: nil)) else { return }
        self.photosURLs = photosURLs
    }
    
    // MARK: - Actions
    @objc
    private func addPhoto() {
        let imagePicker = UIImagePickerController()
            .with {
                $0.sourceType = .photoLibrary
                $0.delegate = self
            }
        present(imagePicker, animated: true)
    }
    
    // MARK: - Layout
    private func configureNavigationBar() {
        let addPhotoButton = UIBarButtonItem(
            title: "Добавить фото",
            style: .plain,
            target: self,
            action: #selector(addPhoto))
        
        navigationItem.rightBarButtonItem = addPhotoButton
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(list)
        
        NSLayoutConstraint
            .activate([
                list.topAnchor.constraint(equalTo: view.topAnchor),
                list.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                list.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                list.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

// MARK: - UITableViewDataSource
extension DocumentsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int { photosURLs.count }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: PhotoTableViewCell.id,
                for: indexPath) as! PhotoTableViewCell
        
        if let data = try? Data(contentsOf: photosURLs[indexPath.row]),
           let image = UIImage(data: data) {
            cell.image = image
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension DocumentsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let path = photosURLs[indexPath.row].path
            
            do {
                try FileManager.default.removeItem(atPath: path)
                photosURLs.remove(at: indexPath.row)
            } catch {
                print(error)
            }
            
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.originalImage] as? UIImage,
        let data = image.pngData() else { return }
        
        let name = String(describing: image)
        do {
            try data.write(to: FileManager.documentDirectoryURL.appending(path: name))
        } catch {
            print(error)
        }
        loadImages()
        picker.dismiss(animated: true)
    }
}
