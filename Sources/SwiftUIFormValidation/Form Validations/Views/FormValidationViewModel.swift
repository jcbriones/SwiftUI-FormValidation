//
//  FormValidationViewModel.swift
//  
//
//  Created by Jc Briones on 4/24/23.
//

import Combine
import Foundation

class FormValidationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var validationResult: FormValidationResult = .valid

    private var validators: [FormValidator]
    private var valueSubject = PassthroughSubject<any Equatable, Never>()
    private var subscribers = Set<AnyCancellable>()

    init(validators: [FormValidator], delay: RunLoop.SchedulerTimeType.Stride) {
        self.validators = validators
        valueSubject
            .debounce(for: delay, scheduler: RunLoop.main)
            .flatMap { value in
                validators.validate(value)
            }
            .sink { [self] result in
                validationResult = result.first { $0 != .valid } ?? .valid
            }
            .store(in: &subscribers)
    }

    // MARK: - Public

    func validate(_ value: any Equatable) {
        valueSubject.send(value)
    }

    func forceValidate(_ value: any Equatable, with external: FormValidationResult) {
        validators.validate(value)
            .sink { [self] result in
                validationResult = result.first { $0 != .valid } ?? external
            }
            .store(in: &subscribers)
    }
}
