extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var player_respawn_position = $PlayerRespawnPosition

var asteroid_scene = preload("res://Scenes/asteroid.tscn")

var score := 0:
	set(value):
		score = value
		hud.score = score

var lives := 3:
	set(value):
		lives = value
		hud.lives = lives

func _ready():
	score = 0
	lives = 3
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart_game()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	score += points
	match size:
		Asteroid.AsteroidSize.LARGE:
			spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM, 2)
		Asteroid.AsteroidSize.MEDIUM:
			spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL, 2)
		Asteroid.AsteroidSize.SMALL:
			spawn_asteroid(pos, Asteroid.AsteroidSize.TINY, 2)
		Asteroid.AsteroidSize.TINY:
			pass

func _on_player_died():
	lives -= 1
	if lives <= 0:
		restart_game()
	else:
		await get_tree().create_timer(1).timeout
		player.respawn(player_respawn_position.global_position)

func spawn_asteroid(pos, size, amount):
	for i in range(amount):
		var a = asteroid_scene.instantiate()
		a.global_position = pos
		a.size = size
		a.connect("exploded", _on_asteroid_exploded)
		# Note: line below yields errors, are fixed on the line below that
		# asteroids.add_child(a)
		asteroids.call_deferred("add_child", a)

func restart_game():
	get_tree().reload_current_scene()
