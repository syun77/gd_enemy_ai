extends Area2D

class_name Enemy

const TIMER_APPEAR = 1.0

var _velocity = Vector2.ZERO
var _timer = 0.0
var _vel_knockback = Vector2.ZERO

func set_velocity(deg:float, spd:float) -> void:
	var rad = deg2rad(deg)
	_velocity.x = spd * cos(rad)
	_velocity.y = spd * -sin(rad)

func _update_appear(spr:Sprite, delta:float) -> bool:
	_timer += delta
	_timer = min(TIMER_APPEAR, _timer)
	
	var rate = _timer / TIMER_APPEAR
	var sc = rate
	spr.scale.x = sc
	spr.scale.y = sc
	
	return _timer < TIMER_APPEAR

## ノックバックの更新.
func _update_knockback(delta:float) -> bool:
	_vel_knockback *= 0.9
	position += _vel_knockback * delta
	var length = _vel_knockback.length()
	if length > 5:
		return true # ノックバック中.
	return false

func _damage(area:Area2D) -> void:
	if area is Shot:
		var v = area.get_velocity()
		_vel_knockback += v
		area.vanish()
