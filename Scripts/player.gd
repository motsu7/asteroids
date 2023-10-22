extends CharacterBody2D

# Note: the operator := is used for variable assigment, and also type inference
@export var acceleration := 10.0
@export var max_speed := 350.0
@export var rotation_speed := 200.0
@export var fire_rate := 0.2
@export var ship_slowdown := 2.0

@onready var muzzle = $Muzzle
var laser_scene = preload("res://Scenes/laser.tscn")
signal laser_shot(laser)

var shoot_cooldown = false

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot_laser()
			await get_tree().create_timer(fire_rate).timeout
			shoot_cooldown = false

func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	# Note: rotation_speed is multiplied by delta so it is framerate independent
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, ship_slowdown)
	
	# Note: move_and_slide() uses delta automatically
	move_and_slide()

	### TODO
	# Code below some more work so that the player node cannot be outside the play field.
	# Instead the part that is outside the screen should be visible on the other side.
	var screen_size := get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func shoot_laser():
	var laser = laser_scene.instantiate()
	laser.global_position = muzzle.global_position
	laser.rotation = rotation
	emit_signal("laser_shot", laser)
