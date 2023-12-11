extends Node2D


var alive = true
var player_scene = preload("res://Player.tscn")

						#position, wall color, floor color, interpolation distance
var background_color = [[0,Vector3(0.329,0.196,0.945), Vector3(0.149,0.082,0.694),0],
					[5000,Vector3(0.576,0.114,0.909), Vector3(0.333,0.066,0.619),1000],
					[1000000000000000000]
]

func _ready():
	get_node("Player").connect("died", self, "_player_died")
	get_node("ParallaxBackground/ParallaxLayer/Sprite").material.set_shader_param("color", background_color[0][1])
	get_node("Floor").material.set_shader_param("color", background_color[0][2])
	

func _process(delta):
	if alive:
		get_node("Camera2D").position.x = get_node("Player").position.x - 200
		
		var index = 0
	
		for i in range(len(background_color)):
			if background_color[i][0] > get_node("Player").position.x:
				index = i-1
				break
		if  get_node("Player").position.x >= background_color[index][0] + background_color[index][3]:
			get_node("ParallaxBackground/ParallaxLayer/Sprite").material.set_shader_param("color", 
			background_color[index][1])
			get_node("Floor").material.set_shader_param("color", background_color[index][2])
		else: 
			var lerpval = ( get_node("Player").position.x - background_color[index][0])/background_color[index][3]
			get_node("ParallaxBackground/ParallaxLayer/Sprite").material.set_shader_param("color", 
			lerp( background_color[index-1][1],  background_color[index][1], lerpval))
			get_node("Floor").material.set_shader_param("color", 
			lerp( background_color[index-1][2],  background_color[index][2], lerpval))
		

func _player_died():
	get_node("CanvasLayer/YouDied").visible = true
	alive = false
	get_node("DeathSound").play()
	get_node("Music").stop()
	yield(get_tree().create_timer(1.85), "timeout")
	get_node("DeathSound").stop()
	get_node("Music").play()
	
	var player = player_scene.instance()
	player.name = "Player"
	add_child(player)
	player.position = Vector2(100,510)
	alive = true
	get_node("Player").connect("died", self, "_player_died")
	get_node("CanvasLayer/YouDied").visible = false
