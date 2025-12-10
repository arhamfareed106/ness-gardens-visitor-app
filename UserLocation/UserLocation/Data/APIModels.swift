//
//  APIModels.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation

// MARK: - APIPlant
struct APIPlant: Codable {
    let recnum: String
    let acid: String?
    let accsta: String?
    let family: String?
    let genus: String?
    let species: String?
    let infraspecificEpithet: String?
    let vernacularName: String?
    let cultivarName: String?
    let donor: String?
    let latitude: String?
    let longitude: String?
    let country: String?
    let iso: String?
    let sgu: String?
    let loc: String?
    let alt: String?
    let cnam: String?
    let cid: String?
    let cdat: String?
    let bed: String?
    let memoriam: String?
    let redlist: String?
    let lastModified: String?

    enum CodingKeys: String, CodingKey {
        case recnum
        case acid
        case accsta
        case family
        case genus
        case species
        case infraspecificEpithet = "infraspecific_epithet"
        case vernacularName = "vernacular_name"
        case cultivarName = "cultivar_name"
        case donor
        case latitude
        case longitude
        case country
        case iso
        case sgu
        case loc
        case alt
        case cnam
        case cid
        case cdat
        case bed
        case memoriam
        case redlist
        case lastModified = "last_modified"
    }
}

// MARK: - APIBed
struct APIBed: Codable {
    let bedID: String
    let name: String
    let latitude: String
    let longitude: String
    let lastModified: String

    enum CodingKeys: String, CodingKey {
        case bedID = "bed_id"
        case name
        case latitude
        case longitude
        case lastModified = "last_modified"
    }
}

// MARK: - APIImage
struct APIImage: Codable {
    let recnum: String
    let imgid: String
    let imgFileName: String
    let imgtitle: String
    let photodt: String
    let photonme: String
    let copy: String
    let lastModified: String

    enum CodingKeys: String, CodingKey {
        case recnum
        case imgid
        case imgFileName = "img_file_name"
        case imgtitle
        case photodt
        case photonme
        case copy
        case lastModified = "last_modified"
    }
}