import Foundation
import UIKit

class AsyncImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    var urlString: String?
    
    @Published var downloadingImage = false
    
    var serviceAPI: ServiceAPIProtocol?
    
    init(urlString: String?, serviceAPI: ServiceAPIProtocol?) {
        self.urlString = urlString
        self.serviceAPI = serviceAPI
        
        guard let urlString = urlString else {
            return
        }
        
        #if !TEST
        fetchImage(for: urlString)
        #endif
    }
    
    func fetchImage(for urlString: String) {
        guard let url = URL(string: urlString) else {
            downloadingImage = false
            return
        }
        
        let imageName = ImageStorageHandler.getImageName(from: url)
        
        // Check cache for the image.
        if let locallyCachedImage = ImageStorageHandler.getImageFromLocalStorage(imageName: imageName) {
            image = locallyCachedImage
            return
        }
        
        downloadImage(url: url)
    }
    
    func downloadImage(url: URL) {
        downloadingImage = true
        
        // Download image
        serviceAPI?.fetchImage(for: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
                
            case .failure(let error):
                self.image = UIImage(systemName: "person.crop.circle.fill")
                Logger.log(message: error.localizedDescription, severity: .warning, customData: [:])
            }
            
            DispatchQueue.main.async {
                self.downloadingImage = false
            }
        }
    }
}