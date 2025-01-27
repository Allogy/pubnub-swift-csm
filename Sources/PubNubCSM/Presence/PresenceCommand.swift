//
//  PresenceCommand.swift
//
//  PubNub Real-time Cloud-Hosted Push API and Push Notification Client Frameworks
//  Copyright © 2020 PubNub Inc.
//  https://www.pubnub.com/
//  https://www.pubnub.com/terms
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

import PubNub

import ReSwift

public enum PresenceCommand: Action {
  public static func hereNow(
    _ request: FetchHereNowRequest,
    completion: @escaping ((Result<PresenceChannelResponseTuple, Error>) -> Void) = { _ in }
  ) -> ThunkAction {
    return ThunkAction { dispatch, _, service in
      dispatch(PresenceActionType.fetchingHereNow(request))

      service()?.fetchHereNow(request) { result in
        switch result {
        case let .success(response):
          dispatch(PresenceActionType.hereNowRetrieved(
            presenceByChannelId: response.channels,
            totalOccupancy: response.totalOccupancy,
            totalChannels: response.totalChannels
          )
          )
          completion(.success((
            presenceByChannelId: response.channels,
            totalOccupancy: response.totalOccupancy,
            totalChannels: response.totalChannels
          )
          ))
        case let .failure(error):
          dispatch(PresenceActionType.errorFetchingHereNow(error))
          completion(.failure(error))
        }
      }
    }
  }

  public static func fetchPresenceState(
    _ request: FetchPresenceStateRequest,
    completion: @escaping ((Result<PresenceStateResponseTuple, Error>) -> Void) = { _ in }
  ) -> ThunkAction {
    return ThunkAction { dispatch, _, service in
      dispatch(PresenceActionType.fetchingPresenceState(request))

      service()?.fetchPresenceState(request) { result in
        switch result {
        case let .success(response):
          dispatch(PresenceActionType.presenceStateRetrieved(
            userId: request.uuid,
            stateByChannelId: response
          ))
          completion(.success((
            userId: request.uuid,
            stateByChannelId: response
          )))
        case let .failure(error):
          dispatch(PresenceActionType.errorFetchingPresenceState(error))
          completion(.failure(error))
        }
      }
    }
  }
}
