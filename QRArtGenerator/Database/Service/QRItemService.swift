//
//  QRItemService.swift
//  QRArtGenerator
//
//  Created by Quang Ly Hoang on 01/07/2023.
//

import Foundation
import RealmSwift

class QRItemService {
    // MARK: - Singleton
    static let shared = QRItemService()
    
    
    // MARK: Init
    private init() {}
    
    
    // MARK: - Variables
    private var qrNotificationkey: NotificationToken?
    
    
    // MARK: - Functions
    func getQRItems() -> [QRItem] {
        do {
            let realm = try Realm()
            let data = realm.objects(QRItemDB.self).sorted(by: \.createdDate, ascending: false)
            return data.compactMap({ $0.convertToDetailItem() })
        } catch {
            return []
        }
    }
    
    func saveNewQR(_ item: QRDetailItem) {
        let object = item.convertToDB()
        FileManagerUtil.shared.saveImage(image: item.qrImage, name: object.ID)
        do {
            let realm = try Realm()
            try realm.write({
                realm.add(object.copyObject(), update: .all)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteQR(_ item: QRItem) {
        do {
            let realm = try Realm()
            try realm.write({
                if let object = realm.object(ofType: QRItemDB.self, forPrimaryKey: item.id) {
                    realm.delete(object)
                    FileManagerUtil.shared.deleteImage(name: item.id)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setObserver(onChange: (([QRItem]) -> Void)?) {
        do {
            let realm = try Realm()
            let data = realm.objects(QRItemDB.self).sorted(by: \.createdDate, ascending: false)
            qrNotificationkey = data.observe { changeSet in
                switch changeSet {
                case .initial:
                    onChange?(data.compactMap({ $0.convertToDetailItem() }))
                case .update(_, _, let insertions, _):
                    if !insertions.isEmpty {
                        onChange?(data.compactMap({ $0.convertToDetailItem() }))
                    }
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
