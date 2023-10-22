extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload("res://Scenes/asteroid.tscn")

func _ready():
	player.connect("laser_shot", _on_player_laser_shot)
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart_game()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size):
	match size:
		Asteroid.AsteroidSize.LARGE:
			spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, 2)
		Asteroid.AsteroidSize.MEDIUM:
			spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, 2)
		Asteroid.AsteroidSize.SMALL:
			spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, 2)
		Asteroid.AsteroidSize.TINY:
			pass


func spawn_asteroid(pos, size, amount):
	for i in range(amount):
		var a = asteroid_scene.instantiate()
		a.global_position = pos
		a.size = size
		a.connect("exploded", _on_asteroid_exploded)
		asteroids.add_child(a)

func restart_game():
	get_tree().reload_current_scene()
