extends CharacterBody2D

# Consts
const SPEED: float = 200.0
const JUMP_VELOCITY: float = -400.0

# Variables
@onready var playerNode: AnimatedSprite2D = $playerAnimation
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumping: bool = false
var isFalling: bool = false
var lastDirection: float = 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		isJumping = true
		isFalling = velocity.y > 0
	else:
		isJumping = false
		isFalling = false
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		lastDirection = direction
		
		if isFalling:
			playFalling(direction)
		elif isJumping:
			playerNode.play("jump")
			playerNode.scale.x = direction
		else:
			playerNode.play("run")
			playerNode.scale.x = direction
	else:
		if isFalling:
			playFalling(lastDirection)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			playerNode.play("idle")
			playerNode.scale.x = lastDirection

	move_and_slide()

func playFalling(direction: float):
	playerNode.play("falling")
	playerNode.scale.x = direction
