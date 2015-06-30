package;

import openfl.display.Sprite;
import ui.GameController;

/**
 * @author Sjoer van der Ploeg
 */

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new GameController(stage));
	}
}