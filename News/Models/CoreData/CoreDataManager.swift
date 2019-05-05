//
//  CoreDataManager.swift
//  News
//
//  Created by Jianfang Li on 3/25/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    //MARK: - Private Memebers -
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "RssModels")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                debugPrint("\(error)")
            }
        })
        return container
    }()
    
    fileprivate var completion: ClosureWithBool?
    
    //MARK: - Public Memebers -
    
    static var shared = CoreDataManager()
    
    //MARK: - Lifetime -
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Methods -
    
    ///
    /// This will add news to favorites or remove from favorites
    ///
    /// - Parameter news: the news to be added or removed
    /// - Parameter completion: called when adding or deleting completed
    ///
    func saveFavorites(with news: News, completion: @escaping ClosureWithBool) {
    
        let managedContext = self.persistentContainer.viewContext
        self.completion = completion
        
        if let favorites = fetchFavorite(with: news, inManagedContext: managedContext) {
            
            if favorites.count != 0 {
                
                delete(favorites)
                
                return
            }
            
            let favorite = Favorites(context: managedContext)
            
            favorite.title = news.title
            favorite.url = news.link
            favorite.isFavorite = true
            
            self.saveContext()
        }
    }
    
    ///
    /// This will fetch favorites from news
    ///
    /// - Parameter news: the fetched news
    /// - Parameter managedContext: the managed context
    ///
    func fetchFavorite(with news: News, inManagedContext managedContext: NSManagedObjectContext? = nil) -> [Favorites]? {
        
        let context = managedContext ?? self.persistentContainer.viewContext
        
        if let title = news.title, let url = news.link  {
            
            let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
            
            request.predicate = NSPredicate(format: "title == %@ && url == %@", title, url)
            
            do {
                
                let items = try context.fetch(request)
                return items
                
            } catch {
                debugPrint("\(error)")
                return nil
            }
        }
        
        return nil
    }
    
    ///
    /// This will save changes to core database
    ///
    private func saveContext (isDeleted: Bool = false) {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
                
                if let completion = self.completion {
                    completion(isDeleted)
                }
                
            } catch {
                debugPrint("\(error)")
            }
        }
    }
    
    ///
    /// This will delete news from favorites
    ///
    /// - Parameter favorites: the favorites to be removed
    ///
    private func delete(_ favorites: [Favorites]) {
        
        for item in favorites {
            
            let managedContext = self.persistentContainer.viewContext
            
            managedContext.delete(item)
        }
        
        saveContext(isDeleted: true)
    }
}
