extends KinematicBody2D

var speed : int = 150
var nav = null setget setNav
var path : Array = []
var goal : Vector2 = Vector2()

func _ready() -> void:
	pass

# Denna uppdaterar pathen, så den är nödvändig för att uppdatera AI
func setNav(newNav) -> void:
	nav = newNav
	updatePath()

func updatePath() -> void:
	path = nav.get_simple_path(position, goal, false)
	if path.size() == 0:
		queue_free()

# /2019/11/19/godot-tutorial-how-to-use-navigation2d-for-pathfinding/
func _process(delta) -> void:
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move the player along the path until he has run out of movement or the path ends.
	if distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += move_and_slide(position.direction_to(path[0]) * distance_to_walk)
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point
		look_at(goal) # Look at target
