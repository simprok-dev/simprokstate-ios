//
//  DomainScenario.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


public protocol DomainScenario: DomainFeatured where ToFeatured: DomainScenario {
    
}