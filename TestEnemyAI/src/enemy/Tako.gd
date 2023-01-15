extends Enemy

const MOVE_SPEED = 50.0

enum eState {
	APPEAR,
	MAIN,
}

onready var _spr = $Sprite

var _state = eState.APPEAR
var _interval_timer = 0.0

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

func _update_main(delta:float) -> void:
	_timer += delta
	
	match Common.tracking:
		Common.eTracking.ALWAYS:
			# 常に追跡.
			var aim = Common.get_aim(position)
			set_velocity(aim, MOVE_SPEED)
			position += _velocity * delta
			_spr.rotation_degrees = 0.0
		Common.eTracking.INTERVAL:
			# 一定間隔で追跡.
			_interval_timer += delta
			if _interval_timer > 5.0:
				var aim = Common.get_aim(position)
				set_velocity(aim, MOVE_SPEED*10)
				_interval_timer = 0.0
				_spr.rotation_degrees = 0.0
			elif _interval_timer > 1.0:
				var t = _interval_timer - 1.0
				_spr.rotation_degrees += t * 10
			_velocity *= 0.97
			position += _velocity * delta
	


func _on_Tako_area_entered(area: Area2D) -> void:
	_damage(area)
