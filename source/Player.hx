package;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite {
	static inline var SPEED:Float = 200;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		loadGraphic(AssetPaths.player__png, true, 16, 16);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);

		drag.x = 1600;
		drag.y = 1600;

		setSize(8, 8);
		offset.set(4, 4);
	}

	override function update(elapsed:Float) {
		updateMovement();

		super.update(elapsed);
	}

	function updateMovement() {
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down) {
			up = false;
			down = false;
		}

		if (left && right) {
			right = false;
			left = false;
		}

		if (up || down || left || right) {
			var newAngle:Float = 0;

			if (up) {
				facing = FlxObject.UP;

				newAngle = -90;

				if (left) {
					newAngle -= 45;
				} else if (right) {
					newAngle += 45;
				}
			} else if (down) {
				facing = FlxObject.DOWN;

				newAngle = 90;

				if (left) {
					newAngle += 45;
				} else if (right) {
					newAngle -= 45;
				}
			} else if (left) {
				facing = FlxObject.LEFT;

				newAngle = 180;
			} else if (right) {
				facing = FlxObject.RIGHT;

				newAngle = 0;
			}

			velocity.set(SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}

		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
			switch (facing) {
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
				case FlxObject.UP:
					animation.play("u");
				case FlxObject.DOWN:
					animation.play("d");
			}
		}
	}
}
