//
//  Downloader.swift
//  K1ModManager
//
//  Created by Lilly on 05/05/2022.
//

import Foundation

// Download mod files in the background

func downloadMod(from src: String) {
    let r1Url = URL(string: "https://chomikuj.pl/farato/Dokumenty/modfiles/\(src).zip")!
    
    guard let r1 = try? String(contentsOf: r1Url, encoding: String.Encoding.utf8) else {
        showAlert("Couldn't find mod for id \(src)")
        return
    }
    
    guard let r1Range: Range<String.Index> = r1.range(of: #"\d{10}(?=.z)"#, options: .regularExpression) else {
        showAlert("Couldn't locate FileId for \(src)\n\n\(r1)")
        return
    }
    
    let fileId  = r1[r1Range]
    let r2Token = "&__RequestVerificationToken=b%2BsiLdIH65m5AVq2Xk7B0VHudOFB%2BrddgeMKqSSaYhNNEHULqRRQbNWkLDrPB%2FT%2F2aCx0RIJUz3w5UVygR6StTykyxlNxGWo3iWYC5eIjljDNHYcM5AL9MbQagSUy6YKs%2BkyXg%3D%3D"
    let r2Data = "fileId=\(fileId)\(r2Token)".data(using: .utf8)
    let r2Url  = URL(string: "https://chomikuj.pl/action/License/Download")!
    var r2     = URLRequest(url: r2Url)
    
    r2.httpMethod = "POST"
    r2.httpBody   = r2Data
    r2.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
    r2.setValue("ChomikSession=d3fb23c6-430d-456c-b729-bbb72fefaf99; __RequestVerificationToken_Lw__=w8xQ4U9IcdB71uD/zSxUsJXuEQQOsI1Dogfg9d4xN3p0xxRp/wTg+oqiDdqIYGZfhEfswCKnlA47H0IBDt53LrdOy7oCNzKdOdp/lTwQAn/Zw++5skZFvLLcktKreTD7mZMZTQ==; rcid=3; guid=999f1623-f0ea-4497-8775-50832b6258df;", forHTTPHeaderField: "Cookie")
    
    var response  = Data()
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: r2) { (data, responsee, error) in
        if let data = data {
            response = data
        }
        
        semaphore.signal()
    }.resume()
    
    semaphore.wait()
    
    guard let json = try? JSONSerialization.jsonObject(with: response, options: []) as? Dictionary<String, Any?> else {
        showAlert("File for \(src) was not found")
        return
    }
    
    guard let redirect = json["redirectUrl"] as? String else {
        showAlert("Couldn't authenticate download for \(src)")
        return
    }
    
    let r3 = URL(string: redirect)!
    
    guard let mod = try? Data(contentsOf: r3) else {
        showAlert("Couldn't download mod files from \(r3.path)")
        return
    }
    
    NSData(data: mod).write(toFile: kModDir + src + ".zip", atomically: true)
    
    guard FileManager.default.fileExists(atPath: kModDir + src + ".zip") else {
        showAlert("Couldn't to download mod files to \(kModDir + src + ".zip")")
        return
    }
    
    FileManager.default.changeCurrentDirectoryPath(kModDir)
    
    shell("/usr/bin/unzip", ["-o", "-qq", kModDir + src + ".zip"])
    rm(kModDir + src + ".zip")
}
