package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Sjoer van der Ploeg
 */

class Highscores extends Sprite
{
	private var textFields:Array<TextField> = new Array<TextField>();
	private var normalFormat:TextFormat = new TextFormat("Arial", 24, 0xffff00);
	
	public function new(_db:Database, _score:Int, _time:Int)
	{
		super();
		
		var _name = "Sjoer";
		
		if (_score != null)
		{
			//ask player for name
			
			if (writeScore(_db, _name, _score))
			{
				//show player he is the new numbah one
			}
		}
	}
	
	private function writeScore(_db:Database, _name:String, _score:Int): Bool
	{
		return _db.writeScore(_name, _score);
	}
	
	private function readScores(_db:Database)
	{
		var _scores = _db.readScores(10);
		
		for (_i in _scores)
		{
			var _index = textFields.push(new TextField());
			
			textFields[_index - 1].setTextFormat(normalFormat);
			textFields[_index - 1].x = 0;
			textFields[_index - 1].y = 64 + _index * 32;
			textFields[_index - 1].text = _index + ":\t" + _i[0] + "\t\t\t\t\t" + _i[1];
			
			addChild(textFields[_index - 1]);
		}
	}
}