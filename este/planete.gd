extends Node2D

var rayon = 540

@export var gravite := 900.0
@export var planete_name = "Planete"
@export var lore = "Lorem ipsum"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for i in 10 : spawn_target()
	pass # Replace with function body.

#Spawn un objet à la surface de la planète puis l'oriente vers son centre
func spawn_target():
	var target_scene = load("res://will/Target.tscn")
	var target = target_scene.instantiate()
	add_child(target)
	var test = randf_range(1,2)
	target.position = Vector2(cos(2*PI*test)*rayon, sin(2*PI*test)*rayon)
	target.oriente(position)

#Retourne sous forme de tableau les info de la planete
func get_info() -> Array:
	return [planete_name,gravite,global_position,lore]
