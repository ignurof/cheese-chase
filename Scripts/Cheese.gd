extends Node2D


signal pickup

# Cheese is on 2nd collision layer so only Player can hit it

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _hit = $Area2D.connect("body_entered", self, "pickup")
	show()


func pickup(body) -> void:
	if body.name == "Player": # Area2D detects the tilemap too
		hide()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		emit_signal("pickup")
