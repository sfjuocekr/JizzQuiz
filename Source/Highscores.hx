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
	public var textFields:Array<TextField> = new Array<TextField>();
	private var normalFormat:TextFormat = new TextFormat("Arial", 24, 0xffff00);
	
	public function new(_db:Database, _score:Int, _time:Int)
	{
		super();
		
		if (_score != null)
		{
			//ask player for name
			
			if (_db.writeScore("Ruben", ((_db.readQuestions("capitals").length * 5) - _time) * _score))
			{
				//show player he is the new numbah one
			}
		}
		
		var _scores = _db.readScores(10);
		
		for (_i in _scores)
		{
			var _index = textFields.push(new TextField());
			
			textFields[_index - 1].setTextFormat(normalFormat);
			textFields[_index - 1].x = 0;
			textFields[_index - 1].y = _index * 32;
			textFields[_index - 1].text = _index + ":\t" + _i[0] + "\t\t\t\t\t" + _i[1];
			
			addChild(textFields[_index - 1]);
		}
	}
}