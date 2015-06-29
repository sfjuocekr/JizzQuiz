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
	private var textFields:Array<TextField> = new Array<TextField>();
	private var normalFormat:TextFormat = new TextFormat("Arial", 32, 0xffff00);
	
	public function new()
	{
		super();
		
		for (_i in 0...12)
		{
				textFields[_i] = new TextField();
				textFields[_i].setTextFormat(normalFormat);
				textFields[_i].x = 0;
				textFields[_i].y = _i * 40;
				textFields[_i].width = 1280;
				textFields[_i].text = "";
			addChild(textFields[_i]);
		}
	}
	
	private function clean()
	{
		for (_field in textFields)
			if (_field.text != "")
				_field.text = "";
	}
	
	public function set(_textArray:Array<String>, ?_size:Int = 32, ?_fields:Array<Int>)
	{
		clean();
		
		for (_index in 0..._textArray.length)
		{
			textFields[_index].text = _textArray[_index];
			textFields[_index].setTextFormat(normalFormat);
		}
		
		if (_fields != null)
		{
			var _sizeFormat:TextFormat = new TextFormat("Arial", _size, 0xffff00);
			
			for (_field in _fields)
				textFields[_field].setTextFormat(_sizeFormat);
		}
	}
}