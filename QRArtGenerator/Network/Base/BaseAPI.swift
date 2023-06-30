//
//  BaseAPI.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Alamofire
import Combine

class BaseAPI<T: TargetType> {
    typealias AnyPublisherResult<M> = AnyPublisher<M?, APIError>
    typealias FutureResult<M> = Future<M?, APIError>
    
    private let networking: AFNetworking
    
    init(networking: AFNetworking = AFNetworking()) {
        self.networking = networking
    }
    
    func fetch<M: Decodable>(target: T, responseClass: M.Type) -> AnyPublisherResult<M> {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let body = buildBody(body: target.body)
        let targetPath = buildPath(param: target.params)
        let url = target.baseURL.desc + targetPath
        
        return FutureResult<M> { promise in
            self.networking.session.request(url,
                                            method: method,
                                            parameters: body,
                                            headers: headers,
                                            requestModifier: { $0.timeoutInterval = TIME_OUT })
                .validate(statusCode: 200..<500)
                .responseDecodable(of: SuccessResponse<M>.self) { response in
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else { return promise(.failure(.General)) }
                        if statusCode >= 200 && statusCode < 300 {
                            promise(.success(value.data))
                        } else {
                            if let data = response.data {
                                do {
                                    let error = try JSONDecoder().decode(FailureResponse.self, from: data)
                                    promise(.failure(APIError(rawValue: error.error.errorCode) ?? .General))
                                } catch {
                                    promise(.failure(.Decode_Failed))
                                }
                            }
                        }
                    case .failure(let error):
                        guard !error.isTimeout else { return promise(.failure(.Time_Out)) }
                        guard !error.isConnectedToTheInternet else { return promise(.failure(.No_Network)) }
                        return promise(.failure(.General))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
//    func uploadFile(body: PresignLinkResponse, fileData: Data, fileName: String, fileType: FileType) -> AnyPublisherResult<Void> {
//        return FutureResult<Void> { promise in
//            self.networking.session.upload(multipartFormData: { multipartFromData in
//                multipartFromData.append(self.upwrapStringData(string: body.fields.bucket), withName: "bucket")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.contentType), withName: "Content-Type")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.contentDisposition), withName: "Content-Disposition")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.key), withName: "key")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.xAmzAlgorithm), withName: "X-Amz-Algorithm")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.xAmzCredential), withName: "X-Amz-Credential")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.xAmzDate), withName: "X-Amz-Date")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.policy), withName: "Policy")
//                multipartFromData.append(self.upwrapStringData(string: body.fields.xAmzSignature), withName: "X-Amz-Signature")
//                multipartFromData.append(fileData, withName: "file", fileName: fileName, mimeType: fileType.mimiType)
//            }, to: URL(string: body.url)!, method: .post).response { response in
//                switch response.result {
//                case .success:
//                    return promise(.success(()))
//                case .failure(let error):
//                    guard !error.isTimeout else { return promise(.failure(.Time_Out)) }
//                    guard !error.isConnectedToTheInternet else { return promise(.failure(.No_Network)) }
//                    return promise(.failure(.General))
//                }
//            }
//        }.eraseToAnyPublisher()
//    }

}
