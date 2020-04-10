package;

import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	override public function create() {
		var text = new FlxText(10, 10, 100, "Hello, World!");
		add(text);
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
