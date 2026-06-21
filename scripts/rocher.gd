extends Node2D

@onready var sprite = $RocherSprite
@export var sprites: Array[String]
@export var score = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var s = randf_range(0.3,0.6)
	sprite.texture = load(sprites[randi_range(0,0)])
	sprite.scale = Vector2(s,s)
	sprite.rotation = randf_range(0,360)
	sprite.flip_h = randi_range(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#func _on_button_button_down() -> void:
	#var s = randf_range(0.5,1.5)
	#sprite.scale = Vector2(s,s)

func hit():
	PlayerInfo.set_score(PlayerInfo.score+score)
	queue_free()
