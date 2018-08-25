//
//  MainAssempler.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class MainAssembler {
    private let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)
    var resolver: Resolver {
        return assembler.resolver
    }
    init() {
        assembler.apply(assembly: SPDLocationManagerAssembly())
        assembler.apply(assembly: SPDLocationAuthorizationAssembly())
        assembler.apply(assembly: SPDLocationProviderAssembly())
        assembler.apply(assembly: SPDLocationSpeedProviderAssembly())
        assembler.apply(assembly: SPDLocationSpeedCheckerAssembly())
        assembler.apply(assembly: ViewControllerAssembly())
    }
}
