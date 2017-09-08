//
//  DataSourceProtocol.h
//  Weather_App
//
//  Created by user1 on 2017/8/29.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DataSource <NSObject>

@optional;

- (NSUInteger) numberOfSections;

- (NSUInteger) numberOfItemsInSection:(NSUInteger)section;

- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

- (id) supplementaryItemOfKind:(NSString *)kind inSection:(NSUInteger)section;

/*
 /// A push-driven stream of values that represent every modification
	/// of the dataSource contents immediately after they happen.
	var changes: Signal<DataChange, NoError> { get }
 
	var numberOfSections: Int { get }
 
	func numberOfItemsInSection(_ section: Int) -> Int
 
	func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any?
 
	func item(at indexPath: IndexPath) -> Any
 
	/// Asks the dataSource for the original dataSource that contains the item at the given indexPath,
	/// and the indexPath of that item in that dataSource.
	///
	/// If the receiving dataSource is composed of other dataSources that provide its items,
	/// this method finds the dataSource responsible for providing an item for the given indexPath,
	/// and this method is called on it recursively.
	///
	/// Otherwise, this method simply returns the receiving dataSource itself and the given indexPath unchanged.
	func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath)
 */
@end

@protocol DataChangeTarget <NSObject>

@optional;

- (void) ds_performBatchChanges:(void(^)())batchChanges;

- (void) ds_deleteItemsAt:(NSArray<NSIndexPath *>*)indexPaths;

- (void) ds_delete:(NSArray<NSNumber *>*)sections;

- (void) ds_insertItemsAt:(NSArray<NSIndexPath *>*)indexPaths;

- (void) ds_insert:(NSArray<NSNumber *>*)sections;

- (void) ds_moveItemAt:(NSIndexPath *)oldIndexPath to:(NSIndexPath *)newIndexPath;

- (void) ds_moveSection:(NSUInteger)oldSection to:(NSUInteger)newSection;

- (void) ds_reloadData;

- (void) ds_reloadItemsAt:(NSArray<NSIndexPath *>*)indexPaths;

/*
 /// A target onto which different types of dataChanges can be applied.
 /// When a dataChange is applied, the target transitions from reflecting
 /// the state of the corresponding dataSource prior to the dataChange
 /// to reflecting the dataSource state after the dataChange.
 ///
 /// `UITableView` and `UICollectionView` are implementing this protocol.
 public protocol DataChangeTarget {
 
	func ds_performBatchChanges(_ batchChanges: @escaping ()->())
 
	func ds_deleteItems(at indexPaths: [IndexPath])
 
	func ds_deleteSections(_ sections: [Int])
 
	func ds_insertItems(at indexPaths: [IndexPath])
 
	func ds_insertSections(_ sections: [Int])
 
	func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath)
 
	func ds_moveSection(_ oldSection: Int, toSection newSection: Int)
 
	func ds_reloadData()
 
	func ds_reloadItems(at indexPaths: [IndexPath])
 
	func ds_reloadSections(_ sections: [Int])
 
 }
 */

@end

@protocol DataChange <NSObject>

@optional
- (void) applyTo:(id<DataChangeTarget>)target;

- (id<DataChange>) mapSections:(NSInteger(^)(NSInteger oldSection))transform;

/*
 /// A value representing a modification of a dataSource contents.
 /// - seealso: DataSource
 public protocol DataChange {
 
	/// Applies the dataChange to a given target.
	func apply(to target: DataChangeTarget)
 
	/// Returns a new dataChange of same type with its section indicies transformed
	/// by the given function.
	func mapSections(_ transform: (Int) -> Int) -> Self
 
 }
 */

@end

@protocol DataSourceObjectItemReceiver <NSObject>

@optional

- (void) ds_setItem:(id)item;

/*
 /// Implement this protocol in your `UITableViewCell` or `UICollectionView` subclass
 /// to make it receive corresponding items of the dataSource associated
 /// with a `TableViewDataSource` or a `CollectionViewDataSource`.
 /// - note: This protocol allows only settings of items of object type.
 ///   Use `DataSourceItemReceiver` protocol instead if you don't need to implement
 ///   your class in Objective-C.
 
 @objc func ds_setItem(_ item: AnyObject)

 */

@end

static void configureReceiver(id receiver,id item){

    if ([receiver conformsToProtocol:@protocol(DataSourceObjectItemReceiver)]) {
        
        [receiver ds_setItem:item];
    }
}

