//
//  ViewController.swift
//  ShazamTest
//
//  Created by Aidin Ahmadian on 1/12/23.
//

import ShazamKit
import UIKit

class ViewController: UIViewController, SHSessionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeSong()
    }
    
    private func recognizeSong() {
        let session = SHSession()
        session.delegate = self
        
        do {
            // Getting the song
            guard let url = Bundle.main.url(forResource: "(Song name)", withExtension: "mp3") else {
                print("Failed to get the url")
                return
            }
            // Create the audio file
            let file = try AVAudioFile(forReading: url)
            
            // Audio Buffering
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length / 20)
            ) else {
                print("Failed to create a buffer")
                return
            }
            try file.read(into: buffer)
            
            // Signature Generator
            let generator = SHSignatureGenerator()
            try generator.append(buffer, at: nil)
            
            // Create our Signature
            let signature = generator.signature()
            
            // Matching Phase
            session.match(signature)
        }
        catch {
            print(error)
        }
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) {
        // Get Results
        let items = match.mediaItems
        items.forEach { item in
            print(item.title ?? "Ttile")
            print(item.artist ?? "Artist")
            print(item.artworkURL?.absoluteURL ?? "Artwork URL")
        }
    }
    
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
}

