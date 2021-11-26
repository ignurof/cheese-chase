extends Node

export var sceneWidth : int = 20
export var sceneHeight : int = 12

onready var nav = $Navigation2D
onready var map = $Navigation2D/TileMap

# 0 = Floor
# 1 = Wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate()

func generate() -> void:
	for x in range(sceneWidth):
		for y in range(sceneHeight):
			# Keep edges clear by adding floor tiles around the whole map
			if x == 0 or y == 0 or x == sceneWidth - 1 or y == sceneHeight - 1 or y == sceneHeight - 2:
				map.set_cell(x, y, 0)
			else:
				# one tile is 64x64px, and tilemap handles offsetting and stuff like that
				map.set_cell(x, y, 1)

