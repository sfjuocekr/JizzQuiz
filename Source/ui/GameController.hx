package ui;

import game.Database;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.utils.Timer;
import ui.Display;
import ui.GameController;
import openfl.events.TimerEvent;

/**
 * @author Sjoer van der Ploeg
 */

class GameController extends Sprite
{
	private var db:Database = new Database();
	private var display:ui.Display = null;
	private var game:Quiz = null;
	private var timer:Timer = new Timer(1000, 10);
	
	public function new(_stage:Stage)
	{
		super ();
		
		stage = _stage;
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		
		addDisplay();
	}
	
	private function onResize(_e:Event)
	{
		var _zoom = Math.min(stage.stageWidth / 1280, stage.stageHeight / 480);
		
		stage.scaleX = _zoom;
		stage.scaleY = _zoom;
	}
	
	private function addDisplay()
	{
		if (display != null)
			removeChild(display);
			
			display = new Display(stage.stageWidth, stage.stageHeight);
			display.set(["", "", "", "", "", "Press enter to start a new game or space to view highscores!"]);
		addChild(display);
	}
	
	private function onKeyDown(_event:KeyboardEvent)
	{
		switch (_event.keyCode)
		{
			case 13: enterKey();
			case 27: escapeKey();
			case 32: spaceKey();
			case 49: sendOption(1);
			case 50: sendOption(2);
			case 51: sendOption(3);
			
			default: trace(_event.keyCode);
		}
	}
	
	private function onTimerComplete(_event:TimerEvent)
	{
		if (game == null)
			addDisplay();
	}
	
	private function enterKey()
	{
		if (game == null)
		{
				game = new Quiz(display, callback, "capitals");
			addChild(game);
		}
	}
	
	private function escapeKey()
	{
		if (game != null)
			exitGame();
		else if (game == null)
		{
			removeChild(display);
			
			Sys.exit(0);
		}
	}
	
	private function spaceKey()
	{
		if (!timer.running && game == null )
		{
			timer.start();
			
			showScores();
		}
		else if (game == null)
		{
			timer.reset();
			
			addDisplay();
		}
	}
	
	private function showScores()
	{
		var _scores:Array<String> = new Array<String>();
		var _scoresArray:Array<Array<String>> = db.readScores();
		
		for (_index in 0..._scoresArray.length)
			_scores.push(Std.string(_index + 1) + ": " + _scoresArray[_index][0] + " " + _scoresArray[_index][1] );
		
		_scores.unshift("");
		_scores.unshift("Highscores:");
		
		display.set(_scores);
	}
	
	private function exitGame()
	{
		removeChild(game);
			game = null;
		
		addDisplay();
	}
	
	private function sendOption(_option:Int)
	{
		if (game != null)
			game.resolve(_option);
	}
	
	private function callback()
	{
		exitGame();
	}
}