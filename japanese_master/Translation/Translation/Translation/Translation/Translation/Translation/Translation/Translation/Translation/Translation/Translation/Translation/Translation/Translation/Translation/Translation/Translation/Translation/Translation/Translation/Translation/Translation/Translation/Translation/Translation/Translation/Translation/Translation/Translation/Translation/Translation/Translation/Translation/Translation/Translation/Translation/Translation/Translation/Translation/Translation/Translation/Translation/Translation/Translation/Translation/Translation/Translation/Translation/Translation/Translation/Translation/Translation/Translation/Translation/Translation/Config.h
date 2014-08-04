//
//  Config.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

typedef enum
{
    kModeTypeGame,
    kModeTypeRemeber,
}ModeType;

// ==== game
#define POINTS_KEY @"mission"
#define COMPLETED_KEY @"completed"
#define GAME_STATUS_KEY @"gameStatus"
#define TASK_KEY @"task"

#define WORD_ID_KEY @"wordID"
#define PIAN_JIA_MIN_KEY @"kanji"
#define PING_JIA_MIN_KEY @"kana"
#define CHINESE_MENNS_KEY    @"chinese"
#define WORD_IS_COMPLETE_KEY @"isComplete"
#define SINGLE_WORD_KEY @"singleWord"
#define WORD_WRONG_SUM_KEY @"wordWrongSum"
#define WORD_RIGHT_SUM_KEY @"wordRigthSum"
// ====
const static NSString *SPELL_LIST = @"あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげがざじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゃょゅ";


//DB control

#define DB_OPEN_AND_AUTOCLOSE(...) NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"translaiton.sqlite"]; \
    FMDatabase *fmdb = [FMDatabase databaseWithPath:DBPath];\
    {\
        __VA_ARGS__\
    }\
    [fmdb close];



//SelectModeViewController
#define GAMEMODE_BTN_TAG     100
#define TESTMODE_BTN_TAG     101
#define REMEMBERMODE_BTN_TAG 102
#define STATICTICS_BTN_TAG   103

//PointsCell

typedef enum
{
    kPointsStatusLock = 0,
    kPointsStatusRun = 1,
    kPointsStatusComplete = 2
}PointsStatus;

#define CELL_HEIGHT 80.0f

//PiontsTaskViewController

#define FIRST_TASK_BTN_TAG 150
#define SECOND_TASK_BTN_TAG 151
#define THIRD_TASK_BTN_TAG 152
#define FORTH_TASK_BTN_TAG 153
#define FIFTH_TASK_BTN_TAG 154

#define FIRST_TASK_BTN_NOTE_TAG 160
#define SECOND_TASK_BTN_NOTE_TAG 161
#define THIRD_TASK_BTN_NOTE_TAG 162
#define FORTH_TASK_BTN_NOTE_TAG 163
#define FIFTH_TASK_BTN_NOTE_TAG 164

#define POINT_TASK_BACK_BTN_TAG 170

//GameScreenViewController

#define GAME_SCREEN_BACK_BTN_TAG 180
#define NOTE_BTN_TAG 181
#define NEXT_BTN_TAG 182

#define INPUT_FILED_BASE_TAG 190

#define PROGRESS_ALTREVIEW_TAG  201
#define NEXT_POINTS_ALTERVIEW_TAG  202


