//* 1. Adventure Gaming - Inventory
// Fitness Cards Inventory
var adventureGamingFitnessCardsInventoryPath = `/inventory/adventure-gaming/fitness-cards/`;
var card0 = {
    name:"man-o-muscle",
    imgUrl:"/manomuscle.jpg",
    muscleGroup:["glutes","quads"]
}

//* https://yipli-project.firebaseio.com/inventory/adventure-gaming/fitness-cards
/*

[ {
  "imgUrl" : "manomuscle.jpg",
  "muscleGroup" : [ "glutes", "quads" ],
  "name" : "man-o-muscle"
} ]

*/

//* Curriculum will be picked up when the player "Starts Journey"

var adventureGamingCurriculumInventoryPath = `/inventory/adventure-gaming/curriculums/c0`;

var class0 = {
    "battle-zone-player-action" : "SQUAT_AND_KICK",
"battle-zone-time": 65,
"battle-zone-total-enemies":4,
  
    "fitness-cards" : [ 0 ],
    "challenge-zone" : {
      "min-action-count" : 20,
      "player-action" : "JUMP",
      "time" : 45
    },
    "intensity-level" : 1,
    "route-1" : {
      "elevated-terrains" : 1,
      "high-knee" : 25,
      "jumps" : 10,
      "max-time" : 300,
      "run-distance" : 100,
      "skier-jack" : 100,
      "water-areas" : 1
    },
    "route-2" : {
      "elevated-terrains" : 0,
      "high-knee" : 0,
      "jumps" : 10,
      "max-time" : 115,
      "run-distance" : 100,
      "skier-jack" : 0,
      "water-areas" : 0
    },
    "target-calories-to-be-burnt" : 340,
    "total-time" : 36000,
    "victory-zone" : {
      "player-action" : "MALASANA",
      "time" : 10,
      "time-out" : 30
    }
  }


/*

[ {
  "battle-zone" : {
    "player-action" : "SQUAT_AND_KICK",
    "time" : 65,
    "total-enemies" : 4
  },
  "challenge-zone" : {
    "ChallengeZoneMinActionCount" : 20,
    "ChallengeZonePlayerAction" : "JUMP",
    "time" : 45
  },
  "fitness-cards" : [ 0 ],
  "intensity-level" : 1,
  "route-1" : {
    "elevated-terrains" : 1,
    "high-knee" : 25,
    "jumps" : 10,
    "max-time" : 300,
    "run-distance" : 100,
    "skier-jack" : 100,
    "water-areas" : 1
  },
  "route-2" : {
    "elevated-terrains" : 0,
    "high-knee" : 0,
    "jumps" : 10,
    "max-time" : 115,
    "run-distance" : 100,
    "skier-jack" : 0,
    "water-areas" : 0
  },
  "target-calories-to-be-burnt" : 340,
  "total-time" : 36000,
  "victory-zone" : {
    "player-action" : "MALASANA",
    "time" : 10,
    "time-out" : 30
  }
} ]


*/
  
//* Logic for picking the correct curriculum to be decided

//* World 1 will be picked up when the player "Starts Journey"

var adventureGamingWorldsInventoryPath = `/inventory/adventure-gaming/worlds/world0`;
var chapter0 = {
    "artworkImageUrl" : "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
    "chapterTitle" : "S.O.S",
};
var chapter1 = {
  "artworkImageUrl" : "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
  "chapterTitle" : "Chapter One",
};
//
var world0 = {
    name:"World Zero!",
    artworkImageUrl:"",
    storyline:[chapter0, chapter1]
}

/*

{
"worlds:
{
  "0" : {
    "artworkImageUrl" : "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
    "name" : "World Zero!",
    "storyline" : [ {
      "artworkImageUrl" : "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
      "chapterTitle" : "Chapter Zero"
    }, {
      "artworkImageUrl" : "http://dummyimage.com/250x250.png/5fa2dd/ffffff",
      "chapterTitle" : "Chapter One"
    } ]
  }
}


*/

// 2. Adventure Gaming - Start Journey

var userId = "";
var playerId = "";

// agp: Adventure Gaming Progress
// p0: storyline index
var adventureGamingStatsPath = `/agp/${userId}/${playerId}/world0/p0`;
var playerProfileData = {};
var initialClassRef = getInitialClassRef(playerProfileData);
// e.g.: /inventory/adventure-gaming/curriculum/c0/class0
var adventureGamingStatInit = {
    "next-chapter-ref":"/inventory/adventure-gaming/worlds/world0/storyline/0",
    "next-class-ref":initialClassRef,
    "current-index":0
};

var getInitialClassRef = function(playerProfileData){
  return "/inventory/adventure-gaming/curriculum/c0/0";
}
//* 3. Adventure Gaming - Progress

var getNextClassRef = function(playerProfileData, previousStats){
  var x = 1;
  return "/inventory/adventure-gaming/curriculum/c0/" + x;
}

var previousStats = {}; // Player's previous statistics data
// to be handled in "Cloud Functions!"
var nextClassRef = getNextClassRef(playerProfileData, previousStats );
var adventureGamingStats = {
  "next-chapter-ref":"/inventory/adventure-gaming/worlds/world0/storyline/4",
  "next-class-ref":nextClassRef,
  "current-index":2,
  "total-fp":500,
  "average-rating":4,
  "progress-stats":[{
          "chapter-ref":"/inventory/adventure-gaming/worlds/world0/storyline/1",
          "class-ref":"/inventory/adventure-gaming/curriculum/c0/class2",
          "rating":4.5,
          "chap-fp":250,
          "chap-c":124,
          "chap-t":350,
          "count":3
      },{
          "chapter-ref":"/inventory/adventure-gaming/worlds/world0/storyline/2",
          "class-ref":" /inventory/adventure-gaming/curriculum/c0/class5",
          "rating":3,
          "chap-fp":250,
          "chap-c":124,
          "chap-t":350,
          "count":2
      }]
};

/** 
 * 
 * Cloud functions
 * 
 * - Game Data to external path
 */

 var gameDataPath = "/player-game-data/<<UserId>>/<<PlayerId>>/<<gameId>>"; 

 /*
 * GameLib changes - API changes for the save/retrieve data for game and player
 */
 /*
 * 
 * Game level aggregates from Cloud Functions
 * 
 * 
 * Overall Player Aggregates from Cloud Functions
 * 
 * Overall Player Action Count Aggregates from Cloud Functions
 * - Add the action count aggregation
 * 
*/

/*

App -> Game
Interface
Game Logic:
  User -> Current Player -> Player

  Chapter to launch from index 

  Game data ref stored in Games 
    gameDataRef -> "/inventory/adventure-gaming/worlds/world0"
  
  Chapter Index: gameDataRef + "/storyline/{chapter-index}"

*/
var yipliAppToGameData = {
  "uId":"",
  "pId":"",
  "pName":"",
  "pDOB":"",
  "pWt":"",
  "pHt":"",
  "mId":"",
  "mMac":"",
  "agpIdx":"", // Player's current index
  "chapIdx":"" // Current chapter index [ Will be ]
}

/*

{
- Check if class is fresh or repeat.
- if fresh, associate next class detials to the journey-progress and only increment the count feild of the class data.
- if repeat, only increment the count field of the class data.
- Also post session-details like any normal game(game-data will be kept here).
- Take a decision to upgrade/downgrade the class intensity
}

Class completion

Event:
  Game stores to the "stage-session-bucket"

[Changes below]


*/
enum YipliGameSessionType {
  ADVENTURE_GAMING,
  FITNESS_GAMING
}
var adventureGamingSessionData = {
  "type":"ADVENTURE_GAMING", // New Change
  "age" : 21,
  "calories" : 0,
  "duration" : 9,
  "fitness-points" : 70,
  "game-id" : "eggcatcher",
  "height" : "120",
  "intensity" : "low",
  "mac-address" : "54:6C:0E:20:A0:3B",
  "mat-id" : "-M3HgyBMOl9OssN8T6sq",
  "player-actions" : {
    "LEFTMOVE" : 3,
    "RIGHTMOVE" : 4
  },
  "xp":154, // xpToAdd
  "fitness-cards":[1,3],
  "agp":{    // New change
      "next-chap-ref":"",
      "next-class-ref":"",
      "completed-chap-index":2,
      "rating":2.5
  },
  "game-data":null,
  "player-id" : "-M2iG0P2_UNsE2VRcU5P",
  "points" : 30,
  "timestamp" : 1600762114581,
  "user-id" : "F9zyHSRJUCb0Ctc15F9xkLFSH5f1"
};


// Output 
var nextChapterRef = "/inventory/adventure-gaming/worlds/world0/storyline/{currentChapterIndex + 1}";
var nextClassRef = "/inventory/adventure-gaming/curriculums/c0/class0";
 //* Calculate the total XP for the player

var playerDataToUpdate = {
  "total-xp": calculateTotalXp(adventureGamingSessionData.agp.xp)
}


var processedAdventureGamingSessionData = {
  "next-chapter-ref":nextChapterRef,
  "next-class-ref":nextClassRef,
  "current-index":calculateCurrentIdx(),
  "total-fp":calculateTotalFp(),
  "average-rating":calculateAverateRating(),
  "progress-stats":   [{
      "chapter-ref":"/inventory/adventure-gaming/worlds/world0/storyline/2",
      "class-ref":" /inventory/adventure-gaming/curriculums/c0/class5",
      "rating": adventureGamingSessionData.agp.rating,
      "chap-fp":250,
      "chap-c":124,
      "chap-t":350,
      "count":calculateCount()
  }]
}

var calculateTotalXp = function(xpToAdd){

}

var calculateCurrentIdx = function(){

}

var calculateTotalFp = function(){

}


var calculateAverateRating = function(){

}


var calculateCount = function(){

}