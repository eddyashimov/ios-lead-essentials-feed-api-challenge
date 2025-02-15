//
//  FeedsImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Edil Ashimov on 7/29/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedImageMapper {
	private static var OK_200: Int { return 200 }

	private struct Root: Decodable {
		let items: [Image]
		var feed: [FeedImage] {
			return items.map { $0.item }
		}
	}

	private struct Image: Decodable {
		private let image_id: UUID
		private let image_desc: String?
		private let image_loc: String?
		private let image_url: URL

		var item: FeedImage {
			return FeedImage(id: image_id,
			                 description: image_desc,
			                 location: image_loc,
			                 url: image_url)
		}
	}

	static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData) }

		return .success(root.feed)
	}
}
