//
//  AssessmentConfigEditorView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 21.05.2026.
//


import SwiftUI

struct AssessmentConfigEditorView: View {
    @ObservedObject var viewModel: TaskDetailViewModel

    var body: some View {
        NavigationStack {
            Form {
                configSection
                criteriaSection
                modifiersSection
                errorSection
            }
            .navigationTitle("Assessment config")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.closeAssessmentConfigEditor()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.saveAssessmentConfig()
                        }
                    } label: {
                        if viewModel.isSavingAssessmentConfig {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(viewModel.isSavingAssessmentConfig)
                }
            }
        }
    }

    private var configSection: some View {
        Section("General") {
            DraftDecimalTextField(
                title: "Max grade",
                value: viewModel.assessmentConfigDraft?.maxGrade,
                onValidNumber: { viewModel.updateAssessmentMaxGradeDraft($0.description) }
            )

            Toggle(
                "Visible for students",
                isOn: Binding(
                    get: { viewModel.assessmentConfigDraft?.resultsVisible ?? false },
                    set: { viewModel.updateAssessmentResultsVisibleDraft($0) }
                )
            )
        }
    }

    private var criteriaSection: some View {
        Section("Criteria") {
            if viewModel.assessmentConfigDraft?.criteria.isEmpty != false {
                Text("No criteria yet")
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.assessmentConfigDraft?.criteria ?? [], id: \.id) { criterion in
                CriterionEditorRow(
                    criterion: criterion,
                    onUpdate: viewModel.updateCriterionDraft,
                    onDelete: {
                        if let id = criterion.id {
                            viewModel.removeCriterionDraft(id: id)
                        }
                    }
                )
            }

            Button {
                viewModel.addCriterionDraft(
                    AssessmentCriterion(
                        title: "",
                        type: .points,
                        maxPoints: 100,
                        weight: 1,
                        commentEnabled: false
                    )
                )
            } label: {
                Label("Add criterion", systemImage: "plus")
            }
        }
    }

    private var modifiersSection: some View {
        Section("Modifiers") {
            ForEach(ModifierType.supportedCases, id: \.apiValue) { type in
                ModifierEditorRow(
                    modifier: modifier(for: type),
                    onUpdate: updateModifier
                )
            }
        }
    }

    private func modifier(for type: ModifierType) -> AssessmentModifier {
        viewModel.assessmentConfigDraft?
            .modifiers
            .first(where: { $0.type == type })
        ?? AssessmentModifier(type: type, enabled: false)
    }

    private func updateModifier(_ modifier: AssessmentModifier) {
        if viewModel.assessmentConfigDraft?.modifiers.contains(where: { $0.type == modifier.type }) == true {
            viewModel.updateModifierDraft(modifier)
        } else {
            viewModel.addModifierDraft(modifier)
        }
    }

    @ViewBuilder
    private var errorSection: some View {
        if let message = viewModel.assessmentErrorMessage {
            Section {
                Text(message)
                    .foregroundStyle(.red)
            }
        }
    }
}

private struct DraftDecimalTextField: View {
    let title: String
    let value: Double?
    var onEmpty: (() -> Void)?
    let onValidNumber: (Double) -> Void

    @State private var text: String

    init(
        title: String,
        value: Double?,
        onEmpty: (() -> Void)? = nil,
        onValidNumber: @escaping (Double) -> Void
    ) {
        self.title = title
        self.value = value
        self.onEmpty = onEmpty
        self.onValidNumber = onValidNumber
        _text = State(initialValue: value.map { $0.formatted(.number.precision(.fractionLength(0...2))) } ?? "")
    }

    var body: some View {
        TextField(
            title,
            text: Binding(
                get: { text },
                set: { input in
                    text = input

                    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        onEmpty?()
                        return
                    }

                    if let parsed = Double(trimmed.replacingOccurrences(of: ",", with: ".")) {
                        onValidNumber(parsed)
                    }
                }
            )
        )
        .keyboardType(.decimalPad)
    }
}

private struct DraftIntegerTextField: View {
    let title: String
    let value: Int?
    var onEmpty: (() -> Void)?
    let onValidNumber: (Int) -> Void

    @State private var text: String

    init(
        title: String,
        value: Int?,
        onEmpty: (() -> Void)? = nil,
        onValidNumber: @escaping (Int) -> Void
    ) {
        self.title = title
        self.value = value
        self.onEmpty = onEmpty
        self.onValidNumber = onValidNumber
        _text = State(initialValue: value.map(String.init) ?? "")
    }

    var body: some View {
        TextField(
            title,
            text: Binding(
                get: { text },
                set: { input in
                    text = input

                    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        onEmpty?()
                        return
                    }

                    if let parsed = Int(trimmed.filter(\.isNumber)) {
                        onValidNumber(parsed)
                    }
                }
            )
        )
        .keyboardType(.numberPad)
    }
}

private struct ModifierEditorRow: View {
    let modifier: AssessmentModifier
    let onUpdate: (AssessmentModifier) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(
                modifier.type.displayName,
                isOn: Binding(
                    get: { modifier.enabled },
                    set: { update(enabled: $0) }
                )
            )

            if modifier.enabled {
                switch modifier.type {
                case .deadline:
                    deadlineFields
                case .teamSize:
                    teamSizeFields
                case .progress:
                    progressFields
                case .contribution:
                    contributionFields
                case .unknown:
                    EmptyView()
                }
            }
        }
        .padding(.vertical, 6)
    }

    private var deadlineFields: some View {
        Group {
            TextField("Soft deadline ISO date-time", text: stringBinding(\.softDeadline))
                .textInputAutocapitalization(.never)

            TextField("Hard deadline ISO date-time", text: stringBinding(\.hardDeadline))
                .textInputAutocapitalization(.never)

            decimalField("Soft deadline bonus", value: modifier.softDeadlineBonus) {
                update(softDeadlineBonus: .some($0))
            }

            decimalField("Early submission bonus per day", value: modifier.earlySubmissionBonusPerDay) {
                update(earlySubmissionBonusPerDay: .some($0))
            }

            decimalField("Late penalty per day", value: modifier.latePenaltyPerDay) {
                update(latePenaltyPerDay: .some($0))
            }

            integerField("Max late penalty days", value: modifier.maxLatePenaltyDays) {
                update(maxLatePenaltyDays: .some($0))
            }
        }
    }

    private var teamSizeFields: some View {
        TextField("Formula", text: stringBinding(\.formula))
            .textInputAutocapitalization(.never)
    }

    private var progressFields: some View {
        Group {
            integerField("Checkpoint count", value: modifier.checkpointCount) {
                update(checkpointCount: .some($0))
            }

            decimalField("Points per checkpoint", value: modifier.pointsPerCheckpoint) {
                update(pointsPerCheckpoint: .some($0))
            }
        }
    }

    private var contributionFields: some View {
        TextField("Description", text: stringBinding(\.description), axis: .vertical)
            .lineLimit(2...4)
    }

    private func stringBinding(_ keyPath: KeyPath<AssessmentModifier, String?>) -> Binding<String> {
        Binding(
            get: { modifier[keyPath: keyPath] ?? "" },
            set: { value in
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

                switch keyPath {
                case \.softDeadline:
                    update(softDeadline: trimmed.isEmpty ? .some(nil) : .some(trimmed))
                case \.hardDeadline:
                    update(hardDeadline: trimmed.isEmpty ? .some(nil) : .some(trimmed))
                case \.formula:
                    update(formula: trimmed.isEmpty ? .some(nil) : .some(trimmed))
                case \.description:
                    update(description: trimmed.isEmpty ? .some(nil) : .some(trimmed))
                default:
                    break
                }
            }
        )
    }

    private func decimalField(
        _ title: String,
        value: Double?,
        onChange: @escaping (Double?) -> Void
    ) -> some View {
        DraftDecimalTextField(
            title: title,
            value: value,
            onEmpty: { onChange(nil) },
            onValidNumber: { onChange($0) }
        )
    }

    private func integerField(
        _ title: String,
        value: Int?,
        onChange: @escaping (Int?) -> Void
    ) -> some View {
        DraftIntegerTextField(
            title: title,
            value: value,
            onEmpty: { onChange(nil) },
            onValidNumber: { onChange($0) }
        )
    }

    private func update(
        enabled: Bool? = nil,
        softDeadline: String?? = nil,
        hardDeadline: String?? = nil,
        softDeadlineBonus: Double?? = nil,
        earlySubmissionBonusPerDay: Double?? = nil,
        latePenaltyPerDay: Double?? = nil,
        maxLatePenaltyDays: Int?? = nil,
        formula: String?? = nil,
        checkpointCount: Int?? = nil,
        pointsPerCheckpoint: Double?? = nil,
        description: String?? = nil
    ) {
        onUpdate(
            AssessmentModifier(
                id: modifier.id,
                type: modifier.type,
                enabled: enabled ?? modifier.enabled,
                softDeadline: softDeadline ?? modifier.softDeadline,
                hardDeadline: hardDeadline ?? modifier.hardDeadline,
                softDeadlineBonus: softDeadlineBonus ?? modifier.softDeadlineBonus,
                earlySubmissionBonusPerDay: earlySubmissionBonusPerDay ?? modifier.earlySubmissionBonusPerDay,
                latePenaltyPerDay: latePenaltyPerDay ?? modifier.latePenaltyPerDay,
                maxLatePenaltyDays: maxLatePenaltyDays ?? modifier.maxLatePenaltyDays,
                formula: formula ?? modifier.formula,
                checkpointCount: checkpointCount ?? modifier.checkpointCount,
                pointsPerCheckpoint: pointsPerCheckpoint ?? modifier.pointsPerCheckpoint,
                description: description ?? modifier.description
            )
        )
    }
}

private struct CriterionEditorRow: View {
    let criterion: AssessmentCriterion
    let onUpdate: (AssessmentCriterion) -> Void
    let onDelete: () -> Void

    @State private var maxPointsText: String
    @State private var weightText: String

    init(
        criterion: AssessmentCriterion,
        onUpdate: @escaping (AssessmentCriterion) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.criterion = criterion
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        _maxPointsText = State(initialValue: criterion.maxPoints.formatted(.number.precision(.fractionLength(0...2))))
        _weightText = State(initialValue: criterion.weight.formatted(.number.precision(.fractionLength(0...2))))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField(
                "Title",
                text: Binding(
                    get: { criterion.title },
                    set: { update(title: $0) }
                )
            )

            Picker(
                "Type",
                selection: Binding(
                    get: { criterion.type },
                    set: { update(type: $0) }
                )
            ) {
                ForEach(CriterionType.supportedCases, id: \.apiValue) { type in
                    Text(type.displayName).tag(type)
                }
            }

            TextField("Max points", text: $maxPointsText)
                .keyboardType(.decimalPad)
                .onChange(of: maxPointsText) { _, value in
                    update(maxPointsText: value)
                }

            TextField("Weight", text: $weightText)
                .keyboardType(.decimalPad)
                .onChange(of: weightText) { _, value in
                    update(weightText: value)
                }

            Toggle(
                "Allow comment",
                isOn: Binding(
                    get: { criterion.commentEnabled },
                    set: { update(commentEnabled: $0) }
                )
            )

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete criterion", systemImage: "trash")
            }
        }
        .padding(.vertical, 6)
    }

    private func update(
        title: String? = nil,
        type: CriterionType? = nil,
        maxPointsText: String? = nil,
        weightText: String? = nil,
        commentEnabled: Bool? = nil
    ) {
        let maxPoints = maxPointsText
            .flatMap { Double($0.replacingOccurrences(of: ",", with: ".")) }
            ?? criterion.maxPoints

        let weight = weightText
            .flatMap { Double($0.replacingOccurrences(of: ",", with: ".")) }
            ?? criterion.weight

        onUpdate(
            AssessmentCriterion(
                id: criterion.id,
                title: title ?? criterion.title,
                type: type ?? criterion.type,
                maxPoints: maxPoints,
                weight: weight,
                commentEnabled: commentEnabled ?? criterion.commentEnabled
            )
        )
    }
}
