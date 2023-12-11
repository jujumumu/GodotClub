extends RigidBody2D

signal died

var isonfloor = false

func _ready():
	linear_velocity.x = 500
	friction = 0
	gravity_scale = 38

func _physics_process(delta):
	get_node("CPUParticles2D").rotation = -rotation
	get_node("CPUParticles2D").position = Vector2(-30,30).rotated(-rotation)
	
	linear_velocity.x = 500

	if isonfloor and Input.is_action_pressed("ui_up"):
		linear_velocity.y = -1000
		angular_velocity = 6.3
	
		

func _on_Area2D_body_entered(body):
	isonfloor = true
	get_node("CPUParticles2D").set_emitting(true)

func _on_Area2D_body_exited(body):
	isonfloor = false
	get_node("CPUParticles2D").set_emitting(false)


func _on_Kill_body_entered(body):
	emit_signal("died")
	get_parent().get_node("DiedEffect").position = position
	get_parent().get_node("DiedEffect").set_emitting(true)
	queue_free()
