BEGIN TRANSACTION;
DROP TABLE IF EXISTS "App_Info";
CREATE TABLE "App_Info" (
Version CHAR DEFAULT "VER1.0",
BackLight INTEGER DEFAULT 80,
SHOWMEANING INTEGER DEFAULT 1,
Difficulty_VeryEasy INTEGER DEFAULT 90,
Difficulty_Easy INTEGER DEFAULT 80,
Difficulty_Good INTEGER DEFAULT 70,
Difficulty_Hard INTEGER DEFAULT 60);
INSERT INTO "App_Info" VALUES('VER1.0',80,1,90,80,70,60);
COMMIT;