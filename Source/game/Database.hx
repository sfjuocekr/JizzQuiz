package game ;

import sys.db.Connection;
import sys.db.ResultSet;
import sys.db.Sqlite;

/**
 * @author Sjoer van der Ploeg
 */
 
class Database
{
	private static var db:Connection;
	
	/**
	 * Creates a connection to the game database, which holds the scores and questions.
	 * 
	 * The connection reference is static, the class can be reused freely.
	 */
	public function new()
	{
		if (db == null)
			db = Sqlite.open("Assets/game.db");
	}
	
	/**
	 * Reads the whole table from the database as a 2D array of strings.
	 * 
	 * @param	_table	Table name.
	 * @param	_cols	Requested collums.
	 */
	public function readQuestions(_table:String): Array<Array<String>>
	{
		var _request:ResultSet = db.request("SELECT * FROM " + _table + " ORDER BY RANDOM()");
		var _result:Array<Array<String>> = new Array<Array<String>>();
		
		for (_row in _request)
			_result.push([_row.question, _row.correct,  _row.wrong1,  _row.wrong2]);
		
		return _result;
	}
	
	/**
	 * Read highscores from the database.
	 * 
	 * @param	_limit	The number of scores to fetch.
	 */
	public function readScores(?_limit:Int = 10): Array<Array<String>>
	{
		var _request:ResultSet = db.request("SELECT name, score FROM scores ORDER BY score DESC LIMIT " + Std.string(_limit));
		var _result:Array<Array<String>> = new Array<Array<String>>();
		
		for (row in _request)
			_result.push([row.name, row.score]);
		
		return _result;
	}
	
	/**
	 * Write the score to the database, returns true if the score beats the current best..
	 * 
	 * @param	_name	The players name.
	 * @param	_score	The players score.
	 * @result	True when the score is the new highscore.
	 */
	public function writeScore(_name:String, _score:Int): Bool
	{
		var _result:Bool = (Std.parseInt(readScores(1)[0][1]) < _score);
		
		db.request("INSERT INTO scores(name, score) VALUES ('" + _name + "', " + _score + ")");
		
		return _result;
	}
}