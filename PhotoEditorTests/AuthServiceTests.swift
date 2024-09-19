//
//  PhotoEditorTests.swift
//  PhotoEditorTests
//
//  Created by Nurmukhanbet Sertay on 18.09.2024.
//

import XCTest
import FirebaseAuth
import GoogleSignIn
import Combine
@testable import PhotoEditor

class AuthServiceTests: XCTestCase {
    var authService: AuthService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        authService = AuthService()
        cancellables = []
    }

    override func tearDown() {
        authService = nil
        cancellables = nil
        super.tearDown()
    }

    func testSignInWithEmailSuccess() {
        let expectation = self.expectation(description: "Sign in with email success")
        
        // Mock successful sign in
        let email = "newuser@example.com"
        let password = "password123"
        
        authService.signInWithEmail(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Sign in failed with error: \(error)")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSignInWithEmailFailure() {
        let expectation = self.expectation(description: "Sign in with email failure")

        // Mock failure sign in
        let email = "invalid@example.com"
        let password = "wrongpassword"
        
        authService.signInWithEmail(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: {
                XCTFail("Sign in should have failed")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCreateProfileSuccess() {
        let expectation = self.expectation(description: "Create profile success")
        
        let randomInt = Int.random(in: 0...100)
        let email = "newuser\(randomInt)@example.com"
        let password = "password123"
        
        authService.createProfile(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Profile creation failed with error: \(error)")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testCreateProfileFailure() {
        let expectation = self.expectation(description: "Create profile failure")
        
        // Mock failure profile creation
        let email = "invalid"
        let password = ""
        
        authService.createProfile(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: {
                XCTFail("Profile creation should have failed")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSignOutSuccess() {
        let expectation = self.expectation(description: "Sign out success")
        
        // Mock successful sign out
        authService.signOut()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Sign out failed with error: \(error)")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
