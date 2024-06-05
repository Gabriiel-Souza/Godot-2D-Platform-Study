extends Node2D

const WAIT_DURATION: float = 1.0

@onready var platform: AnimatableBody2D = $platform
@onready var platformSprite: Sprite2D = $platform/platform_sprite

@export var moveSpeed: float = 3.0
@export var distance: float = 192
@export var moveHorizontal: bool = true

var follow: Vector2 = Vector2.ZERO
var platformCenter: float = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	movePlatform()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	platform.position = platform.position.lerp(follow, 0.5)

func movePlatform():
	var moveDirection = Vector2.RIGHT * distance if moveHorizontal else Vector2.UP * distance
	var duration = moveDirection.length() / (moveSpeed * platformCenter)
	var platformTween = (
		create_tween() 
		.set_loops()
		.set_trans(Tween.TRANS_LINEAR)
		.set_ease(Tween.EASE_IN)
	)
	
	platformTween.tween_property(self, "follow", moveDirection, duration).set_delay(WAIT_DURATION)
	platformTween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
