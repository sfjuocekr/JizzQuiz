package ui;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * @author Sjoer van der Ploeg
 */

class Display extends Sprite
{
	private var textFields:Array<TextField> = new Array<TextField>();
	private var normalFormat:TextFormat = new TextFormat("Arial", 32, 0xffff00);
	private var timer:TextField = new TextField();
	
	public var time(null, set):Int = 0;
	
	public function new(_width:Int, _height:Int)
	{
		super();
		
		addFields(_width, _height);
	}
	
	private function addFields(_width:Int, _height:Int)
	{
		for (_i in 0...12)
		{
				textFields[_i] = new TextField();
				textFields[_i].setTextFormat(normalFormat);
				textFields[_i].text = "";
				textFields[_i].x = 0;
				textFields[_i].y = _i * 40;
				textFields[_i].width = _width;
			addChild(textFields[_i]);
		}
		
			timer.setTextFormat(normalFormat);
			timer.text = "Time remaining: " + Std.string(5 - time);
			timer.x = _width - 32 - timer.textWidth;
			timer.y = 40;
			timer.width = timer.textWidth;
			timer.visible = false;
		addChild(timer);
	}
	
	private function set_time(_time:Int):Int
	{
		if (!timer.visible)
			timer.visible = true;
		else if (_time == -1)
		{
			timer.visible = false;
			
			return time = 0;
		}
		
		timer.text = "Time remaining: " + Std.string(5 - _time);
		
		return time = _time;
	}
	
	private function clear()
	{
		for (_field in textFields)
			if (_field.text != "")
				_field.text = "";
	}
	
	public function set(_textArray:Array<String>, ?_size:Int = 32, ?_fields:Array<Int>)
	{
		clear();
		
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