extends Area2D

# ===================================
# 敵基底クラス.
# ===================================
class_name Enemy

# -----------------------------------
# preloads.
# -----------------------------------
const BULLET_OBJ = preload("res://src/Bullet.tscn")

# -----------------------------------
# consts.
# -----------------------------------
const TIMER_APPEAR = 1.0

# -----------------------------------
# vars.
# -----------------------------------
var _velocity = Vector2.ZERO
var _timer = 0.0
var _vel_knockback = Vector2.ZERO
var _collision:CollisionShape2D = null

# -----------------------------------
# public functions.
# -----------------------------------
func setup(col:CollisionShape2D) -> void:
	_collision = col
func get_collision_radius() -> float:
	var shape:Shape2D = _collision.shape
	if shape is CircleShape2D:
		return shape.radius / 2.0
	return 0.0
	
## 速度を設定.
func set_velocity(deg:float, spd:float) -> void:
	var rad = deg2rad(deg)
	_velocity.x = spd * cos(rad)
	_velocity.y = spd * -sin(rad)

# -----------------------------------
# private functions.
# -----------------------------------
## 出現演出の更新.
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

## 重なりを解消する.
func _collide_enemy() -> void:
	for enemy in Common.get_layer("enemy").get_children():
		var e:Enemy = enemy
		if get_instance_id() == e.get_instance_id():
			continue # 自分自身を除外.
		var d = e.position - position
		var length = d.length()
		var r1 = get_collision_radius()
		var r2 = e.get_collision_radius()
		var dist = (r1 + r2) - length
		if dist < 0:
			continue # 衝突していない.
		
		# 押し戻す.
		d = d.normalized()
		position += d * (-dist)

func _damage(area:Area2D) -> void:
	if area is Shot:
		var v = area.get_velocity()
		_vel_knockback += v
		area.vanish()

func _bullet(deg:float, spd:float, ax:float=0.0, ay:float=0.0, ofs:Vector2=Vector2.ZERO) -> void:
	var pos = position + ofs
	var b = BULLET_OBJ.instance()
	b.setup(deg, spd, ax, ay)
	b.position = pos
	Common.get_layer("bullet").add_child(b)
