extends Node2D

var rayon = 540

@onready var planeteSprite = $PlaneteSprite
@onready var atmosSprite = $AtmosphereSprite

@export var gravite := 900.0
@export var planete_name = "Planete"
@export var lore = "Lorem ipsum"

@export var planeteSprites: Array[String]
@export var atmosSprites: Array[String]
@export var atmosScales: Array[float]
@export var planeteScales: Array[float]

@export var target_scene: PackedScene
@export var index_generated = randi_range(0,5)
var index_planete := 0

var planete_index = 0
var Tmin = 5
var Tmax = 15


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#generate_planete(index_generated)
	generate_planete(index_planete)
	pass # Replace with function body.

#Spawn un objet à la surface de la planète puis l'oriente vers son centre
func spawn_target():
	var target_scene = target_scene
	var target = target_scene.instantiate()
	target.planeteIndex = planete_index
	add_child(target)
	var test = randf_range(1,2)
	target.position = Vector2(cos(2*PI*test)*rayon, sin(2*PI*test)*rayon)
	target.oriente(position)

#Retourne sous forme de tableau les info de la planete
func get_info() -> Array:
	return [planete_name,gravite,global_position,lore]
	
@onready var tween:= get_tree().create_tween()

func play_spawn() -> void:
	get_node("AudioStreamPlayer").play()

func fade_in(duration := 0.5):
	modulate.a = 0.0
	visible = true
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)

func generate_planete(index):
	planete_index = index
	planeteSprite.texture = load(planeteSprites[index])
	atmosSprite.texture = load(atmosSprites[index])
	atmosSprite.scale = Vector2(atmosScales[index],atmosScales[index])
	planeteSprite.scale = Vector2(planeteScales[index],planeteScales[index])
	planeteSprite.rotation = randf_range(0,360)
	atmosSprite.rotation = randf_range(0,360)
	for i in randi_range(Tmin, Tmax) : spawn_target()


func _on_gravite_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print("clicked")
		print(planete_index)
		var fiche_scene = load("res://scenes/fiche.tscn")
		var fiche = fiche_scene.instantiate()
		fiche.planete_index = planete_index
		get_parent().get_node("CanvasLayer").add_child(fiche)
	pass # Replace with function body.
