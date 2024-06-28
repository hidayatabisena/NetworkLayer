//
//  NetworkEngine+Ext.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation
import OSLog

struct NetworkRequestContext<T: Decodable> {
    let request: NetworkRequest
    let type: T.Type
    let completion: (Result<T, NetworkError>) -> Void
    let requestInvokeTime: Date
}

protocol NetworkEngineAdapter {
    func invokeEngine<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public struct NetworkEngine {
    private let urlSession: URLSession
    private let logger: Logger
    private let responseHandler: HTTPResponseHandler
    
    public init(urlSession: URLSession = .shared,
                logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NetworkEngine", category: "Network"),
                responseHandler: HTTPResponseHandler = DefaultHTTPResponseHandler()) {
        self.urlSession = urlSession
        self.logger = logger
        self.responseHandler = responseHandler
    }
}

extension NetworkEngine: NetworkEngineAdapter {
    func invokeEngine<T>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        let requestInvokeTime = Date()
        let context = NetworkRequestContext(request: request, type: type, completion: completion, requestInvokeTime: requestInvokeTime)
        fetch(context)
    }
    
    private func fetch<T>(_ context: NetworkRequestContext<T>) where T: Decodable {
        do {
            var urlRequest = try context.request.urlRequest()
            urlRequest.timeoutInterval = context.request.timeoutInterval
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                let requestFinishTime = Date()
                let duration = requestFinishTime.timeIntervalSince(context.requestInvokeTime)
                
                // Log metrics using OSLog
                self.logger.info("Request to \(urlRequest.url?.absoluteString ?? "Unknown URL")")
                self.logger.info("Started at: \(context.requestInvokeTime)")
                self.logger.info("Ended at: \(requestFinishTime)")
                self.logger.info("Duration: \(duration) seconds")
                
                if let error = error {
                    context.completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let data = data else {
                    context.completion(.failure(.dataNotFound))
                    return
                }
                
                do {
                    try self.responseHandler.handleStatusCode(response: response)
                    let decodedObject = try self.responseHandler.decode(data: data, to: context.type)
                    context.completion(.success(decodedObject))
                } catch let error as NetworkError {
                    context.completion(.failure(error))
                } catch {
                    context.completion(.failure(.unknownError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)))
                }
            }.resume()
        } catch {
            context.completion(.failure(.requestFailed(error)))
        }
    }
}
