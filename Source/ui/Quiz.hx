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
	private var db:Database = new Database();
	private var questions:Questions;
	private var display:Display;
	private var timer:Timer = new Timer(1000, 5);
	private var counter:Timer = new Timer(1000, 0);
	
	private var quizType:String;
	private var callback:Void->Void;
	
	public function new(_display:Display, _callback:Void->Void, ?_type:String = "capitals")
	{
		super ();
		
		display = _display;
		callback = _callback;
		quizType = _type;
		
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		timer.addEventListener(TimerEvent.TIMER, onTimer);
		
		newGame();
	}
	
	private function newGame()
	{
		questions = new Questions(db.readQuestions(quizType));
		
		advance();
		counter.start();
	}
	
	private function endGame()
	{
		timer.reset();
		
		var _fails:String = "";
		
		for (_fail in questions.getFails())
			_fails = (_fails == "") ? _fail : (questions.getFails().indexOf(_fail) != questions.getFails().length - 1) ? _fails + ", " + _fail : _fails + " and " + _fail;
		
		_fails = _fails.charAt(0).toUpperCase() + _fails.substring(1) + ".";
		
		var _score = ((db.readQuestions("capitals").length * 5) - counter.currentCount) * questions.getScore();
		
		display.set(["Your score is: " + Std.string(_score), "", "You failed at:", "", _fails, "", "", "Press escape to continue..."], 20, [4]);
		display.time = -1;
		
		//TODO: ask the player for his name upon launching the game
		db.writeScore("Sjoer", _score);
		
		counter.reset();
	}
	
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
	
	public function resolve(_option:Int)
	{
		if (counter.running)
		{
			timer.reset();
			
			questions.resolve((_option == null) ? null : questions.get()[_option]);
			
			advance();
		}
	}
	
	private function onTimer(_event:TimerEvent)
	{
		display.time = timer.currentCount;
	}
	
	private function onTimerComplete(_event:TimerEvent)
	{
		resolve(null);
	}
}