//
//  Story.swift
//  simprokstate
//
//  Created by Andrey Prokhorenko on 01.01.2020.
//  Copyright (c) 2020 simprok. All rights reserved.

import simprokmachine

public struct Story<Event> {

    private let _transit: Mapper<Event, Story<Event>?>

    public init(transit: @escaping Mapper<Event, Story<Event>?>) {
        _transit = transit
    }

    public func transit(_ event: Event) -> Story<Event>? {
        _transit(event)
    }
}

public extension Story {

    func asExtTriggerExtEffect<IntTrigger, IntEffect>() -> Feature<IntTrigger, IntEffect, Event, Event> {
        Feature { event in
            if let new = transit(event) {
                return FeatureTransition(
                        new.asExtTriggerExtEffect(),
                        effects: .ext(event)
                )
            } else {
                return nil
            }
        }
    }

    func asExtTriggerIntEffect<IntTrigger, ExtEffect>(
            _ machines: Set<Machine<Event, IntTrigger>>
    ) -> Feature<IntTrigger, Event, Event, ExtEffect> {
        Feature(machines) { machines, event in
            switch event {
            case .ext(let value):
                if let new = transit(value) {
                    return FeatureTransition(
                            new.asExtTriggerIntEffect(machines),
                            effects: .int(value)
                    )
                } else {
                    return nil
                }
            case .int:
                return nil
            }
        }
    }

    func asIntTriggerExtEffect<IntEffect, ExtTrigger>(
            _ machines: Set<Machine<IntEffect, Event>>
    ) -> Feature<Event, IntEffect, ExtTrigger, Event> {
        Feature(machines) { machines, event in
            switch event {
            case .ext:
                return nil
            case .int(let value):
                if let new = transit(value) {
                    return FeatureTransition(
                            new.asIntTriggerExtEffect(machines),
                            effects: .ext(value)
                    )
                } else {
                    return nil
                }
            }
        }
    }

    func asIntTriggerIntEffect<ExtTrigger, ExtEffect>(
            _ machines: Set<Machine<Event, Event>>
    ) -> Feature<Event, Event, ExtTrigger, ExtEffect> {
        Feature(machines) { machines, event in
            switch event {
            case .ext:
                return nil
            case .int(let value):
                if let new = transit(value) {
                    return FeatureTransition(
                            new.asIntTriggerIntEffect(machines),
                            effects: .int(value)
                    )
                } else {
                    return nil
                }
            }
        }
    }
}