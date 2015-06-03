package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Sjoer van der Ploeg
 */

class Display extends Sprite
{
	private var questions:Questions;
	public var textFields:Array<TextField> = new Array<TextField>();
	private var normalFormat:TextFormat = new TextFormat("Arial", 24, 0xffff00);
	
	public function new(_questions:Questions)
	{
		super();
		
		questions = _questions;
		
		for (_i in 0...4)
		{
			textFields[_i] = new TextField();
			textFields[_i].setTextFormat(normalFormat);
			textFields[_i].x = 0;
			textFields[_i].y = _i * 32;
			textFields[_i].text = questions.get()[_i];
			
			addChild(textFields[_i]);
		}
	}
}