//
//  FeatureEventMappable.swift
//  simprokstate
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.
//


public protocol FeatureEventMappable {
    associatedtype Event

    var event: Event? { get }
    
    init?(event: Event)
}