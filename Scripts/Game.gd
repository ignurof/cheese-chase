extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause() # First level
	mainMenu()
	var _scoreChange = $HUD.connect("scoreChange", self, "next")
	var _startButton = $Menu/StartButton.connect("pressed", self, "start")
	var _quitButton = $Menu/QuitButton.connect("pressed", self, "quit")
	var _playerHit = $Player.connect("gameover", self, "gameOver")

func gameOver() -> void:
	print("gameover bruv")
	$HUD.reset()
	pause()
	mainMenu()

func mainMenu() -> void:
	$HUD.hide()
	$Menu.show()
	$Menu/AnimationPlayer.play("Jam")

func quit() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func start() -> void:
	$HUD.show()
	$Menu.hide()
	# Start first game, without enemies
	firstTransition()
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
	$HUD/MapTransition.show()
	$HUD/MapTransition/AnimationPlayer.play("Size")
	yield(get_tree().create_timer(3.0), "timeout")
	$HUD/MapTransition.hide()

func firstTransition() -> void:
	$HUD/FirstTransition.show()
	yield(get_tree().create_timer(3.0), "timeout")
	$HUD/FirstTransition.hide()

## TODO: Gör en gameover när fienden går in i spelaren
