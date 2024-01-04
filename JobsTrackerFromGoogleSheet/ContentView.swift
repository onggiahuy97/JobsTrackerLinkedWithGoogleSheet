//
//  ContentView.swift
//  JobsTrackerFromGoogleSheet
//
//  Created by Huy Ong on 1/3/24.
//

import SwiftUI

struct JobApplication: Codable, Identifiable {
    var id: Int
    var company: String
    var title: String
    var dateApplied: String
    var jobLocation: String
    var status: String
    var contactPerson: String
    var resume: String
    var followUp: String
    var notesComments: String
    var outcomeFeedback: String
    var networking: String
    var linkToPosting: String

    init(id: Int, from array: [String]) {
        self.id = id
        company = array.indices.contains(0) ? array[0] : ""
        title = array.indices.contains(1) ? array[1] : ""
        dateApplied = array.indices.contains(2) ? array[2] : ""
        jobLocation = array.indices.contains(3) ? array[3] : ""
        status = array.indices.contains(4) ? array[4] : ""
        contactPerson = array.indices.contains(5) ? array[5] : ""
        resume = array.indices.contains(6) ? array[6] : ""
        followUp = array.indices.contains(7) ? array[7] : ""
        notesComments = array.indices.contains(8) ? array[8] : ""
        outcomeFeedback = array.indices.contains(9) ? array[9] : ""
        networking = array.indices.contains(10) ? array[10] : ""
        linkToPosting = array.indices.contains(11) ? array[11] : ""
    }
}

struct JobApplicationsResponse: Codable {
    var range: String
    var majorDimension: String
    var values: [[String]]

    func toJobApplications() -> [JobApplication] {
        return values.dropFirst().enumerated().map { index, array in
            JobApplication(id: index + 1, from: array)
        }
    }
}

struct ContentView: View {
    @State private var jobs: [JobApplication] = []
    
    var body: some View {
        List(jobs) { job in
            Text(job.title)
        }
        .onAppear {
            Task {
                do {
                    try await fetchJobApplications()
                } catch {
                    print("Error")
                }
            }
        }
    }
    
    func fetchJobApplications() async throws {
        let apiKey: String = "AIzaSyBNVdRBqXz8dkddLxDPtxxHlWdUIfSc1zA"
        let sheetID: String = "1iLlr_pyulrtIlsy3lexmSwbCNL-j-0ZMRne6Z6Bzgf8"
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/Sheet1?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession.shared
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(JobApplicationsResponse.self, from: data)
        self.jobs = response.toJobApplications()
    }
}

#Preview {
    ContentView()
}
