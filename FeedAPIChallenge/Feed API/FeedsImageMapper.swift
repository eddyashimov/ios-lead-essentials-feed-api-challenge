//
//  FeedsImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Edil Ashimov on 7/29/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final internal class FeedImageMapper {
	private static var OK_200: Int { return 200 }

	private struct Root: Decodable {
		let items: [Image]
		var feed: [FeedImage] {
			return items.map { $0.item }
		}
	}

	private struct Image: Decodable {
		public let id: UUID
		public let description: String?
		public let location: String?
		public let url: URL

		var item: FeedImage {
			return FeedImage(id: id,
			                 description: description,
			                 location: location,
			                 url: url)
		}
	}

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData) }

		return .success(root.feed)
	}
}
