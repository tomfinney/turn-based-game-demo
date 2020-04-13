package;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState {
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var coins:FlxTypedGroup<Coin>;
	var enemies:FlxTypedGroup<Enemy>;

	override public function create() {
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		super.create();
	}

	function placeEntities(entity:EntityData) {
		if (entity.name == "player") {
			player.setPosition(entity.x, entity.y);
		} else if (entity.name == "coin") {
			coins.add(new Coin(entity.x + 4, entity.y + 4));
		} else if (entity.name == "mob") {
			enemies.add(new Enemy(entity.x + 4, entity.y, REGULAR));
		} else if (entity.name == "boss") {
			enemies.add(new Enemy(entity.x + 4, entity.y, BOSS));
		}
	}

	////

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);

		enemies.forEachAlive(checkEnemyVision);

		FlxG.overlap(player, coins, playerTouchCoin);
	}

	function playerTouchCoin(player:Player, coin:Coin) {
		if (player.alive && player.exists && coin.alive && coin.exists) {
			coin.kill();
		}
	}

	function checkEnemyVision(enemy:Enemy) {
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint())) {
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		} else {
			enemy.seesPlayer = false;
		}
	}
}
