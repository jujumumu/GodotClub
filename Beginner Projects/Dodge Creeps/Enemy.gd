extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy_types = get_node("AnimatedSprite").frames.get_animation_names()
	get_node("AnimatedSprite").animation = enemy_types[randi() % enemy_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


