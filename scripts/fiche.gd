extends Control

@onready var vignette = $Panel/Vignette
@onready var phaune = $Panel/Phaune
@onready var distance = $Panel/Distance
@onready var masse = $Panel/Masse
@onready var etoile = $Panel/Etoile
@onready var planete_name = $Panel/Name
@onready var lore = $Panel/Lore

var planete_index


var planetes_infos = {
	"55 Cancri e" = ["res://ressources/imgs/Vignette/Vignette_willo.png","res://tests/will/alien_1.png","~41 années-lumière","8 × Terre","55 Cancri","55 Cancri e est une « super-Terre » extrêmement proche de son étoile. Sa surface est probablement recouverte de lave en fusion, avec des températures infernales. Elle est connue pour son orbite ultra-rapide, bouclée en moins d’une journée terrestre."],
	"Namek" = ["res://ressources/imgs/Vignette/Vignette_Azou.png","res://tests/test_azou/aura_farm.png","Autre région de l’univers","1 x Terre","3 Soleils","Namek est une planète emblématique de l’univers Dragon Ball, reconnaissable à son ciel vert et à ses trois soleils. Son environnement est calme et peu urbanisé, composé d’océans et de petites îles où vivent les Nameks, un peuple pacifique. La planète joue un rôle central dans l’arc narratif de Dragon Ball Z, notamment grâce aux Dragon Balls qui permettent d’exaucer des vœux. Malgré son apparence paisible, elle devient le théâtre d’affrontements majeurs."],
	"WASP-12b" = ["res://ressources/imgs/Vignette/Vignette_Este.png","res://tests/este/bonhomme.png","~870 années-lumière","1,4 × Jupiter","WASP-12","WASP-12b est une « Jupiter chaud » si proche de son étoile qu’elle est littéralement en train de se faire absorber. Sa forme est étirée par les forces gravitationnelles, et son atmosphère s’échappe progressivement dans l’espace."],
	"Kepler-186f" = ["res://ressources/imgs/Vignette/Vignette_chlo.png","res://ressources/imgs/objets/props_art_4.png","~500 années-lumière","1 x Terre","Kepler-186","Kepler-186f est l’une des premières exoplanètes de taille terrestre découvertes dans la zone habitable de son étoile. Bien qu’elle reçoive moins de lumière que la Terre, elle pourrait potentiellement abriter de l’eau liquide, ce qui en fait une candidate intéressante dans la recherche de vie extraterrestre."],
	"TRAPPIST-1e" = ["res://ressources/imgs/Vignette/Vignette_Lou.png","res://ressources/imgs/objets/IMG_7760.png","~40 années-lumière","0,77 × Terre","TRAPPIST-1","TRAPPIST-1e est l’une des planètes les plus prometteuses pour la recherche de vie. Située dans la zone habitable, elle pourrait posséder de l’eau liquide et une atmosphère. Elle fait partie d’un système exceptionnel de sept planètes rocheuses."],
	"TOI-1452 b" = ["res://ressources/imgs/Vignette/Vignette_willo.png","res://tests/will/alien_1.png","~100 années-lumière","~5 × Terre","naine rouge","TOI-1452 b est une candidate « planète océan », possiblement recouverte en grande partie d’eau. Sa composition pourrait être très différente de celle de la Terre, avec un manteau riche en glace ou en océans profonds, ce qui intrigue les scientifiques."]
}

var planetes = ["55 Cancri e","Namek","WASP-12b","Kepler-186f","TRAPPIST-1e","TOI-1452 b"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	planete_name.text = planetes[planete_index]
	vignette.texture = load(planetes_infos[planetes[planete_index]][0])
	phaune.texture = load(planetes_infos[planetes[planete_index]][1])
	distance.text = planetes_infos[planetes[planete_index]][2]
	masse.text = planetes_infos[planetes[planete_index]][3]
	etoile.text = planetes_infos[planetes[planete_index]][4]
	lore.text = planetes_infos[planetes[planete_index]][5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	queue_free()
