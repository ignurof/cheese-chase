extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause() # First level
	mainMenu()
	var _scoreChange = $CanvasLayer/ViewportContainer/Viewport/HUD.connect("scoreChange", self, "next")
	var _startButton = $CanvasLayer/ViewportContainer/Viewport/Menu/StartButton.connect("pressed", self, "start")
	var _quitButton = $CanvasLayer/ViewportContainer/Viewport/Menu/QuitButton.connect("pressed", self, "quit")
	var _menuButton = $CanvasLayer/ViewportContainer/Viewport/GameOver/MenuButton.connect("pressed", self, "mainMenu")
	var _restartButton = $CanvasLayer/ViewportContainer/Viewport/GameOver/RestartButton.connect("pressed", self, "start")
	var _playerHit = $Player.connect("gameover", self, "gameOver")

func gameOver() -> void:
	print("gameover bruv")
	$CanvasLayer/ViewportContainer/Viewport/HUD.reset()
	pause()
	$CanvasLayer/ViewportContainer/Viewport/GameOver.visible = true

func mainMenu() -> void:
	$CanvasLayer/ViewportContainer/Viewport/HUD.hide()
	$CanvasLayer/ViewportContainer/Viewport/Menu.show()
	$CanvasLayer/ViewportContainer/Viewport/Menu/AnimationPlayer.play("Jam")
	$CanvasModulate.visible = false
	$CanvasLayer/ViewportContainer/Viewport/GameOver.visible = false

func quit() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func start() -> void:
	$Enemies.maxSpawnedEnemies = 1 # Reset enemy counter
	$CanvasLayer/ViewportContainer/Viewport/GameOver.visible = false
	$CanvasLayer/ViewportContainer/Viewport/HUD.show()
	$CanvasLayer/ViewportContainer/Viewport/Menu.hide()
	# Start first game, without enemies
	firstTransition()
	$Player.position = $Map/PlayerSpawn.position
	$Player.scale = Vector2(1, 1)
	$Player.show()
	$Map.generate()
	$Map.fixMap()
	$Cheese.spawn()

func next() -> void:
	pause() # First cleanup the map
	mapTransition()
	$Player.position = $Map/PlayerSpawn.position
	$Player.scale = ($Player.scale + Vector2(0.2, 0.2))
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
	$CanvasLayer/ViewportContainer/Viewport/HUD/MapTransition.show()
	$CanvasLayer/ViewportContainer/Viewport/HUD/MapTransition/AnimationPlayer.play("Size")
	yield(get_tree().create_timer(3.0), "timeout")
	$CanvasLayer/ViewportContainer/Viewport/HUD/MapTransition.hide()
	$CanvasModulate.visible = true

func firstTransition() -> void:
	$CanvasLayer/ViewportContainer/Viewport/HUD/FirstTransition.show()
	yield(get_tree().create_timer(3.0), "timeout")
	$CanvasLayer/ViewportContainer/Viewport/HUD/FirstTransition.hide()
	$CanvasModulate.visible = true

