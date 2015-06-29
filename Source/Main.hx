package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.Lib;

/**
 * ...
 * @author Sjoer van der Ploeg
 */

class Main extends Sprite
{
	private var db:Database = new Database();
	private var questions:Questions;
	private var display:Display;
	private var timer:Timer = new Timer(1000, 5);
	private var counter:Timer = new Timer(1000, 0);
	private var highscores:Highscores;
	
	private var quizType:String = "capitals";
	
	public function new()
	{
		super ();
		
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(Event.RESIZE, onResize);
		
		display = new Display();
		addChild(display);
		
		display.set(["Press enter to start a new game!"]);
	}
	
	private function onResize(_e:Event)
	{
		var _zoom = Math.min(stage.stageWidth / 1280, stage.stageHeight / 480);
		
		stage.scaleX = _zoom;
		stage.scaleY = _zoom;
	}
	
	private function newGame(_category:String)
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
		
		display.set(["Your score is: " + Std.string(_score), "", "You failed at:", "", _fails], 20, [4]);
		
		//highscores = new Highscores(db, questions.getScore(), counter.currentCount);
		
		counter.reset();
	}
	
	private function advance()
	{
		if (questions.next())
			endGame();
		else
		{
			var _textArray:Array<String> = new Array<String>();
			
			_textArray = questions.get();
			
			for (_index in 0...4)
			{
				switch (quizType)
				{
					case "capitals": _textArray[_index] = (_index > 0) ? Std.string(_index) + ": " + _textArray[_index] : "What is the current capital of " + _textArray[_index] + "?";
				}
			}
			
			_textArray.insert(1, "");
			
			display.set(_textArray);
			
			timer.start();
		}
		
	}
	
	private function resolve(_answer:String)
	{
		timer.reset();
		
		questions.resolve(_answer);
		
		advance();
	}
	
	private function onTimer(_e:TimerEvent)
	{
		resolve(null);
	}
	
	private function onKeyDown(_e:KeyboardEvent)
	{
		trace(_e.keyCode);
		
		if (_e.keyCode == 27)
			exit();
		
		if (timer.running && timer.currentCount != 5)
			switch (_e.keyCode)
			{
				case 49: resolve(questions.get()[1]);
				case 50: resolve(questions.get()[2]);
				case 51: resolve(questions.get()[3]);
			}
		else if (_e.keyCode == 13)
			newGame("capitals");
	}
	
	private function exit()
	{
		timer.reset();
		counter.reset();
		
		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		removeChildren();
		
		db = null;
		questions = null;
		display = null;
		counter = null;
		highscores = null;
		
		// this is weird, if you do timer = null the game closes...
		timer = null;
		
		//Sys.exit(0);
	}
}