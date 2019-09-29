/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct GetMilestone : Codable {
	let cropHeight : Int?
	let dateofShipment : String?
	let dryingDate : String?
	let growthStartDate : String?
	let harvestDate : String?
	let qualityCheck : String?
	let routes : String?
	let sowingdate : String?
	let storageLocation : String?
	let tempStorage : Int?

	enum CodingKeys: String, CodingKey {

		case cropHeight = "cropHeight"
		case dateofShipment = "dateofShipment"
		case dryingDate = "dryingDate"
		case growthStartDate = "growthStartDate"
		case harvestDate = "harvestDate"
		case qualityCheck = "qualityCheck"
		case routes = "routes"
		case sowingdate = "sowingdate"
		case storageLocation = "storageLocation"
		case tempStorage = "tempStorage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cropHeight = try values.decodeIfPresent(Int.self, forKey: .cropHeight)
		dateofShipment = try values.decodeIfPresent(String.self, forKey: .dateofShipment)
		dryingDate = try values.decodeIfPresent(String.self, forKey: .dryingDate)
		growthStartDate = try values.decodeIfPresent(String.self, forKey: .growthStartDate)
		harvestDate = try values.decodeIfPresent(String.self, forKey: .harvestDate)
		qualityCheck = try values.decodeIfPresent(String.self, forKey: .qualityCheck)
		routes = try values.decodeIfPresent(String.self, forKey: .routes)
		sowingdate = try values.decodeIfPresent(String.self, forKey: .sowingdate)
		storageLocation = try values.decodeIfPresent(String.self, forKey: .storageLocation)
		tempStorage = try values.decodeIfPresent(Int.self, forKey: .tempStorage)
	}

}
