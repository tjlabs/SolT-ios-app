import Foundation
import RxSwift
import RxRelay

class WarpViewModel {
    // Observables for the data
    let sectorData: BehaviorRelay<OutputSector?> = BehaviorRelay(value: nil)
    let contentData: BehaviorRelay<OutputContent?> = BehaviorRelay(value: nil)
    let advertisementData: BehaviorRelay<OutputAdvertisement?> = BehaviorRelay(value: nil)
    
    var sectorWarpDict = [String: Double]()
    
    private let disposeBag = DisposeBag()

    // Fetch Sector Data
    func fetchSectorData(input: InputSector) {
        NetworkManager.shared.postSector(url: SECTOR_URL, input: input) { [weak self] statusCode, result in
            guard let self = self else { return }

            if statusCode == 200, let data = result.data(using: .utf8) {
                if let decodedResult = try? JSONDecoder().decode(OutputSector.self, from: data) {
                    print("Sector Result : \(decodedResult)")
                    for item in decodedResult.content_rf_list {
                        sectorWarpDict[item.ward_id] = item.content_rss
                    }
                    self.sectorData.accept(decodedResult)
                } else {
                    print("Failed to fetch sector data: \(result)")
                    self.sectorData.accept(nil)
                }
            } else {
                print("Failed to fetch sector data: \(result)")
                self.sectorData.accept(nil)
            }
        }
    }

    // Fetch Content Data
    func fetchContentData(input: InputContent) {
        NetworkManager.shared.postContent(url: CONTENT_URL, input: input) { [weak self] statusCode, result in
            guard let self = self else { return }

            if statusCode == 200, let data = result.data(using: .utf8) {
                if let decodedResult = try? JSONDecoder().decode(OutputContent.self, from: data) {
                    print("Content Result : \(decodedResult)")
                    self.contentData.accept(decodedResult)
                } else {
                    print("Failed to fetch content data: \(result)")
                    self.contentData.accept(nil)
                }
            } else {
                print("Failed to fetch content data: \(result)")
                self.contentData.accept(nil)
            }
        }
    }

    // Fetch Advertisement Data
    func fetchAdvertisementData(input: InputAdvertisement) {
        NetworkManager.shared.postAdvertisement(url: ADVERTISEMENT_URL, input: input) { [weak self] statusCode, result in
            guard let self = self else { return }

            if statusCode == 200, let data = result.data(using: .utf8) {
                if let decodedResult = try? JSONDecoder().decode(OutputAdvertisement.self, from: data) {
                    print("Advertisement Result : \(decodedResult)")
                    self.advertisementData.accept(decodedResult)
                } else {
                    print("Failed to fetch advertisement data: \(result)")
                    self.advertisementData.accept(nil)
                }
            } else {
                print("Failed to fetch advertisement data: \(result)")
                self.advertisementData.accept(nil)
            }
        }
    }
}
