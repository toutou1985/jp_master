CREATE TABLE game_result
(
	id integer NOT NULL,
	word_id integer,
	right_num integer,
	wrong_num integer
);


CREATE TABLE level
(
	id integer NOT NULL,
	mission_id integer,
	level_no integer,
	game_status integer,
	test_status integer,
	game_word_id integer,
	test_word_id integer
);


CREATE TABLE mission
(
	id integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	mission_no integer,
	-- 0:未完成
	-- 1:正在
	-- 2:已经完成
	game_status integer DEFAULT 0,
	test_status integer
);


CREATE TABLE test_result
(
	id integer NOT NULL,
	word_id integer,
	right_num integer,
	wrong_num integer
);


CREATE TABLE word
(
	id integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	kanji VARCHAR,
	kana VARCHAR,
	chinese_means VARCHAR,
	mission_id integer,
	level_id integer,
	rem_num integer
);



