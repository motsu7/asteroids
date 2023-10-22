extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player

func _ready():
	player.connect("laser_shot", _on_player_laser_shot)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restart_game()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func restart_game():
	get_tree().reload_current_scene()
