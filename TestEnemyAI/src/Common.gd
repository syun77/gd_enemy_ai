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
func get_aim(pos:Vector2) -> float:
	var t = get_target_pos()
	var d = t - pos
	return rad2deg(atan2(-d.y, d.x))



func set_layer(layers) -> void:
	_layers = layers
func get_layer(name:String) -> CanvasLayer:
	return _layers[name]

# -------------------------------------
# private functions.
# -------------------------------------
