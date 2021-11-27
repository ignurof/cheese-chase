extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.position = $Map/PlayerSpawn.position
	$Map.generate()
	$Map.fixMap()
	$Enemies/SpawnTimer.start()
	var _cheesePickup = $Cheese.connect("pickup", self, "nextMap")

func nextMap() -> void:
	# Remove enemies
	get_tree().call_group("enemies", "queue_free")
	# Respawn player
	$Player.position = $Map/PlayerSpawn.position
	# Regenerate map
	$Map.generate()
	$Map.fixMap()
	# Start gamelogic
	$Enemies/SpawnTimer.start()
	### TODO: Gör så att för varje ny level man tar sig till, öka mängden fiender
