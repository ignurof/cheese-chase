extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Map.generate()
	$Map.fixMap()
	$Enemies.startEnemySpawner()
	var _cheesePickup = $Cheese.connect("pickup", self, "nextMap")

func nextMap() -> void:
	# Stop gamelogic
	# Remove enemies
	# Respawn player
	# Regenerate map
	# Start gamelogic
	pass
