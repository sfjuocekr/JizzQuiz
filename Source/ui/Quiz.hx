package ui;

import game.Database;
import game.Questions;
import openfl.display.Sprite;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import ui.Display;

/**
 * @author Sjoer van der Ploeg
 */

class Quiz extends Sprite
{
	private var timer:Timer = new Timer(1000, 6);
	private var counter:Timer = new Timer(1000, 0);
	private var db:Database = new Database();
	private var questions:Questions = null;
	private var display:Display = null;
	private var quizType:String = null;
	private var callback:Dynamic->Void = null;
	
	/**
	 * Initialize a new Quiz game.
	 * 
	 * @param	_display	Reference to the main Display object.
	 * @param	_callback	Callback funtion to pass the players score to.
	 * @param	_type		The database table to retreive the questions from.
	 */
	public function new(_display:Display, _callback:Dynamic->Void, ?_type:String = "capitals")
	{
		super();
		
		display = _display;
		callback = _callback;
		quizType = _type;
		
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		timer.addEventListener(TimerEvent.TIMER, onTimer);
		
		newGame();
	}
	
	/**
	 * Start a new game.
	 */
	private function newGame()
	{
		questions = new Questions(db.readQuestions(quizType));
		
		advance();
		counter.start();
	}
	
	public function exitGame()
	{
		timer.reset();
		counter.reset();
		
		display.time = -1;
	}
	
	/**
	 * End the currently running game.
	 */
	private function endGame()
	{
		timer.reset();
		
		var _fails:String = "";
		
		for (_fail in questions.fails)
			_fails = (_fails == "") ? _fail : (questions.fails.indexOf(_fail) != questions.fails.length - 1) ? _fails + ", " + _fail : _fails + " and " + _fail;
		
		if (_fails.length != 0)
			_fails = _fails.charAt(0).toUpperCase() + _fails.substring(1) + ".";
		
		var _score = ((db.readQuestions("capitals").length * 5) - counter.currentCount) * questions.score;
		
		display.set(["", "Your score is: " + Std.string(_score), "", (_fails == "") ? "" : (questions.fails.length > 1) ? "FAILS: " + _fails: "FAILED: " + _fails, "", "Press enter to continue..."], [1, 3, 5], 20, [3]);
		display.time = -1;
		
		callback(_score);
		
		counter.reset();
	}
	
	/**
	 * Advance to the next question or end the game if all questions have been resolved.
	 */
	private function advance()
	{
		if (questions.next())
			endGame();
		else
		{
			display.set(parseText(questions.get()));
			
			timer.start();
			
			display.time = 0;
		}
	}
	
	/**
	 * Function to parse the text into a readable question.
	 * 
	 * @param	_question	The question and answer options to be modified.
	 * @return				The modified text to be shown to the player.
	 */
	private function parseText(_question:Array<String>): Array<String>
	{
		for (_index in 0..._question.length)
			switch (quizType)
			{
				case "capitals": _question[_index] = (_index > 0) ? Std.string(_index) + ": " + _question[_index] : "What is the current capital of " + _question[_index] + "?";
			}
		
		_question.insert(1, "");
		
		return _question;
	}
	
	/**
	 * Function to pass the chosen answer to be resolved to the question object.
	 * 
	 * @param	_option		The answer option to resolve.
	 */
	public function resolve(_option:Int)
	{
		if (counter.running)
		{
			questions.resolve((_option == 0 || timer.currentCount >= 5) ? "" : questions.get()[_option]);
			
			timer.reset();
			advance();
		}
	}
	
	/**
	 * Update the time remaining on screen.
	 * 
	 * @param	_event		The TimerEvent object.
	 */
	private function onTimer(_event:TimerEvent)
	{
		if (counter.running)
			display.time = timer.currentCount;
		else
			display.time = -1;
	}
	
	/**
	 * The user did not respond on time, advance to the next question.
	 * 
	 * @param	_event		The TimerEvent object.
	 */
	private function onTimerComplete(_event:TimerEvent)
	{
		resolve(0);
	}
}