extends Node2D

@onready var sprite = $RocherSprite
@export var score = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var s = randf_range(0.5,1.5)
	sprite.texture = load("res://icon.svg")
	sprite.scale = Vector2(s,s)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_button_button_down() -> void:
	#var s = randf_range(0.5,1.5)
	#sprite.scale = Vector2(s,s)

func hit():
	PlayerInfo.set_score(PlayerInfo.score+score)
	queue_free()
