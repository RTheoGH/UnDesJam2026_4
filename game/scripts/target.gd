extends Node2D

@onready var sprite = $TargetSprite
@onready var hitbox = $TargetHitbox

var index:int = 0
var planeteIndex:int = 0

@export var scales: Array[float]
@export var sprites: Array[String]
@export var points: Array[int]

var touche = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	index = randi_range(0,3)+planeteIndex*4
	sprite.texture = load(sprites[index])
	sprite.scale = Vector2(scales[index]+randf_range(-0.1,0.1),scales[index]+randf_range(-0.1,0.1))
	sprite.flip_h = randi_range(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#oriente(get_global_mouse_position())
	pass

func get_sprite():
	return sprite

func get_hitbox():
	return hitbox

func oriente(cible):
	var angle = rad_to_deg(get_angle_to(cible))-90
	rotate(deg_to_rad(angle))

func hit():
	if not touche :
		#queue_free()
		$AudioStreamPlayer2D.play()
		scale.y *= 0.2
		PlayerInfo.set_score(PlayerInfo.score + points[index])
		print(PlayerInfo.score)
		touche = true
		return points[index]
