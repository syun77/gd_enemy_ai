extends Enemy

# ==========================
# ナス
# ==========================

# --------------------------
# consts.
# --------------------------
const MOVE_SPEED = 50.0

enum eState {
	APPEAR,
	MAIN,
}

enum eAI {
	STANDBY,
	RANDOM,
	ESCAPE
}

# --------------------------
# onready.
# --------------------------
onready var _spr = $Sprite

# --------------------------
# vars.
# --------------------------
var _state = eState.APPEAR
var _interval_timer = 0.0
var _ai = eAI.STANDBY

# --------------------------
# private functions.
# --------------------------
func _ready() -> void:
	setup($CollisionShape2D)

## 更新.
func _physics_process(delta: float) -> void:

	match _state:
		eState.APPEAR:
			if _update_appear(_spr, delta) == false:
				_state = eState.MAIN
		eState.MAIN:
			_update_main(delta)
	
	# コリジョンを解消する.
	_collide_enemy()
	
	# ノックバックの更新.
	modulate = Color.white
	if _update_knockback(delta):
		_interval_timer = 0.0
		modulate = Color.red

## 更新 > メイン.
func _update_main(delta:float) -> void:
	_timer += delta
	
	_spr.modulate = Color.white
	if _check_escape():
		var d = position - Common.get_target_pos()
		_spr.modulate = Color.blue
		# 逃走モード.
		d = d.normalized()
		_velocity = d * MOVE_SPEED
		_timer = 0
		_ai = eAI.ESCAPE
	
	if _update_random_move():
		_ai = eAI.RANDOM
	
	_velocity *= 0.97
	position += _velocity * delta
	Common.clip_screen(self)

	# 回転アニメーション.
	match _ai:
		eAI.STANDBY:
			rotation += 0.01 * sin(_timer*4)
		_:
			if _velocity.length() < 10:
				_ai = eAI.STANDBY
	

## 近づいてきたかどうか.
func _check_escape() -> bool:
	var v = Common.get_target_vel()
	var a = Common.get_target_direction()
	var d = position - Common.get_target_pos()
	var b = rad2deg(atan2(-d.y, d.x))
	var diff = Common.diff_angle(a, b)
	if abs(diff) > 60:
		return false # 範囲外.

	var dist = d.length()
	if dist > Common.RANGE_ESCAPE:
		return false # 距離が遠い.
	
	if dist < Common.RANGE_ESCAPE * 0.5:
		return true # 近いので逃げる.
	
	var spd = v.length()
	# 近づいてきた.
	if spd == 0:
		return false # 動いていない.
		
	return true

func _update_random_move() -> bool:
	var spd = _velocity.length()
	if _timer > 4.0 and spd < 10:
		_timer = 0.0
		var rnd = rand_range(0.0, 360.0)
		set_velocity(rnd, MOVE_SPEED)
		
		return true # 動いた.
	
	# 動いていない.
	return false


func _on_Tako_area_entered(area: Area2D) -> void:
	_damage(area)
