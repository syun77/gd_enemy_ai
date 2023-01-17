extends Node

# -------------------------------------
# consts.
# -------------------------------------
# 追跡型.
enum eTracking {
	ALWAYS,
	INTERVAL,	
}

# -------------------------------------
# public vars.
# -------------------------------------
var tracking = eTracking.ALWAYS

# -------------------------------------
# private vars.
# -------------------------------------
var _target:Player = null
var _target_pos = Vector2.ZERO
var _target_vel = Vector2.ZERO
var _target_dir = 0.0
var _layers = {}

# -------------------------------------
# public functions.
# -------------------------------------
func set_target(t:Player) -> void:
	_target = t
func is_valid_target() -> bool:
	return is_instance_valid(_target)
func get_target_pos() -> Vector2:
	if is_instance_valid(_target) == false:
		return _target_pos
	_target_pos = _target.position
	return _target_pos
func get_target_vel() -> Vector2:
	if is_instance_valid(_target) == false:
		return _target_vel
	_target_vel = _target.get_velocity()
	return _target_vel
func get_target_move_dir() -> float:
	var v = get_target_vel()
	return rad2deg(atan2(-v.y, v.x))
func get_target_direction() -> float:
	if is_instance_valid(_target) == false:
		return _target_dir
	_target_dir = _target.get_direction()
	return _target_dir
	
func get_aim(pos:Vector2) -> float:
	var t = get_target_pos()
	var d = t - pos
	return rad2deg(atan2(-d.y, d.x))
func get_aim2(pos:Vector2) -> float:
	var t = get_target_pos()
	var d = t - pos
	return rad2deg(atan2(d.y, d.x))



func set_layer(layers) -> void:
	_layers = layers
func get_layer(name:String) -> CanvasLayer:
	return _layers[name]
	
## 角度差を求める.
func diff_angle(now:float, next:float) -> float:
	# 角度差を求める.
	var d = next - now
	# 0.0〜360.0にする.
	d -= floor(d / 360.0) * 360.0
	# -180.0〜180.0の範囲にする.
	if d > 180.0:
		d -= 360.0
	return d

# -------------------------------------
# private functions.
# -------------------------------------
