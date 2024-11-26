import Foundation

let SECTOR_URL = "https://ap-northeast-2.user.warp.tjlabs.dev/2024-07-31/content-rf"
let CONTENT_URL = "https://ap-northeast-2.user.warp.tjlabs.dev/2024-07-31/content"
let ADVERTISEMENT_URL = "https://ap-northeast-2.user.warp.tjlabs.dev/2024-07-31/ad"

// InputSector //
struct InputSector: Codable {
    var sector_id: Int
    var operating_system: String
}

struct ContentRF: Codable {
    var ward_id: String
    var content_rss: Double
}

struct OutputSector: Codable {
    var content_rf_list: [ContentRF]
}


// InputContent //
struct InputContent: Codable {
    var ward_id: String
}

struct Content: Codable {
    var id: Int
    var number: Int
    var name: String
    var url: String
    var admin_flag: Bool
    var type: Int
}

struct OutputContent: Codable {
    var content_list: [Content]
}

// InputAdvertisement //
struct InputAdvertisement: Codable {
    var content_id: Int
}

struct OutputAdvertisement: Codable {
    var url: String
}
