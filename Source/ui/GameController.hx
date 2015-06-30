package ui;

import game.Database;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import ui.Display;
import ui.GameController;

/**
 * @author Sjoer van der Ploeg
 */

class GameController extends Sprite
{
	private var timer:Timer = new Timer(1000, 10);
	private var db:Database = new Database();
	private var display:Display = null;
	private var game:Quiz = null;
	private var playerName:TextInput = null;
	private var score:Int = null;
	
	/**
	 * Initialize a new GameController, this class manages user input and everything that is to be shown on screen.
	 * 
	 * @param	_stage	The primary DisplayObject, required for keyboard input and to get the dimensions of the application window.
	 */
	public function new(_stage:Stage)
	{
		super();
		
		stage = _stage;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		
			display = new Display(stage.stageWidth);
		addChild(display);
		
		setDisplay();
	}
	
	/**
	 * Resets the display to show the default text, also resets the timer if it was running.
	 * 
	 * @param	_highest	If true, show a message to the player that he now has the highest score!
	 */
	private function setDisplay(?_highest:Bool = false)
	{
		if (timer.running)
			timer.reset();
			
		display.time = -1;
		
		display.set([(_highest) ? "Congratulations, you are the new number one!" : "", "", "", "", "", "Press enter to start a new game or space to view highscores!"], [0, 5]);
	}
	
	/**
	 * The primary keyboard input dispatcher.
	 * 
	 * @param	_event	The KeyboardEvent object.
	 */
	private function onKeyDown(_event:KeyboardEvent)
	{
		if (playerName != null && _event.keyCode != 13)
			playerName.insertKey(_event);
		else
			switch (_event.keyCode)
			{
				case 13: enterKey();
				case 27: escapeKey();
				case 32: spaceKey();
				case 49: sendOption(1);
				case 50: sendOption(2);
				case 51: sendOption(3);
			}
	}
	
	/**
	 * Trigger for the timer to reset the display when finished.
	 * 
	 * @param	_event	The TimerEvent object.
	 */
	private function onTimerComplete(_event:TimerEvent)
	{
		if (game == null)
			setDisplay();
	}
	
	/**
	 * Handles the RETURN key.
	 */
	private function enterKey()
	{
		if (game == null)
		{
				game = new Quiz(display, callback, "capitals");
			addChild(game);
		}
		else if (game != null && score != null)
		{
			if (playerName == null)
			{
				display.set(["", "", "", "", "Please enter your name:"], [4]);
				
					playerName = new TextInput(6, stage.stageWidth);
				addChild(playerName);
			}
			else if (playerName.text.length > 0)
				writeScore();
		}
	}
	
	/**
	 * Handles the ESCAPE key.
	 */
	private function escapeKey()
	{
		if (game != null)
			exitGame();
		else if (game == null && !timer.running)
		{
			removeChild(display);
			
			Sys.exit(0);
		}
		else if (game == null && timer.running)
			setDisplay();
	}
	
	/**
	 * Handles the SPACE bar.
	 */
	private function spaceKey()
	{
		if (!timer.running && game == null )
			showScores();
		else if (timer.running && game == null)
			setDisplay();
	}
	
	/**
	 * Shows the highscores on screen.
	 */
	private function showScores()
	{
		var _scores:Array<String> = new Array<String>();
		var _scoresArray:Array<Array<String>> = db.readScores();
		
		for (_index in 0..._scoresArray.length)
			_scores.push(Std.string(_index + 1) + ": " + _scoresArray[_index][0] + " - " + _scoresArray[_index][1] );
		
		_scores.unshift("");
		_scores.unshift("- HIGHSCORES -");
		
		var _centered:Array<Int> = new Array<Int>();
		
		for (_index in 0..._scores.length)
			_centered.push(_index);
			
		display.set(_scores, _centered);
		
		timer.start();
	}
	
	/**
	 * Write the new score to the database.
	 */
	private function writeScore()
	{
		setDisplay(db.writeScore(playerName.text, score));
		
		removeChild(playerName);
		
		playerName = null;
		score = null;
		game = null;
	}
	
	/**
	 * Exits the current runnning game.
	 */
	private function exitGame()
	{
		game.exitGame();
		
		removeChild(game);
			game = null;
		
		setDisplay();
	}
	
	/**
	 * Sends key presses to the input field.
	 * 
	 * @param	_option		The pressed key.
	 */
	private function sendOption(_option:Int)
	{
		if (game != null)
			game.resolve(_option);
	}
	
	/**
	 * Callback for the game to pass the players score.
	 * 
	 * @param	_score		The score to be writen to the database.
	 */
	private function callback(_score:Int)
	{
		score = _score;
	}
}