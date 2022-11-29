extends Area2D


export var speed = 400
var screen_size

var alive = false
var direction = Vector2(0,-1)

var bullet_scene = preload("res://Bullet.tscn")


func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	if not alive:
		get_node("AnimatedSprite").stop()
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	
	if velocity.length() > 0:
		direction = velocity.normalized()
		velocity = velocity.normalized() * speed
		position = position + velocity * delta
		
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
		get_node("AnimatedSprite").play()
	else:
		get_node("AnimatedSprite").stop()
	
	if velocity.x != 0:
		get_node("AnimatedSprite").animation = "walk"
		get_node("AnimatedSprite").flip_v = false
		get_node("AnimatedSprite").flip_h = velocity.x < 0
	if velocity.y != 0:
		get_node("AnimatedSprite").animation = "up"
		get_node("AnimatedSprite").flip_h = false
		get_node("AnimatedSprite").flip_v = velocity.y > 0


func set_alive(b):
	alive = b
	if not alive:
		direction = Vector2(0,-1)
	



func _on_Timer_timeout():
	if get_parent().bullet_mode and alive:
		var bullet = bullet_scene.instance()
		get_parent().add_child(bullet)
		bullet.position = position - direction*30
		bullet.set_direction(direction * -1)
