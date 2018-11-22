//
//  XMLParser.swift
//  ExchangeRates
//
//  Created by Tima on 20.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class FeedParser: NSObject, XMLParserDelegate {

    private var rateItems: [Currency] = []
    private var currentElement = ""
    private var currentCharCode: String = "" {
        didSet {
            currentCharCode = currentCharCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentScale = "" {
        didSet {
            currentScale = currentScale.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentRate = "" {
        didSet {
            currentRate = currentRate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentName: String = "" {
        didSet {
            currentName = currentName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var parserCompletionHandler: (([Currency]?, Error?) -> ())?

    func parseFeed(url: String, completionHandler: @escaping ([Currency]?, Error?) -> ()) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        switch currentElement {
        case "Currency":
            currentCharCode = ""
            currentScale = ""
            currentName = ""
            currentRate = ""
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "CharCode": currentCharCode += string
        case "Scale": currentScale += string
        case "Name": currentName += string
        case "Rate": currentRate += string
        default: break
        }
    } 

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "Currency" {
            let item = Currency(charCode: currentCharCode, scale: currentScale, name: currentName, rate: currentRate, order: rateItems.count)
            rateItems.append(item)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rateItems, nil)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserCompletionHandler?(nil, parseError)
    }
}
