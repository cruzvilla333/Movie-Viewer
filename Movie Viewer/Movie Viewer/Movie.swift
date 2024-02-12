//
//  SwiftUIView.swift
//  Project 3
//
//  Created by Cruz Villafranca on 2/4/24.
//

struct Movie: Identifiable, Decodable {
        let adult: Bool;
let backdrop_path: String;
let genre_ids: [Int];
let id: Int;
let original_language: String;
let original_title: String;
let overview: String;
let popularity: Float;
let poster_path: String;
let release_date: String;
let title: String;
let video: Bool;
let vote_average: Float;
let vote_count: Int;
}

struct Dates: Decodable {
let maximum: String;
let minimum: String;
}

struct MovieApiData :  Decodable {
    let dates: Dates;
    let page: Int;
    let results: [Movie];
    let total_pages: Int;
    let total_results: Int;
}

import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    func fetchData() {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") else {
                    print("Invalid URL")
                    return
                }

        URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        print("Error fetching data: \(error.localizedDescription)")
                        return
                    }

                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(MovieApiData.self, from: data)
                            print(decodedData)
                            DispatchQueue.main.async {
                                self.movies = decodedData.results
                            }
                        } catch {
                            print("Error decoding data: \(error.localizedDescription)")
                        }
                    }
                }.resume()
        }
}
