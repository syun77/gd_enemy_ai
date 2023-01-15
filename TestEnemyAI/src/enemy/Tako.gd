extends Enemy

const MOVE_SPEED = 50.0

enum eState {
	APPEAR,
	MAIN,
}

onready var _spr = $Sprite

var _state = eState.APPEAR

func _ready() -> void:
	pass

## 更新.
func _physics_process(delta: float) -> void:

	match _state:
		eState.APPEAR:
			if _update_appear(_spr, delta) == false:
				_state = eState.MAIN
		eState.MAIN:
			_update_main(delta)
	
	# ノックバックの更新.
	modulate = Color.white
	if _update_knockback(delta):
		modulate = Color.red

func _update_main(delta:float) -> void:
	_timer += delta
	
	var aim = Common.get_aim(position)
	set_velocity(aim, MOVE_SPEED)
	position += _velocity * delta


func _on_Tako_area_entered(area: Area2D) -> void:
	_damage(area)
