package;

/**
 * ...
 * @author Sjoer van der Ploeg
 */

class Questions
{
	private var questions:Array<Array<String>> = new Array<Array<String>>();
	private var choices:Array<String> = new Array<String>();
	private var question:String;
	private var answer:String;
	private var score:Int = 0;
	
	public function new(_questions:Array<Array<String>>)
	{
		questions = _questions.copy();
		
		questions.push(["", "", "", ""]);
	}
	
	public function next(): Bool
	{
		if (questions.length != 0) set(questions.shift());
		
		return (questions.length == 0);
	}
	
	public function getScore(): Int
	{
		return score;
	}
	
	public function resolve(_input:String)
	{
		if (_input == null) score -= 2;
		else (_input == answer) ? score += 2 : score -= 1;
	}
	
	public function get(): Array<String>
	{
		return [question, choices[0],  choices[1],  choices[2]];
	}
	
	private function set(_question:Array<String>)
	{
		question = _question.shift();
		answer = _question[0];
		
		randomize(_question);
		
		choices = _question.copy();
	}
	
	private function randomize(_answers:Array<Dynamic>)
	{
		for (i in _answers.iterator())
		{
			_answers.insert(Std.random(_answers.length), _answers.pop());
			_answers.insert(Std.random(_answers.length), _answers.shift());
		}
	}
}