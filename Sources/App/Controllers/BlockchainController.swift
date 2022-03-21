//
//  BlockchainController.swift
//  App
//
//  Created by Mohammad Azam on 7/15/18.
//

import Foundation
import Vapor
import HTTP

class BlockchainController {
    
    private (set) var blockchainService :BlockchainService
    
    init() {
        self.blockchainService = BlockchainService() 
    }
    
    func resolve(req :Request) -> Future<Blockchain> {
        
        let promise :EventLoopPromise<Blockchain> = req.eventLoop.newPromise()
        blockchainService.resolve {
            promise.succeed(result: $0)
        }
        
        return promise.futureResult
    }
    
    func getNodes(req :Request) -> [BlockchainNode] {
        return self.blockchainService.getNodes() 
    }
    
    func registerNodes(req :Request, nodes :[BlockchainNode]) -> [BlockchainNode] {
        return self.blockchainService.registerNodes(nodes :nodes)
    }
    
    func mine(req :Request, transaction :Transaction) -> Block {
        return self.blockchainService.getNextBlock(transactions :[transaction])
    }
    
    func getBlockchain(req :Request) -> Blockchain {
        return self.blockchainService.getBlockchain()
    }
    
    func greet(req :Request) -> Future<String> {
        
        return Future.map(on: req) { () -> String in
            return "Welcome to Blockchain"
        }
        
    }
    
}
