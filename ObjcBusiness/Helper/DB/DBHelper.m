//
//  DBHelper.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/7/26.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "YouQuUserInfo.h"
@interface DBHelper ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end
@implementation DBHelper
static NSString *const userTableName = @"USERTABLE";

+ (DBHelper *)shareInstance {
    static DBHelper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance dbQueue];
    });
    return instance;
}

- (FMDatabaseQueue *)dbQueue {
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId == nil) {
        return nil;
    }
    
    if (!_dbQueue) {
        [self moveDBFile];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask, YES);
        NSString *const roungCloud = @"YouQU";
        NSString *library = [[paths objectAtIndex:0] stringByAppendingPathComponent:roungCloud];
        NSString *dbPath = [library
                            stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"YouQUDB%@",
                             [RCIMClient sharedRCIMClient]
                             .currentUserInfo.userId]];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_dbQueue) {
            [self createUserTableIfNeed];
        }
    }
    return _dbQueue;
}

- (void)closeDBForDisconnect {
    self.dbQueue = nil;
}

/**
 苹果审核时，要求打开itunes sharing功能的app在Document目录下不能放置用户处理不了的文件
 2.8.9之前的版本数据库保存在Document目录
 从2.8.9之前的版本升级的时候需要把数据库从Document目录移动到Library/Application Support目录
 */
- (void)moveDBFile {
    NSString *const rongIMDemoDBString = @"YouQUDB";
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"YouQU"];
    NSArray<NSString*> *subPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    [subPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:rongIMDemoDBString]) {
            [self moveFile:obj fromPath:documentPath toPath:libraryPath];
        }
    }];
}

- (void)moveFile:(NSString*)fileName fromPath:(NSString*)fromPath toPath:(NSString*)toPath{
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* srcPath = [fromPath stringByAppendingPathComponent:fileName];
    NSString* dstPath = [toPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:nil];
}


//创建用户存储表
- (void)createUserTableIfNeed {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (![self isTableOK:userTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY "
            @"KEY autoincrement, userid text,name text, "
            @"portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL =
            @"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
//        if (![self isTableOK:groupTableName withDB:db]) {
//            NSString *createTableSQL =
//            @"CREATE TABLE GROUPTABLEV2 (id integer PRIMARY KEY autoincrement, "
//            @"groupId text,name text, portraitUri text,inNumber text,maxNumber "
//            @"text ,introduce text ,creatorId text,creatorTime text, isJoin "
//            @"text, isDismiss text)";
//            [db executeUpdate:createTableSQL];
//            NSString *createIndexSQL =
//            @"CREATE unique INDEX idx_groupid ON GROUPTABLEV2(groupId);";
//            [db executeUpdate:createIndexSQL];
//        }
        
//        if (![self isTableOK:friendTableName withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE FRIENDSTABLE (id integer "
//            @"PRIMARY KEY autoincrement, userid "
//            @"text,name text, portraitUri text, status "
//            @"text, updatedAt text, displayName text)";
//            [db executeUpdate:createTableSQL];
//            NSString *createIndexSQL =
//            @"CREATE unique INDEX idx_friendsId ON FRIENDSTABLE(userid);";
//            [db executeUpdate:createIndexSQL];
//        } else if (![self isColumnExist:@"displayName" inTable:friendTableName withDB:db]) {
//            [db executeUpdate:@"ALTER TABLE FRIENDSTABLE ADD COLUMN displayName text"];
//        }
        
//        if (![self isTableOK:blackTableName withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE BLACKTABLE (id integer PRIMARY "
//            @"KEY autoincrement, userid text,name text, "
//            @"portraitUri text)";
//            [db executeUpdate:createTableSQL];
//            NSString *createIndexSQL =
//            @"CREATE unique INDEX idx_blackId ON BLACKTABLE(userid);";
//            [db executeUpdate:createIndexSQL];
//        }
        
//        if (![self isTableOK:groupMemberTableName withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE GROUPMEMBERTABLE (id integer "
//            @"PRIMARY KEY autoincrement, groupid text, "
//            @"userid text,name text, portraitUri text)";
//            [db executeUpdate:createTableSQL];
//            NSString *createIndexSQL = @"CREATE unique INDEX idx_groupmemberId ON "
//            @"GROUPMEMBERTABLE(groupid,userid);";
//            [db executeUpdate:createIndexSQL];
//        }
    }];
}

- (BOOL)isTableOK:(NSString *)tableName withDB:(FMDatabase *)db {
    BOOL isOK = NO;
    
    FMResultSet *rs =
    [db executeQuery:@"select count(*) as 'count' from sqlite_master where "
     @"type ='table' and name = ?",
     tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count) {
            isOK = NO;
        } else {
            isOK = YES;
        }
    }
    [rs close];
    
    return isOK;
}

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user {
    NSString *insertSql =
    @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql, user.userId, user.name, user.portraitUri];
    }];
}

//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId {
    __block RCUserInfo *model = nil;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs =
        [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?", userId];
        while ([rs next]) {
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
        }
        [rs close];
    }];
    return model;
}

@end
