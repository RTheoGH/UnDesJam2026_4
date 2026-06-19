extends Node2D

var rayon = 540
var gravite := 9.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for i in 10 : spawn_target()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_target():
	var target_scene = load("res://will/Target.tscn")
	var target = target_scene.instantiate()
	add_child(target)
	var test = randf_range(1,2)
	target.position = Vector2(cos(2*PI*test)*rayon, sin(2*PI*test)*rayon)
	target.oriente(position)

func get_grav_force() -> float:
	return gravite
