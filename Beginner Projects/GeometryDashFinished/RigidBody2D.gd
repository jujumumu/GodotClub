extends RigidBody2D

var thrust = Vector2(0, 250)
var torque = 20000

func _integrate_forces(state):
	apply_central_impulse(Vector2(0,9.8))
