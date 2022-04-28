//
//  RMCharCell.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 26-04-22.
//

import UIKit

class RMCharCell: UICollectionViewCell {
    static let reuseID = "RMCharCell"
    let actitvityindicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override var isSelected: Bool { didSet { updateAppearance() } }

    //ViwModelInit
    var rmCellViewModel = RMCellViewModel()
    // Views
    private let avatarImg : UIImageView = {
       let avatar = UIImageView()
        avatar.layer.cornerRadius = 8
        avatar.image = Constants.Images.imgPlaceholder
        avatar.contentMode = .scaleAspectFit
        return avatar
    }()
    private let charLocationImg : UIImageView = {
       let locationImg = UIImageView()
        locationImg.image = Constants.RMSystemSymbols.location
        locationImg.contentMode = .scaleAspectFit
        return locationImg
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        return nameLabel
    }()
    private let statusLabel = UILabel()
    private let genderLabel = UILabel()
    private let locationLabel = UILabel()
    private let speciesLabel = UILabel()
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    // Stacks
    private lazy var rootStack: UIStackView = {
        let rootStack = UIStackView(arrangedSubviews: [viewsStack, disclosureIndicator])
        rootStack.alignment = .center
        rootStack.axis = .horizontal
        rootStack.distribution = .fillProportionally
        return rootStack
    }()
    private lazy var viewsStack: UIStackView = {
        let viewsStack = UIStackView(arrangedSubviews: [
            imageNameView,
            speciesLabel,
            genderLabel,
            statusLabel
        ])
        viewsStack.axis = .vertical
        viewsStack.spacing = padding
        
        return viewsStack
    }()
    
    private lazy var imageNameView : UIView = {
       let view = UIView()
        view.addSubViews(avatarImg, nameLabel)
        return view
    }()
    private lazy var locationImageLblView : UIView = {
        let view = UIView()
        view.addSubViews(charLocationImg, locationLabel)
        return view
    }()
    // Constraints
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    // Layout
    private let padding: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setCharCell(rmModel: RMModel) {
        charBindingManager()
        Task {
            await rmCellViewModel.getCellData(url: rmModel.image, rmModel: rmModel)
        }
    }
    
    func charBindingManager()  {
        rmCellViewModel.refreshRMCellViewModel = { [weak self] stateIn in
            switch stateIn {
            case .loaded(let char):
                self?.actitvityindicator.stopAnimating()
                self?.updateContent(char)
            case .loading:
                self?.actitvityindicator.startAnimating()
            case .loadedWithError(let error):
                self?.actitvityindicator.stopAnimating()
                print(error.rawValue)
            }
            
        }
    }
    func updateContent(_ model: RMCellModel)  {
        nameLabel.text = model.name
        statusLabel.text = "Status: \(model.status)"
        speciesLabel.text = "Specie: \(model.species)"
        genderLabel.text = "Gender: \(model.gender)"
        avatarImg.image = model.image
    }
}

private extension RMCharCell {
    func setUpView()  {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = cornerRadius
        contentView.addSubViews(rootStack)
        setConstraints()
        updateAppearance()
    }
    func setConstraints()  {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
           
            
            avatarImg.topAnchor.constraint(equalTo: imageNameView.topAnchor),
            avatarImg.leadingAnchor.constraint(equalTo: imageNameView.leadingAnchor),
            avatarImg.bottomAnchor.constraint(equalTo: imageNameView.bottomAnchor),
            avatarImg.widthAnchor.constraint(equalToConstant: 80),
            avatarImg.heightAnchor.constraint(equalTo: avatarImg.widthAnchor),
            

            nameLabel.centerYAnchor.constraint(equalTo: avatarImg.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImg.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: imageNameView.trailingAnchor, constant: -padding),

            
        ])
        
        // We need constraints that define the height of the cell when closed and when open
        // to allow for animating between the two states.
        closedConstraint =
            imageNameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        closedConstraint?.priority = .defaultLow // use low priority so stack stays pinned to top of cell
        
        openConstraint =
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        openConstraint?.priority = .defaultLow
    }
    
    /// Updates the views to reflect changes in selection
    private func updateAppearance() {
        closedConstraint?.isActive = !isSelected
        openConstraint?.isActive = isSelected
        if isSelected {
            statusLabel.isHidden = false
            genderLabel.isHidden = false
            speciesLabel.isHidden = false
        } else {
            statusLabel.isHidden = true
            genderLabel.isHidden = true
            speciesLabel.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.disclosureIndicator.transform = self.isSelected ? upsideDown :.identity
        }
    }
}
