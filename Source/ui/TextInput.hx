package ui;

import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * @author Sjoer van der Ploeg
 */

class TextInput extends Sprite
{
	private var normalFormat:TextFormat = new TextFormat("Arial", 32, 0xffff00, null, null, null, null, null, TextFormatAlign.CENTER, null, null, null, null);
	private var inputField:TextField = new TextField();
	
	public var text(get, null):String;
	
	/**
	 * Initialize the text input field.
	 * 
	 * @param	_yPos	Location of the input field.
	 * @param	_width	Width of the input field.
	 */
	public function new(_yPos:Int, _width:Int) 
	{
		super();
		
			inputField.type = TextFieldType.INPUT;
			inputField.defaultTextFormat = normalFormat;
			inputField.selectable = false;
			inputField.text = "";
			inputField.y = _yPos * 40;
			inputField.width = _width;
		addChild(inputField);
	}
	
	/**
	 * Translates keyboard input from the player to readable text and puts it into the TextField.
	 * 
	 * @param	_event	The KeyboardEvent object.
	 */
	public function insertKey(_event:KeyboardEvent)
	{
		switch (_event.keyCode)
		{
			case 8: inputField.text = inputField.text.substr(0, inputField.text.length - 1);
			case 27: inputField.text = "";
			
			default:
				if (_event.charCode >= 32 && _event.charCode <= 126)
					inputField.text += String.fromCharCode(_event.charCode);
		}
	}
	
	/**
	 * @return	Returns the text entered in the TextField.
	 */
	private function get_text(): String
	{
		return text = inputField.text;
	}
}