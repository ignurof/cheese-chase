extends Node2D

export (Resource) var enemy

onready var start_pos = get_parent().get_node("Map/EnemySpawn").position
onready var end_pos = get_parent().get_node("Player").position
onready var nav = get_parent().get_node("Map/Navigation2D")
onready var map = get_parent().get_node("Map/Navigation2D/TileMap")

var spawnedEnemies : int = 0
var enemyList : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var _spawnTimer = $SpawnTimer.connect("timeout", self, "enemySpawner")
	var _aiTimer = $AITimer.connect("timeout", self, "updateAI")

func enemySpawner() -> void:
	var e = enemy.instance()
	add_child(e)
	e.position = start_pos
	e.goal = end_pos
	e.nav = nav
	spawnedEnemies += 1
	enemyList.append(e)
	
	if spawnedEnemies >= 2:
		$SpawnTimer.stop()
		$AITimer.start()

func updateAI() -> void:
	var currentPos = get_parent().get_node("Player").position
	for x in range(enemyList.size()):
		#print(enemyList[x].goal)
		enemyList[x].goal = currentPos
		enemyList[x].nav = nav # Must update nav so it updates path
