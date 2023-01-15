extends Node2D

onready var _bg_back = $Bg/BgBack
onready var _bg_sky = $Bg/BgSky
onready var _shot_layer = $ShotLayer
onready var _enemy_layer = $EnemyLayer
onready var _player = $MainLayer/Player

func _ready() -> void:
	Common.set_target(_player)
	
	var layers = {
		"shot": _shot_layer,
		"enemy": _enemy_layer,
	}
	Common.set_layer(layers)

func _physics_process(delta: float) -> void:
	_update_bg(delta)


func _update_bg(delta:float) -> void:
	var center = Vector2(1024/2, 600/2)
	var d = _player.position - center
	var back_ofs = d * -0.3
	var sky_ofs = d * -0.1
	_bg_back.offset += (back_ofs - _bg_back.offset) * delta * 3
	_bg_sky.offset += (sky_ofs - _bg_sky.offset) * delta * 3
