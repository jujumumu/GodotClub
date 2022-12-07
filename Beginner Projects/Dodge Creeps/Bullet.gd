extends Area2D


export var speed = 300
var velocity = Vector2(0,0)

func _ready():
	pass # Replace with function body.

func set_direction(direction):
	rotation_degrees = rad2deg( -direction.angle_to(Vector2(0,-1)))
	velocity = direction * speed

func _process(delta):
	position = position + velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Bullet_body_entered(body):
	body.queue_free()
	queue_free()
