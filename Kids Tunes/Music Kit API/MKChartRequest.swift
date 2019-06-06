//
//  Charts.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/20/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import Foundation

public struct ChartsRequest {

    /**
     Returns a `URLRequest` for for a requesting a Chart from the Apple Music API via a genre id
     
     - parameter genre: The identifier for the genre to use in the chart results.
     - parameter types: An `Array` of `ChartType` which will define which types to include in the response (songs, albums and/or music videos)
     - parameter chart: The chart to fetch for the specified types. For possible values, get all the charts by sending this endpoint without the chart parameter. The possible values for this parameter are the chart attributes of the Chart objects in the response.
     - parameter limit: The number of resources to include per chart. The default value is 20 and the maximum value is 50.
     - parameter offset: (Optional; only appears when chart is specified) The next page or group of objects to fetch.
     
     - returns: A `URLRequest` with all of the query params
     */
    
    static public func byGenre(genre: String, types: [ChartType]?, chart: String?, limit: String?, offset: String?) -> URLRequest {
        var components = URLComponents()
        components.path = MKURLComponent.chartsPath
        
        var queryItems = [URLQueryItem]()
        let genreQueryItem = URLQueryItem(name: MKURLComponent.genreParameter, value: genre)
        queryItems.append(genreQueryItem)
        
        if let limit = limit {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.limitParameter, value: limit)
            queryItems.append(limitQueryItem)
        }
        
        if let offset = offset {
            let limitQueryItem = URLQueryItem(name: MKURLComponent.offsetParameter, value: offset)
            queryItems.append(limitQueryItem)
        }
        
        if let types = types, types.count > 0 {
            let typesQueryItem = URLQueryItem(name: MKURLComponent.typesParameter, value: types.map { $0.rawValue }.joined(separator: ","))
            queryItems.append(typesQueryItem)
        }
        components.queryItems = queryItems
        
        let request = MKURLRequest().request(url: components.url(relativeTo: baseUrl)!, httpMethod: HTTPMethod.GET.rawValue)
        
        return request
    }
    
}
