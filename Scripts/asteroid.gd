class_name Asteroid extends Area2D

signal exploded(pos, size)

var movement_vector := Vector2(0, -1)

enum AsteroidSize{LARGE, MEDIUM, SMALL, TINY}
@export var size := AsteroidSize.LARGE

var speed := 50.0

@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D

var points: int:
	get:
		match size:
			AsteroidSize.LARGE:
				return 10
			AsteroidSize.MEDIUM:
				return 25
			AsteroidSize.SMALL:
				return 50
			AsteroidSize.TINY:
				return 100
			_:
				return 0

func _ready():
	# Note: picks a random rotation, 2 * PI = full circle
	rotation = randf_range(0, 2 * PI)
	
	# Note: sets right attributes (texture, cshape, speed) based on size
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite.frame = 0
			cshape.shape = preload("res://Resources/asteroid_cshape_large.tres")
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			sprite.frame = 1
			cshape.shape = preload("res://Resources/asteroid_cshape_medium.tres")
		AsteroidSize.SMALL:
			speed = randf_range(150, 200)
			sprite.frame = 2
			cshape.shape = preload("res://Resources/asteroid_cshape_small.tres")
		AsteroidSize.TINY:
			speed = randf_range(200, 250)
			sprite.frame = 3
			cshape.shape = preload("res://Resources/asteroid_cshape_tiny.tres")

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var screen_size := get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func explode():
	emit_signal("exploded", global_position, size, points)
	queue_free()


func _on_body_entered(body):
	if body is Player:
		var player = body
		player.die()
