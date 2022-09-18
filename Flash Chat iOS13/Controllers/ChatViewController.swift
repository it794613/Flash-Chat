//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var message: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMesssages()
    }
    
    func loadMesssages(){
        message = []
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            
            self.message = []
            if let e = error {
                print("there is no \(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String {
                                
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.message.append(newMessage)
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text ,let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data:
                [K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970]){(error) in
                if let e=error {
                    print("there is error \(e)")
                }else{
                    print("data sended!")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""                        
                    }
                }
            }
        }
    }
}

//MARK: -tableView

extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCheck = message[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            as! MessageCell
        
        //현재 로그인한사람이 보낸 채팅이라면, 왼쪽에 유 아바타를 숨겨야한다.
        cell.Lable.text = messageCheck.body
        if messageCheck.sender == Auth.auth().currentUser?.email{
            cell.avatar.isHidden = false
            cell.youAvatar.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.Lable.textColor = UIColor(named: K.BrandColors.purple)
        }else{
            cell.avatar.isHidden = true
            cell.youAvatar.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.Lable.textColor = UIColor(named: K.BrandColors.blue)
        }
        
        return cell
    }
}

//MARK: -UITableDelegate

extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
