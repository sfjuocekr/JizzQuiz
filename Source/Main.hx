package;

import openfl.display.Sprite;
import ui.GameController;
import openfl.events.Event;

/**
 * @author Sjoer van der Ploeg
 */

class Main extends Sprite
{
	public function new()
	{
		super();
		
		stage.addEventListener(Event.RESIZE, onResize);
		
		addChild(new GameController(stage));
	}
	
	/**
	 * Resize function.
	 * 
	 * @param	_event	The Event object.
	 */
	private function onResize(_event:Event)
	{
		var _zoom = Math.min(stage.stageWidth / 1280, stage.stageHeight / 480);
		
		stage.scaleX = _zoom;
		stage.scaleY = _zoom;
	}
}