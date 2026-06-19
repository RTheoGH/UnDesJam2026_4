extends RigidBody2D

var orbites : Dictionary
# Structure du dictionnaire : {"nom_planete" : [force_g, position, lore]} 

# On réintroduit "velocity" pour que l'inspecteur et les autres scripts 
# puissent continuer à l'utiliser sans planter
@export var velocity := Vector2(200.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# On désactive la gravité globale du projet pour ce vaisseau
	gravity_scale = 0.0
	
	# On applique la valeur reçue dans 'velocity' à la vraie propriété physique
	linear_velocity = velocity


# On utilise _physics_process pour tout ce qui concerne la physique et les forces
func _physics_process(_delta: float) -> void:
	# On calcule la somme des forces gravitationnelles des planètes à portée
	var attraction = calculate_attractions()
	
	# On applique cette force combinée sur le vaisseau
	apply_central_force(attraction)
	
	# On aligne l'angle du vaisseau avec sa trajectoire actuelle (vecteur vitesse)
	if linear_velocity.length_squared() > 1.0:
		rotation = linear_velocity.angle()


# Itère à travers orbites et ajoute leurs influences à la force principale
func calculate_attractions() -> Vector2:
	var force = Vector2(0.0, 0.0) 
	
	for i in orbites.keys():
		var orbite = orbites[i]
		# orbite[1] correspond à la position de la planète
		var dir = (orbite[1] - global_position).normalized()
		# orbite[0] correspond à l'intensité de la gravité de cette planète
		force += dir * orbite[0]
		
	return force


# Ajoute l'orbite traversée au dictionnaire "orbites" avec le nom en clé et les infos en valeurs
func _on_detection_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	if parent.is_in_group("Planetes"):
		var info = parent.get_info()
		orbites[info[0]] = [info[1], info[2], info[3]]
	elif parent.is_in_group("Destructibles"):
		parent.hit()


# Retire l'orbite qu'on vient de quitter
func _on_detection_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Planetes"):
		var info = parent.get_info()
		orbites.erase(info[0])
	elif parent.is_in_group("Destructibles"):
		pass
