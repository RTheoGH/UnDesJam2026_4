extends Node

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_score(new_score : int) -> void:
	score = new_score

func reset_game() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(load("res://scenes/main.tscn"))
