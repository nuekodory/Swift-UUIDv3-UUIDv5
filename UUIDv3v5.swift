//
// Created by Naoki Nakamura <agent@sohzoh.com> on 2019-06-07.
// This code is in Public Domain.
//

import Foundation
import CommonCrypto


public extension UUID {

    init?(uuidVersion: Int, namespace: UUID?, name: String) {
        guard let nameData = name.data(using: .utf8) else { return nil }
        guard let namespaceInBytes = namespace?.uuid else { return nil }

        var tmpNamespaceArray = namespaceInBytes
        let namespaceInArray = UnsafeBufferPointer(start: &tmpNamespaceArray.0, count: MemoryLayout.size(ofValue: tmpNamespaceArray))
        let namespaceData = Data(buffer: namespaceInArray)
        let unifiedData = namespaceData + nameData

        var digestArray = [UInt8](repeating: 0x00, count: Int(CC_MD5_DIGEST_LENGTH))

        switch uuidVersion {
        case 3:
            _ = unifiedData.withUnsafeBytes { unsafeDataPointer in
                CC_MD5(unsafeDataPointer.baseAddress, CC_LONG(unifiedData.count), &digestArray)
            }
        case 5:
            _ = unifiedData.withUnsafeBytes { unsafeDataPointer in
                CC_SHA1(unsafeDataPointer.baseAddress, CC_LONG(unifiedData.count), &digestArray)
            }
        default:
            return nil
        }

        let digestTuple = (
                digestArray[0], digestArray[1], digestArray[2], digestArray[3], digestArray[4], digestArray[5],
                UInt8(uuidVersion * 0x10) + digestArray[6] % 0x10,
                digestArray[7],
                UInt8(0x80) + digestArray[8] % 0x40,
                digestArray[9], digestArray[10], digestArray[11], digestArray[12], digestArray[13], digestArray[14], digestArray[15]
        )
        // since MD5  has fixed length of 128 = 8 * 16 bit, access to digestArray[0...15] is guaranteed.
        // since SHA1 has fixed length of 160 = 8 * 20 bit, access to digestArray[0...20] is guaranteed.

        self = UUID(uuid: digestTuple)
    }

    struct namespace {
        // Defined in RFC4122  https://tools.ietf.org/html/rfc4122#appendix-C
        static let DNS = UUID(uuidString: "6ba7b810-9dad-11d1-80b4-00c04fd430c8")!
        static let URL = UUID(uuidString: "6ba7b811-9dad-11d1-80b4-00c04fd430c8")!
        static let OID = UUID(uuidString: "6ba7b812-9dad-11d1-80b4-00c04fd430c8")!
        static let X500 = UUID(uuidString: "6ba7b814-9dad-11d1-80b4-00c04fd430c8")!
    }
}
