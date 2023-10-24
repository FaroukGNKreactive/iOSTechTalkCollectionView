//
//  ViewController.swift
//  iOSTeckTalk
//
//  Created by Farouk GNANDI on 20/10/2023.
//

import UIKit
import SwiftUI

class ViewCOn: UIViewController {
    private weak var collectionView: UICollectionView!
    private var diffableDatasource: UICollectionViewDiffableDataSource<Section, Item>!
    private var slideshowItemOne = [UIImage(named: "img1")!, UIImage(named: "img2")!]
    private var slideshowItemTwo = [UIImage(named: "img3")!, UIImage(named: "img4")!]
    private var slideshowItemThree = [UIImage(named: "img5")!, 
                                      UIImage(named: "img6")!,
                                      UIImage(named: "img7")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .systemBackground
        
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: createLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth,
                                           .flexibleHeight]
        self.collectionView = collectionView
        
        view.addSubview(collectionView)
        
        configureDatasource()
        
        applySnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environement -> NSCollectionLayoutSection? in
            
            let section = self.diffableDatasource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .list,
                    .largeTextSection,
                    .defaultList:
                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                
                configuration.backgroundColor = .secondarySystemBackground
                
                let listlayout = NSCollectionLayoutSection.list(using: configuration,
                                                                layoutEnvironment: environement)
                
                return listlayout
                
            case .slideshow:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                      heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(200))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               repeatingSubitem: item,
                                                               count: 2)
                
                let layoutSection = NSCollectionLayoutSection(group: group)
                
                layoutSection.contentInsets = .zero
                
                return layoutSection
            }
        }
        
        return layout
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.list])
        snapshot.appendItems([.listItem("Sunset or sunrise? that's the question."),
                              .listItem("Sunset fill or sunrise fill? that's the question."),
                              .listItem("Sunrise or sunset? that's the question."),
                              .listItem("Sunrise fill or sunset fill? that's the question.")],
                             toSection: .list)
        
        snapshot.appendSections([.defaultList])
        
        snapshot.appendItems([.defaultListItem],
                             toSection: .defaultList)
        
        snapshot.appendSections([.slideshow])
        
        snapshot.appendItems([.images(slideshowItemOne),
                              .images(slideshowItemTwo),
                              .images(slideshowItemThree)],
                             toSection: .slideshow)
        
        snapshot.appendSections([.largeTextSection])
        
        snapshot.appendItems([.largeText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis nisl turpis, ullamcorper ac dui id, lobortis accumsan augue. Nullam semper eleifend libero in imperdiet. Nunc efficitur accumsan neque et ornare. Duis sed tortor venenatis leo accumsan mollis id eu felis. In aliquet fringilla nulla, ac tincidunt arcu tincidunt a. Nam sit amet scelerisque ex. Nullam rutrum tortor ut felis commodo consectetur. Aenean tempor dui ante, a consectetur sapien tincidunt sed. Etiam venenatis, arcu id consectetur vehicula, lacus orci aliquet mi, quis aliquam turpis est id eros. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc vitae justo sollicitudin, malesuada lorem id, scelerisque lacus. Phasellus auctor quis ex sit amet pulvinar. Quisque semper rhoncus leo, nec luctus purus vehicula quis. Phasellus at purus faucibus, dignissim mi et, facilisis odio. Proin malesuada ultricies consequat.")],
                             toSection: .largeTextSection)
        return snapshot
    }
    
    private func applySnapshot() {
        let snapshot = createSnapshot()
        diffableDatasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureDatasource() {
        let uiLabelCollectionViewCellRegistration = UICollectionView.CellRegistration<UILabelCollectionViewCell, String> { cell, _ , item in
            cell.configure(description: item)
        }
        
        let defaultContentConfiguration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, _ , text in
            var content = cell.defaultContentConfiguration()
            
            content.image = UIImage(systemName: "sun.min")
            content.text = text
            
            cell.contentConfiguration = content
        }
        
        let textCollectionViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, _, text in
            let hostingConfiguration = UIHostingConfiguration {
                let icons = ["sunset", "sunset.fill", "sun.min", "sun.min.fill"]
                
                HStack {
                    Image(icons.randomElement()!)
                        .padding()

                    Text(text)
                    
                    Spacer()
                }.swipeActions {
                    Button { } label: {
                        Label("Favorite", systemImage: "star")
                    }
                    .tint(.yellow)
                }
            }
            
            cell.contentConfiguration = hostingConfiguration
            
            cell.accessories = [.disclosureIndicator()]
        }
        
        let slideShowCollectionViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, [UIImage]> { cell, _ , images in
            
            let hostingConfiguration = UIHostingConfiguration {
                ImageSlider(images: images)
            }
            
            cell.contentConfiguration = hostingConfiguration
        }
        
        diffableDatasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .listItem(let text):
                let cell = collectionView.dequeueConfiguredReusableCell(using: textCollectionViewCellRegistration,
                                                                        for: indexPath,
                                                                        item: text)
                
                return cell
                
            case .defaultListItem:
                let cell = collectionView.dequeueConfiguredReusableCell(using: defaultContentConfiguration,
                                                                        for: indexPath,
                                                                        item: "Hello Sunshine!")
                
                return cell
                
            case .images(let images):
                let cell = collectionView.dequeueConfiguredReusableCell(using: slideShowCollectionViewCellRegistration,
                                                                        for: indexPath,
                                                                        item: images)
                
                return cell
                
            case .largeText(let string):
                let cell = collectionView.dequeueConfiguredReusableCell(using: uiLabelCollectionViewCellRegistration,
                                                                        for: indexPath,
                                                                        item: string)
                
                return cell
            }

        })
    }
}

extension ViewCOn: UICollectionViewDelegate { }

extension ViewCOn {
    enum Section {
        case list
        case defaultList
        case slideshow
        case largeTextSection
    }
    
    enum Item: Hashable {
        case listItem(String)
        case defaultListItem
        case images([UIImage])
        case largeText(String)
    }
}


