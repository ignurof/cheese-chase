extends Node2D

export (Resource) var enemy

onready var start_pos = get_parent().get_node("Map/EnemySpawn").position
onready var end_pos = get_parent().get_node("Player").position
onready var nav = get_parent().get_node("Map/Navigation2D")
onready var map = get_parent().get_node("Map/Navigation2D/TileMap")

var spawnedEnemies : int = 0
var maxSpawnedEnemies : int = 1
var enemyList : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _spawnTimer = $SpawnTimer.connect("timeout", self, "enemySpawner")
	var _aiTimer = $AITimer.connect("timeout", self, "updateAI")

func enemySpawner() -> void:
	var e = enemy.instance()
	add_child(e)
	e.position = start_pos
	#e.goal = end_pos
	e.nav = nav
	spawnedEnemies += 1
	enemyList.append(e)
	$AITimer.start()
	
	if spawnedEnemies >= maxSpawnedEnemies:
		$SpawnTimer.stop()

func updateAI() -> void:
	get_tree().call_group("enemies", "update")

func despawnEnemies() -> void:
	enemyList = [] # Reset array
	spawnedEnemies = 0
	# Remove enemies
	get_tree().call_group("enemies", "queue_free")
