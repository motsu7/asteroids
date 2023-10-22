extends Control

@onready var score = $Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var lives = $Lives:
	set(value):
		lives.text = "LIVES: " + str(value)
