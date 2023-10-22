extends Area2D

# Note: the laser is an Area2D and not a CharacterBody2D. This means we have to 
# do the movement ourselves.
var movement_vector := Vector2(0, -1)
@export var speed := 500.0

func _physics_process(delta):
	# Note: rotation is a property of Area2D
	global_position += movement_vector.rotated(rotation) * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
