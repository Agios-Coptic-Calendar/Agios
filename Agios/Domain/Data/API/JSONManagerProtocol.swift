////
////  JSONManagerProtocol.swift
////  Natega
////
////  Created by Nikola Veljanovski on 12.3.23.
////
//
//import Combine
//import Foundation
//
//protocol JSONManagerProtocol {
//    func loadJson<T: Decodable>(from file: String) -> AnyPublisher<T, Error>
//}
//
//class JSONManager: JSONManagerProtocol {
//    func loadJson<T>(from fileName: String) -> AnyPublisher<T, Error> where T : Decodable {
//        let decoder = JSONDecoder()
//        let publisher = Bundle.main.url(forResource: fileName, withExtension: "json").publisher
//        return publisher
//            .tryMap({ url in
//                guard let data = try? Data(contentsOf: url) else {
//                    fatalError("Failed to load \(fileName) from bundle.")
//                }
//                return data
//            })
//            .replaceError(with: Data())
//            .decode(type: T.self, decoder: decoder)
//            .print()
//            .eraseToAnyPublisher()
//    }
//}
