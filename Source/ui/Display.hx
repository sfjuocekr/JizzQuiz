package ui;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * @author Sjoer van der Ploeg
 */

class Display extends Sprite
{
	private var normalFormat:TextFormat = new TextFormat("Arial", 32, 0xffff00, null, null, null, null, null, TextFormatAlign.LEFT, null, null, null, null);
	private var textFields:Array<TextField> = new Array<TextField>();
	private var timer:TextField = null;
	
	public var time(null, set):Int = 0;
	
	/**
	 * Initialize the display object with 12 TextField objects.
	 * 
	 * @param	_width	The width of the TextField objects.
	 */
	public function new(_width:Int)
	{
		super();
		
		addFields(_width);
	}
	
	private function addFields(_width:Int)
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
		
			timer = new TextField();
			timer.setTextFormat(normalFormat);
			timer.text = "Time remaining: " + Std.string(10 - time);
			timer.x = _width - 32 - timer.textWidth;
			timer.y = 40;
			timer.width = timer.textWidth;
			timer.visible = false;
		addChild(timer);
	}
	
	/**
	 * @param	_time	The elasped time.
	 * @return
	 */
	private function set_time(_time:Int):Int
	{
		if (!timer.visible && _time != -1)
			timer.visible = true;
		else if (_time == -1)
		{
			timer.visible = false;
			
			return time = 0;
		}
		
		timer.text = "Time remaining: " + Std.string(5 - _time);
		
		return time = _time;
	}
	
	/**
	 * Clears textfields from their current text.
	 */
	private function clear()
	{
		for (_field in textFields)
			if (_field.text != "")
				_field.text = "";
	}
	
	/**
	 * Sets the text to be shown on screen.
	 * 
	 * @param	_textArray		Array of text to be shown on screen.
	 * @param	_centerFields	Items on screen to be centered.
	 * @param	_size			Size of the text.
	 * @param	_sizeFields		Items on screen to be changed in size.
	 */
	public function set(_textArray:Array<String>, ?_centerFields:Array<Int>, ?_size:Int = 32, ?_sizeFields:Array<Int>)
	{
		clear();
		
		_textArray = _textArray.slice(0, 12);
		
		for (_index in 0..._textArray.length)
		{
			textFields[_index].text = _textArray[_index];
			textFields[_index].setTextFormat(normalFormat);
		}
		
		if (_centerFields != null)
			for (_field in _centerFields)
			{
				var _customFormat:TextFormat = textFields[_field].getTextFormat();
					_customFormat.align = TextFormatAlign.CENTER;
					
				textFields[_field].setTextFormat(_customFormat);
			}
		
		if (_sizeFields != null)
			for (_field in _sizeFields)
			{
				var _customFormat:TextFormat = textFields[_field].getTextFormat();
					_customFormat.size = _size;
					
				textFields[_field].setTextFormat(_customFormat);
			}
	}
}