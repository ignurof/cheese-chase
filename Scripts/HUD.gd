extends Control

signal scoreChange
var score : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _cheesePickup = get_parent().get_node("Cheese").connect("pickup", self, "addScore")

func addScore() -> void:
	score += 1
	$Score.text = str(score)
	emit_signal("scoreChange")
