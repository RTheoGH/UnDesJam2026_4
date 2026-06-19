extends Node2D

var planetes : Array[RigidBody2D]
var current_orbit_index := -1

@export var gravite := false

@export var sonde: RigidBody2D
@export var sonde_velocity := Vector2(200,0)

func _ready() -> void:
	# On s'assure que la gravité par défaut de Godot n'affecte pas la sonde
	sonde.gravity_scale = 0.0
	sonde.linear_velocity = sonde_velocity
	
	for planete in get_children():
		if planete.is_in_group("Planetes"):
			planetes.append(planete)
			
	for i in planetes.size():
		var zone = planetes[i].get_node("Gravite")
		zone.body_entered.connect(_on_zone_gravite_body_entered.bind(i))
		zone.body_exited.connect(_on_zone_gravite_body_exited.bind(i))

func _physics_process(_delta: float) -> void:
	if gravite:
		_appliquer_gravite()
	
	# Aligne visuellement la sonde avec sa direction de déplacement
	if sonde.linear_velocity.length_squared() > 1.0:
		sonde.rotation = sonde.linear_velocity.angle()

func _appliquer_gravite() -> void:
	if current_orbit_index == -1:
		return
	
	var cible = planetes[current_orbit_index]
	var direction = (cible.global_position - sonde.global_position).normalized()
	var distance = sonde.global_position.distance_to(cible.global_position)
	
	# Formule de gravité simplifiée
	var force = cible.mass / max(distance * 0.1, 10)
	
	sonde.apply_central_force(direction * force)

func _on_zone_gravite_body_entered(body: Node, index: int) -> void:
	if body == sonde:
		current_orbit_index = index
		gravite = true
		print("Entrée gravité planetes[", index, "]")

func _on_zone_gravite_body_exited(body: Node, index: int) -> void:
	if body == sonde:
		var encore_dans_zone := false
		for planete in planetes:
			if planete.get_node("Gravite").overlaps_body(sonde):
				encore_dans_zone = true
				current_orbit_index = planetes.find(planete)
				break
		
		if not encore_dans_zone:
			current_orbit_index = -1
			gravite = false
			print("Sortie de gravité. Vitesse actuelle : ", sonde.linear_velocity)
			
			# OPTIONNEL : Si vous souhaitez donner un petit coup de pouce (boost de fronde) à la sortie
			# sonde.linear_velocity = sonde.linear_velocity * 1.2
