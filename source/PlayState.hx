package;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxObject;

class PlayState extends FlxState {
	var player:Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create() {
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		super.create();
	}

	function placeEntities(entity:EntityData) {
		if (entity.name == "player") {
			player.setPosition(entity.x, entity.y);
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(player, walls);
	}
}
