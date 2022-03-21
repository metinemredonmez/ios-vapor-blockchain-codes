//
//  BlockchainService.swift
//  App
//
//  Created by Mohammad Azam on 7/15/18.
//

import Foundation

class BlockchainService {
    
    private (set) var blockchain :Blockchain!
    
    init() {
        self.blockchain = Blockchain(genesisBlock: Block())
    }

    func resolve(completion : @escaping (Blockchain) -> ()) {
        
        let nodes = self.blockchain.nodes
        
        for node in nodes {
            
            let url = URL(string :"\(node.address)/blockchain")!
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                
                if let data = data {
                    
                    let blockchain = try! JSONDecoder().decode(Blockchain.self, from: data)
                    
                    if self.blockchain.blocks.count > blockchain.blocks.count {
                        completion(self.blockchain)
                    } else {
                        self.blockchain = blockchain
                        completion(blockchain)
                    }
                    
                }
                
            }.resume()
            
        }
        
    }
    
    func getNodes() -> [BlockchainNode] {
        return self.blockchain.nodes
    }
    
    func registerNodes(nodes :[BlockchainNode]) -> [BlockchainNode] {
        return self.blockchain.registerNodes(nodes: nodes)
    }
    
    func getNextBlock(transactions :[Transaction]) -> Block {
        
        let block = self.blockchain.getNextBlock(transactions: transactions)
        self.blockchain.addBlock(block)
        return block 
    }
    
    func getBlockchain() -> Blockchain {
        return self.blockchain
    }
    
}
