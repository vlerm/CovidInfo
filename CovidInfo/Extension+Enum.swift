//
//  Extension+Enum.swift
//  CovidInfo
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

extension UIColor {
    
    static func colorFor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    
}

extension UIView {
    
    func autolayoutAddSubview(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension UIViewController {
    
    func presentAlertControllerWithMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension URL {
    
    func get<T: Codable>(completion: @escaping (Result<T, ApiError>) -> Void) {
        let task = URLSession.shared.dataTask(with: self) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let result = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
            }
        }
        task.resume()
    }
    
}

extension ApiError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .generic:
            return NSLocalizedString("Could not retrieve data", comment: String())
        }
    }
    
}

enum ApiError: Error {
    case generic
}
