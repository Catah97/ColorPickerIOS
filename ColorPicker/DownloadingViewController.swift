//
//  DownloadingViewController.swift
//  ColorPicker
//
//  Created by Martin Beran on 13/11/2019.
//  Copyright © 2019 Martin Beran. All rights reserved.
//

import Foundation

class DownloadingViewController: UIViewController, URLSessionDownloadDelegate {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLayout: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBAction func clickBtnStartDownloading(_ sender: UIButton) {
        startDownloading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLayout.isHidden = true
    }
    
    private func startDownloading() {
        guard let urlStr = urlTextField.text else {
            return
        }
        guard let url = URL(string: urlStr) else {
            print("Bad url \(urlStr)")
            return
        }
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        let downloadTask = session.downloadTask(with: url)
        setProgress(percent: 0)
        downloadTask.resume()
        progressLayout.isHidden = false
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Complete")
        DispatchQueue.main.async {
            self.progressLayout.isHidden = true
            if let error = downloadTask.error {
                print("Download error")
                print(error)
            } else {
                print("Download done")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
        
        // update the percentage label
        DispatchQueue.main.async {
            self.setProgress(percent: percentDownloaded)
        }
    }
    
    private func setProgress(percent: Int64) {
        self.progressLabel.text = "\(percent * 100)%"
        self.progressView.progress = Float(percent)
    }
}
