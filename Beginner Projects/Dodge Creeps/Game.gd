extends Node2D

var screen_size
var spawns = []
var score = 0
var mob_scene = preload("res://Enemy.tscn")
var high_score = 0
var bullet_high_score = 0
var bullet_mode = false

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	
	
	
	spawns.append([Vector2(-100,-100), Vector2(screen_size.x+100,-100)])
	spawns.append([Vector2(-100,screen_size.y+100), Vector2(screen_size.x+100,screen_size.y+100)])
	spawns.append([Vector2(-100,-100), Vector2(-100,screen_size.y+100)])
	spawns.append([Vector2(screen_size.x+100,-100), Vector2(screen_size.x+100,screen_size.y+100)])
	
	get_node("music").play()


func _on_Timer_timeout():
	
	var line = spawns[randi() % spawns.size()]
	
	var point = line[0].linear_interpolate(line[1], rand_range(0,1))
	
	var mob = mob_scene.instance()
	mob.position = point
	
	mob.linear_velocity = Vector2(rand_range(100,200),0).rotated(rand_range(0, 2*PI))
	
	get_node("Enemys").add_child(mob)
	


func _on_Player_body_entered(body):
	if not get_node("Player").alive:
		return
	get_node("music").stop()
	get_node("death").play()
	get_node("Timer").stop()
	get_node("Timer2").stop()
	get_node("Player").set_alive(false)
	yield(get_tree().create_timer(2.6), "timeout")
	get_node("CanvasLayer/Start").visible = true
	get_node("CanvasLayer/High Score").visible = true
	get_node("CanvasLayer/Bullet").visible = true
	
	if bullet_mode:
		if bullet_high_score < score:
			bullet_high_score = score
	else:
		if high_score < score:
			high_score = score
	
	if bullet_mode:
		get_node("CanvasLayer/High Score").text = "High Score: " + str(bullet_high_score)
	else:
		get_node("CanvasLayer/High Score").text = "High Score: " + str(high_score)
	get_node("music").play()
	



func _on_Timer2_timeout():
	#get_node("Timer").wait_time = get_node("Timer").wait_time * 0.95
	score = score + 1
	get_node("Timer").wait_time = 10.0/(30+score)
	if bullet_mode:
		get_node("Timer").wait_time = get_node("Timer").wait_time / 5.0
	get_node("CanvasLayer/Score").text = str(score)
	




func _on_Start_pressed():
	get_node("CanvasLayer/Start").visible = false
	get_node("CanvasLayer/Score").visible = false
	get_node("CanvasLayer/High Score").visible = false
	get_node("CanvasLayer/Bullet").visible = false
	
	for child in get_node("Enemys").get_children():
		child.queue_free()
	
	get_node("CanvasLayer/Dodge").visible = true
	get_node("Player").monitoring = true
	get_node("Player").position = Vector2(508,233)
	get_node("Timer").wait_time = 0.5
	yield(get_tree().create_timer(2), "timeout")
	get_node("CanvasLayer/Dodge").visible = false
	get_node("CanvasLayer/Score").visible = true
	score = 0
	get_node("CanvasLayer/Score").text = "0"
	get_node("Timer").start()
	get_node("Timer2").start()
	get_node("Player").set_alive(true)
	



func _on_Bullet_pressed():
	bullet_mode = not bullet_mode
	
	if bullet_mode:
		get_node("CanvasLayer/Bullet").text = "Bullet Mode: On"
		get_node("CanvasLayer/High Score").text = "High Score: " + str(bullet_high_score)
	else:
		get_node("CanvasLayer/Bullet").text = "Bullet Mode: Off"
		get_node("CanvasLayer/High Score").text = "High Score: " + str(high_score)
	
