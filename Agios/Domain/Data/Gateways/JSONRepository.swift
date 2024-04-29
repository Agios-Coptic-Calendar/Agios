////
////  JSONRepository.swift
////  Natega
////
////  Created by Nikola Veljanovski on 12.3.23.
////
//
//import Combine
//
//protocol JSONRepositoryProtocol {
//    func loadJson<T: Decodable>(from fileName: String) -> AnyPublisher<T, Error>
//}
//
//struct JSONRepository: JSONRepositoryProtocol {
//    let apiClient: JSONManagerProtocol
//    
//    func loadJson<T>(from fileName: String) -> AnyPublisher<T, Error> where T : Decodable {
//        apiClient.loadJson(from: fileName)
//    }
//}
