extends Node

export var sceneWidth : int = 20
export var sceneHeight : int = 12

onready var nav = $Navigation2D
onready var map = $Navigation2D/TileMap

var tileFloor : int = 0
var tileWall : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Generate a new RNG seed

func generate() -> void:
	for x in range(sceneWidth):
		for y in range(sceneHeight):
			# Keep edges clear by adding floor tiles around the whole map
			if x == 0 or y == 0 or x == sceneWidth - 1 or y == sceneHeight - 1 or y == sceneHeight - 2:
				map.set_cell(x, y, tileFloor)
			else:
				var randNum : int = randomTile()
				# one tile is 64x64px, and tilemap handles offsetting and stuff like that
				map.set_cell(x, y, randNum)

func randomTile() -> int:
	var number : int = randi() % 2
	return number

# Makes the level better
func fixMap() -> void:
	for x in range(sceneWidth):
		for y in range(sceneHeight):
			if map.get_cell(x, y) == tileFloor: # Floor
				if map.get_cell(x, y-1) == tileWall: # North
					if map.get_cell(x+1, y) == tileWall: # East
						if map.get_cell(x, y+1) == tileWall: # South
							if map.get_cell(x-1, y) == tileWall: # West
								map.set_cell(x, y-1, tileFloor)
				if map.get_cell(x, y-1) == tileWall: # North
					if map.get_cell(x+1, y) == tileWall: # East
						if map.get_cell(x-1, y) == tileWall: # West
							map.set_cell(x, y-1, tileFloor)
				if map.get_cell(x, y-1) == tileWall: # North
					if map.get_cell(x+1, y) == tileWall: # East
						if map.get_cell(x, y+1) == tileWall: # South
							if map.get_cell(x-1, y) == tileFloor: # West
								if map.get_cell(x-2, y) == tileFloor: # Westx2
									if map.get_cell(x-3, y) == tileWall: # Westx3
										map.set_cell(x-3, y, tileFloor) 
				if map.get_cell(x+1, y) == tileFloor: # East
					if map.get_cell(x, y+1) == tileFloor: # South
						if map.get_cell(x-1, y) == tileWall: # West
							map.set_cell(x-1, y, tileFloor)
				#End floor check
				#Start wall check
			else: # Wall
				if map.get_cell(x, y-1) == tileWall: # North
					if map.get_cell(x+1, y) == tileWall: # East
						if map.get_cell(x, y+1) == tileWall: # South
							if map.get_cell(x-1, y) == tileWall: # West
								map.set_cell(x, y-1, tileFloor)
				if map.get_cell(x+1, y) == tileWall:
					if map.get_cell(x+1, y+1) == tileWall:
						if map.get_cell(x, y+1) == tileWall:
							map.set_cell(x, y, tileFloor)
							map.set_cell(x+1, y, tileFloor)
