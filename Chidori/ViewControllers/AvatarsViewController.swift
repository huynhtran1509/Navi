//
//  AvatarsViewController.swift
//  Chidori
//
//  Created by NIX on 15/9/26.
//  Copyright © 2015年 nixWork. All rights reserved.
//

import UIKit
import RealmSwift
import Navi

class AvatarsViewController: UICollectionViewController {

    var realm: Realm!

    lazy var users: Results<User> = {
        return self.realm.objects(User).sorted("createdUnixTime", ascending: false)
        }()

    private let avatarCellID = "AvatarCell"

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()

        title = "Avatars"

        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerNib(UINib(nibName: avatarCellID, bundle: nil), forCellWithReuseIdentifier: avatarCellID)
        collectionView!.alwaysBounceVertical = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCollectionView:", name: Config.Notification.newUsers, object: nil)
    }

    // MARK: Actions

    func updateCollectionView(notification: NSNotification) {
        collectionView?.reloadData()
    }

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showProfile" {

            let vc = segue.destinationViewController as! ProfileViewController
            vc.user = sender as? User
        }
    }

    // MARK: - UICollectionView

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return users.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(avatarCellID, forIndexPath: indexPath) as! AvatarCell

        return cell
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        configureCell(cell as! AvatarCell, atIndexPath: indexPath)
    }

    private func configureCell(cell: AvatarCell, atIndexPath indexPath: NSIndexPath) {

        let user = users[indexPath.item]
        let userAvatar = UserAvatar(userID: user.userID, avatarStyle: squareAvatarStyle)

        cell.configureWithAvatar(userAvatar)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let user = users[indexPath.item]
        performSegueWithIdentifier("showProfile", sender: user)
    }
}

