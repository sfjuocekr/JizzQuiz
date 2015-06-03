package;

import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

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
	
	public function new()
	{
		super ();

		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		newGame("capitals");
	}
	
	private function newGame(_category:String)
	{
		questions = new Questions(db.readQuestions("capitals"));
		display = new Display(questions);
		
		addChild(display);
		
		advance();
		counter.start();
	}
	
	private function endGame()
	{
		timer.reset();
		
		removeChild(display);
		
		highscores = new Highscores(db, questions.getScore(), counter.currentCount);
		addChild(highscores);
		
		counter.reset();
		
		display = null;
		questions = null;
	}
	
	private function advance()
	{
		if (questions.next()) endGame();
		else
		{
			for (_i in 0...4)
			{
				//display.textFields[_i].text = questions.get()[_i];
				
				// dirty hack to parse text
				
				display.textFields[_i].text = (_i > 0) ? Std.string(_i) + ": " + questions.get()[_i] : "What is the current capital of " + questions.get()[_i] + "?";
			}
			
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
		if (_e.keyCode == 27) Sys.exit(0);
		
		if (timer.running && timer.currentCount != 5)
		{
			switch (_e.keyCode)
			{
				case 49:
				{
					resolve(questions.get()[1]);
					
					return;
				}
				
				case 50:
				{
					resolve(questions.get()[2]);
					
					return;
				}
				
				case 51:
				{
					resolve(questions.get()[3]);
					
					return;
				}
			}
		}
	}
}