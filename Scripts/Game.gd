extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause() # First level
	mainMenu()
	var _scoreChange = $HUD.connect("scoreChange", self, "next")
	var _startButton = $Menu/StartButton.connect("pressed", self, "start")
	var _quitButton = $Menu/QuitButton.connect("pressed", self, "quit")

func mainMenu() -> void:
	$HUD.hide()
	$Menu.show()

func quit() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func start() -> void:
	$HUD.show()
	$Menu.hide()
	# Start first game, without enemies
	mapTransition()
	$Player.position = $Map/PlayerSpawn.position
	$Player.show()
	$Map.generate()
	$Map.fixMap()
	$Cheese.spawn()

func next() -> void:
	pause() # First cleanup the map
	mapTransition()
	$Player.position = $Map/PlayerSpawn.position
	$Player.show()
	$Map.generate()
	$Map.fixMap()
	$Cheese.spawn()
	
	$Enemies.maxSpawnedEnemies = ($Enemies.maxSpawnedEnemies * 2)
	$Enemies/SpawnTimer.start()

func pause() -> void:
	$Player.hide()
	$Cheese.hide()
	$Enemies/SpawnTimer.stop()
	$Enemies/AITimer.stop()
	$Enemies.despawnEnemies()


func mapTransition() -> void:
	# Map transition
	$HUD/ColorRect.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$HUD/ColorRect.hide()
