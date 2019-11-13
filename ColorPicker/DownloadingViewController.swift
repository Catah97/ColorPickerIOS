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
    @IBOutlet weak var btnDownload: UIButtonBorderView!
    
    @IBAction func clickBtnStartDownloading(_ sender: UIButton) {
        startDownloading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDownload.setBackgroundColor(color: UIColor.black, forState: .highlighted)
        progressLayout.isHidden = true
    }
    
    private func startDownloading() {
        guard let urlStr = urlTextField.text else {
            return
        }
        guard let url = URL(string: urlStr) else {
            print("Bad url \(urlStr)")
            Alerdialog.showUiAlert("Error", text: "Bad url", controler: self)
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
    
    func startPhotoViewController(_ image : UIImage) {
        let photoPick = self.storyboard?.instantiateViewController(withIdentifier: "PhotoPicker") as! PhotoPicker
        photoPick.image = image
        self.navigationController?.pushViewController(photoPick, animated: true)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download done")
        var wrong = true
        let error = downloadTask.error
        if
            let response = downloadTask.response,
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response.mimeType, mimeType.hasPrefix("image"),
            error == nil,
            let data = try? Data(contentsOf: location),
            let image = UIImage(data: data){
            print("Download succesfull")
            print("File path \(location)")
            
            wrong = false
            DispatchQueue.main.async {
                self.startPhotoViewController(image)
            }
        }
        DispatchQueue.main.async {
            if (wrong) {
                self.showDownloadErrorAlert()
            }
            self.progressLayout.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Download done")
        if let er = error {
            print(er)
            DispatchQueue.main.async {
                self.showDownloadErrorAlert()
                self.progressLayout.isHidden = true
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("totalBytesWritten \(totalBytesWritten)")
        print("totalBytesExpectedToWrite \(totalBytesExpectedToWrite)")
        let current = Float(totalBytesWritten)
        let max = Float(totalBytesExpectedToWrite)
        let percentDownloaded = current / max
        print("setProgress \(percentDownloaded)")
        DispatchQueue.main.async {
            self.setProgress(percent: percentDownloaded)
        }
    }
    
    private func setProgress(percent: Float) {
        self.progressLabel.text = "\(percent * 100)%"
        self.progressView.progress = percent
    }
    
    private func showDownloadErrorAlert() {
        Alerdialog.showUiAlert("Error", text: "Something went wrong :(", controler: self)
    }
}
