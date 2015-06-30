package game;

/**
 * @author Sjoer van der Ploeg
 */

class Questions
{
	private var questions:Array<Array<String>> = new Array<Array<String>>();
	private var choices:Array<String> = new Array<String>();
	private var question:String = null;
	private var answer:String = null;
	
	public var fails(get, null):Array<String> = new Array<String>();
	public var score(get, null):Int = 0;
	
	/**
	 * @param	_questions	The array of questions.
	 */
	public function new(_questions:Array<Array<String>>)
	{
		questions = _questions.copy();
		
		questions.push(["", "", "", ""]);
	}
	
	/**
	 * @return	The next question.
	 */
	public function next(): Bool
	{
		if (questions.length != 0) set(questions.shift());
		
		return (questions.length == 0);
	}
	
	/**
	 * @return	The players score.
	 */
	private function get_score(): Int
	{
		return score;
	}
	
	/**
	 * @return	The answers the player answered wrong.
	 */
	private function get_fails(): Array<String>
	{
		return fails;
	}
	
	/**
	 * Checks if the given input was correct and modifies the score accordingly.
	 * 
	 * @param	_input	The chosen answer.
	 */
	public function resolve(_input:String)
	{
		if (_input != answer)
		{
			fails.push(question);
			
			score -= (_input == null) ? 2 : 1;
		}
		else
			score += 2;
	}
	
	/**
	 * @return	The current question and its answer options.
	 */
	public function get(): Array<String>
	{
		return [question, choices[0],  choices[1],  choices[2]];
	}
	
	/**
	 * @param	_question	The next question and its answer options.
	 */
	private function set(_question:Array<String>)
	{
		question = _question.shift();
		answer = _question[0];
		
		randomize(_question);
		
		choices = _question.copy();
	}
	
	/**
	 * @param	_answers	The array to be randomized.
	 */
	private function randomize(_answers:Array<Dynamic>)
	{
		for (i in _answers.iterator())
		{
			_answers.insert(Std.random(_answers.length), _answers.pop());
			_answers.insert(Std.random(_answers.length), _answers.shift());
		}
	}
}