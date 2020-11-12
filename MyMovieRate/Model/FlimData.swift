//
//  FlimData.swift
//  MyMovieRate
//
//  Created by Lin Yi Sen on 2020/9/14.
//  Copyright © 2020 Ethan. All rights reserved.
//

import Foundation


//取得電影資料
struct MoviesData: Codable {
    var title: String?
    var vote_average: Double?
    var release_date: String?
    var poster_path: String?
    
}

struct Film: Codable {
    var results:[MoviesData]
}



