extends Area2D

class_name Bullet

var _velocity = Vector2.ZERO
var _ax:float = 0.0
var _ay:float = 0.0

func setup(deg:float, spd:float, ax:float, ay:float) -> void:
	set_velocity(deg, spd)
	_ax = ax
	_ay = ay

func set_velocity(deg:float, spd:float) -> void:
	var rad = deg2rad(deg)
	_velocity.x = spd * cos(rad)
	_velocity.y = spd * -sin(rad)
	
func get_velocity() -> Vector2:
	return _velocity

func vanish() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	_velocity.x += _ax
	_velocity.y += _ay
	position += _velocity * delta
	
	if position.x < 0:
		vanish()
	if position.x > 1024:
		vanish()
	if position.y < 0:
		vanish()
	if position.y > 600:
		vanish()
