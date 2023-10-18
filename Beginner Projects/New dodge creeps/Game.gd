extends Node2D

var score = 0
var enemy_scene = preload("res://Enemy.tscn")
var high_score = 0


func _ready():
	randomize()

	get_node("music").play()


func _on_Timer_timeout():
	var enemy = enemy_scene.instance()
	
	var enemy_spawn_location = get_node("EnemyPath/EnemySpawnLocation")
	enemy_spawn_location.offset = randi()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = enemy_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location.
	enemy.position = enemy_spawn_location.position
	
	# Add some randomness to the direction.
	direction = direction + rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	get_node("Enemys").add_child(enemy)
	


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

	if high_score < score:
		high_score = score
	
	get_node("CanvasLayer/High Score").set_text("High Score: "+ str(high_score))
	
	get_node("music").play()
	



func _on_Timer2_timeout():
	#get_node("Timer").wait_time = get_node("Timer").wait_time * 0.95
	score = score + 1
	get_node("Timer").wait_time = 10.0/(30+score)
	get_node("CanvasLayer/Score").text = str(score)
	




func _on_Start_pressed():
	get_node("CanvasLayer/Start").visible = false
	get_node("CanvasLayer/Score").visible = false
	get_node("CanvasLayer/High Score").visible = false
	
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
	



	
