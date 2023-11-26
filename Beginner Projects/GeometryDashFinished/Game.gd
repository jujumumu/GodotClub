extends Node2D

var alive = true

func _ready():
	get_node("Player").connect("died", self, "_player_died")


func _process(delta):
	if alive:
		get_node("Camera2D").position.x = get_node("Player").position.x - 200
		get_node("CanvasLayer/Label").text = str(get_node("Player").isonfloor)

func _player_died():
	get_node("CanvasLayer/YouDied").visible = true
	alive = false

