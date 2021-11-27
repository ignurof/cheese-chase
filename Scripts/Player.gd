extends KinematicBody2D

export var moveSpeed : int = 64 # Pixels/sec
export var rotateSpeed : int = 12

var screenSize
var rotateTargetDegrees : int

signal gameover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	print(screenSize)
	var _onHit = $Area2D.connect("body_entered", self, "playerHit")

func playerHit(body) -> void:
	if body.name != "Enemy":
		return
	
	emit_signal("gameover")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	var velocity : Vector2 = Vector2()
	# Get player input
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	# Normalize vector velocity if moving
	if velocity.length() > 0:
		velocity = velocity.normalized() * moveSpeed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# Rotate transform based on direction so mouse looks correct
	if velocity.x != 0 and velocity.y == 0: # up down only
		if velocity.x > 0:
			rotateTargetDegrees = 90
		else:
			rotateTargetDegrees = -90
	if velocity.y != 0 and velocity.x == 0: # left right only
		if velocity.y > 0:
			rotateTargetDegrees = 180
		else:
			rotateTargetDegrees = 0
	if velocity.y != 0 and velocity.x != 0: # leftup rightup / leftdown rightdown
		if velocity.y < 0:
			if velocity.x > 0:
				rotateTargetDegrees = 45
			else:
				rotateTargetDegrees = -45
		if velocity.y > 0:
			if velocity.x > 0:
				rotateTargetDegrees = 135
			else:
				rotateTargetDegrees = -135
	
	# Clamp player position within screen bounds
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
	# Update rotation and lerp_angle
	if velocity.y != 0 or velocity.x != 0:
		rotateSmoothly(rotation_degrees, rotateTargetDegrees, rotateSpeed * delta)

	# Update player position based on values and times by delta to not make it weird by fps jank
	move_and_slide(velocity)

func rotateSmoothly(currentRotDegrees, target, delta) -> void:
	var minAngle = deg2rad(currentRotDegrees)
	var maxAngle = deg2rad(target)
	rotation = lerp_angle(minAngle, maxAngle, delta)
