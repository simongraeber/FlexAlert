import SwiftUI
import SwiftData

struct ExerciseRecordTestView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var records: [ExerciseRecord]
    @State private var selectedExercise: Exercise?
    @State private var duration: TimeInterval = 60 // Default 1 minute
    @State private var exersiceDate = Date()

    var body: some View {
        NavigationStack {
            List {
                CreateNewRecordSection(
                    selectedExercise: $selectedExercise,
                    duration: $duration,
                    exersiceDate: $exersiceDate,
                    addRecord: addRecord
                )

                ExistingRecordsSection(
                    records: records,
                    deleteRecords: deleteRecords
                )

                Button("Delete All Data") {
                    deleteAllRecords()
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Exercise Records")
        }
    }

    private func addRecord() {
        guard let exercise = selectedExercise else {
            print("No exercise selected")
            return
        }

        let record = ExerciseRecord(
            exerciseId: exercise.id,
            date: exersiceDate,
            duration: duration
        )

        modelContext.insert(record)

        do {
            try modelContext.save() // Save the context to persist the data
            print("Record added and saved: \(record)")
        } catch {
            print("Failed to save record: \(error)")
        }

        // Reset selection
        selectedExercise = nil
        duration = 60
        exersiceDate = Date()
    }

    private func deleteAllRecords() {
        do {
            try modelContext.delete(model: ExerciseRecord.self)
            print("All records deleted successfully")
        } catch {
            print("Failed to delete records: \(error)")
        }
    }

    private func deleteRecords(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
    }
}

struct CreateNewRecordSection: View {
    @Binding var selectedExercise: Exercise?
    @Binding var duration: TimeInterval
    @Binding var exersiceDate: Date
    let addRecord: () -> Void

    var body: some View {
        Section("Create New Record") {
            Picker("Select Exercise", selection: $selectedExercise) {
                ForEach(ExerciseStore.shared.exercises) { exercise in
                    Text(exercise.name).tag(Optional(exercise))
                }
            }
            .frame(height: 20)

            Stepper("Duration: \(Int(duration))s", value: $duration, in: 30...300, step: 30)

            DatePicker("Date",
                       selection: $exersiceDate,
                       in: ...Date())

            Button("Add Record") {
                addRecord()
            }
            .disabled(selectedExercise == nil)
        }
    }
}

struct ExistingRecordsSection: View {
    let records: [ExerciseRecord]
    let deleteRecords: (IndexSet) -> Void

    var body: some View {
        Section("Existing Records") {
            ForEach(records) { record in
                VStack(alignment: .leading) {
                    if let exercise = ExerciseStore.shared.exercises.first(where: { $0.id == record.exerciseId }) {
                        Text(exercise.name)
                            .font(.headline)
                    }
                    Text("Duration: \(Int(record.duration))s")
                    Text("Date: \(record.date.formatted())")
                }
            }
            .onDelete(perform: deleteRecords)
        }
    }
}

#Preview {
    ExerciseRecordTestView()
        .modelContainer(for: ExerciseRecord.self)
}
