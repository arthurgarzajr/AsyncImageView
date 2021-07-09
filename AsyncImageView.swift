import SwiftUI

struct AsyncImageView: View {
    @ObservedObject var viewModel: AsyncImageViewModel
    
    var body: some View {
        if viewModel.downloadingImage {
            ActivityIndicatorView()
        } else if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .foregroundColor(.secondary)
                .clipShape(Circle())
                .shadow(radius: 10)
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundColor(.secondary)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
