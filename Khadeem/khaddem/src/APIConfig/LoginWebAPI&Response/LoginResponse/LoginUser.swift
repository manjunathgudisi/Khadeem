/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct LoginUser : Codable {
	let hasL2Auth : Bool?
	let deleted : Bool?
	let _id : String?
	let username : String?
	let fullname : String?
	let email : String?
	let role : LoginRole?
	let title : String?
	let accessToken : String?
	let lastOnline : String?

	enum CodingKeys: String, CodingKey {

		case hasL2Auth = "hasL2Auth"
		case deleted = "deleted"
		case _id = "_id"
		case username = "username"
		case fullname = "fullname"
		case email = "email"
		case role = "role"
		case title = "title"
		case accessToken = "accessToken"
		case lastOnline = "lastOnline"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		hasL2Auth = try values.decodeIfPresent(Bool.self, forKey: .hasL2Auth)
		deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		role = try values.decodeIfPresent(LoginRole.self, forKey: .role)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
		lastOnline = try values.decodeIfPresent(String.self, forKey: .lastOnline)
	}

}
