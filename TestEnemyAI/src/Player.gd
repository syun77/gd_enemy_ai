extends Sprite

# ========================================
# プレイヤー.
# ========================================
class_name Player

# ----------------------------------------
# preload.
# ----------------------------------------
const SHOT_OBJ = preload("res://src/Shot.tscn")

# ----------------------------------------
# consts.
# ----------------------------------------
const MOVE_SPEED = 100.0
const SHOT_INTERVAL = 60 * 2

# ----------------------------------------
# vars.
# ----------------------------------------
var _target = Vector2.ZERO
var _velocity = Vector2.ZERO
var _last_direction = Vector2.ZERO
var _vel_dash = Vector2.ZERO
var _timer = 0.0
var _ghost_list = []
var _is_left = false
var _shot_interval = 0

# ----------------------------------------
# public functions.
# ----------------------------------------

# ----------------------------------------
# private functions.
# ----------------------------------------
func _ready() -> void:
	_target = position
	for i in range(8):
		var spr = Sprite.new()
		spr.texture = texture
		spr.hframes = 3
		spr.modulate.a = 1.0 - i * (1.0 / 7)
		spr.material = load("res://assets/tres/ghost_material.tres")
		spr.z_index = -1
		var col = Color.aqua
		spr.material.set_shader_param("col", Vector3(col.r, col.g, col.b))
		add_child(spr)
		_ghost_list.append(spr)

func _process(delta: float) -> void:
	_timer += delta
	
	_update_shot()
	
	# 移動先を変更.
	var v = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		_is_left = true
		v += Vector2.LEFT
	if Input.is_action_pressed("ui_up"):
		v += Vector2.UP
	if Input.is_action_pressed("ui_right"):
		_is_left = false
		v += Vector2.RIGHT
	if Input.is_action_pressed("ui_down"):
		v += Vector2.DOWN
	v = v.normalized()
	_last_direction = v
	
	_vel_dash *= 0.95
	if Input.is_action_just_pressed("ui_dash"):
		# 加速.
		_vel_dash = _last_direction * 1000
	
	_velocity = (v * MOVE_SPEED + _vel_dash) * delta

	position += _velocity
	if position.x < 0:
		position.x = 0
	if position.x > 1024:
		position.x = 1024
	if position.y < 0:
		position.y = 0
	if position.y > 600:
		position.y = 600
	
	# ゴーストの更新.
	_update_ghost(delta)

	flip_h = _is_left

	if int(_timer * 2) % 2 == 0:
		frame = 0
	else:
		frame = 1

## ショットの更新.
func _update_shot() -> void:
	_shot_interval += 1
	if _shot_interval%SHOT_INTERVAL == 0:
		var aim = _get_aim()
		_shot(aim, 200)

func _get_aim() -> float:
	var aim = rand_range(0, 360)
	var target = _search_target()
	if target == null:
		return aim
	
	var d = target.position - position
	aim = rad2deg(atan2(-d.y, d.x))
	
	return aim

func _search_target() -> Enemy:
	var target:Enemy = null
	var distance = 9999999
	for enemy in Common.get_layer("enemy").get_children():
		var e:Enemy = enemy
		var d = e.position - position
		var length = d.length()
		if distance > length:
			distance = length
			target = e
	return target
	

## 残像の位置の更新.
func _update_ghost(delta:float) -> void:
	# ルートノードの相対座標なので (0, 0) から開始する.
	var flip = flip_h
	var prev = Vector2.ZERO
	for i in range(_ghost_list.size()):
		var spr:Sprite = _ghost_list[i]
		spr.position -= _velocity # 移動量のオフセットがかかる
		
		var pos = spr.position
		spr.position += (prev - pos) * 7 * delta
		prev = pos
		var tmp = spr.flip_h
		spr.flip_h = flip
		flip = tmp

## ショットの発射.
func _shot(deg:float, spd:float) -> void:
	var s = SHOT_OBJ.instance()
	s.position = position
	s.set_velocity(deg, spd)
	Common.get_layer("shot").add_child(s)
