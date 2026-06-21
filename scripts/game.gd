extends Node2D

@onready var planete : PackedScene = preload("res://scenes/planete.tscn")
@onready var asteroid : PackedScene = preload("res://scenes/rocher.tscn")

@export var p1 : Vector2 = Vector2(-6400,-4000)
@export var p2 : Vector2 = Vector2(6400, 4000)

@export var ap1 : Vector2 = Vector2(0, -12500)
@export var ap2 : Vector2 = Vector2(-12500, -2500)
@export var ap3 : Vector2 = Vector2(2500, 12500)
@export var ap4 : Vector2 = Vector2(15000, 0)

@export var n_planetes : int = 10
@export var n_asteroids : int = 80
@export var distance_min_planets : float = 2500.0
@export var distance_min_to_planets : float = 1200.0
@export var max_essais : int = 10

@export var vitesse_rotation_min = -1.0
@export var vitesse_rotation_max = 1.0
@export var scale_min = 0.7
@export var scale_max = 1.2

@export var free_cam : bool = false
@export var directed_cam : bool = true
@export var zoom_speed = 0.1
@export var zoom_min = 0.06
@export var zoom_max = 3.0
@export var pan_speed : float = 100.0
@export var pan_zoom_cap : float = 1.0
var dragging = false

var pos_used : Array[Vector2] = []
var planetes_data : Array = []

var mouse_in_launch_zone = false

var canvas : CanvasLayer

func _ready() -> void:
	canvas = get_node("CanvasLayer")
	get_node("Launch_zone/CollisionShape2D").disabled = true
	for i in range(n_planetes):
		await get_tree().create_timer(0.025).timeout
		spawn_planete()
	for i in range(n_asteroids):
		#await get_tree().create_timer(0.0005).timeout
		spawn_asteroids()
	get_node("Launch_zone/CollisionShape2D").disabled = false
	
	canvas.fade_in("Annoncer")
	await canvas.type_text("Annoncer", "Start !")
	await get_tree().create_timer(0.25).timeout
	canvas.fade_out("Annoncer")
	
func _process(delta: float) -> void:
	for data in planetes_data:
		data.node.rotation += data.vitesse * delta
		#data.node.scale = Vector2(data.scale, data.scale)
		
func _input(_event: InputEvent) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and free_cam:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_camera(1.0 + zoom_speed, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_camera(1.0 - zoom_speed, event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and event.ctrl_pressed:
				dragging = true
			else:
				dragging = false
				
	if event is InputEventMouseMotion and dragging:
		if event.ctrl_pressed:
			var zoom_pour_pan = min($Camera2D.zoom.x, pan_zoom_cap)
			$Camera2D.position -= event.relative * zoom_pour_pan * pan_speed
			clamp_camera()
		else:
			dragging = false


func zoom_camera(f: float, mouse_screen_pos: Vector2) -> void:
		var cam = $Camera2D
		var vw_size = get_viewport_rect().size
		
		var mouse_world_before = cam.global_position + (mouse_screen_pos - vw_size / 2.0) * cam.zoom
		var new_zoom_val = clamp(cam.zoom.x * f, zoom_min, zoom_max)
		cam.zoom = Vector2(new_zoom_val, new_zoom_val)
		var mouse_world_after = cam.global_position + (mouse_screen_pos - vw_size / 2.0) * cam.zoom
		cam.global_position += mouse_world_before - mouse_world_after
		clamp_camera()
	
func clamp_camera() -> void:
	var cam = $Camera2D
	var vw_size = get_viewport_rect().size
	var half_view = (vw_size / 2.0) * cam.zoom
	
	var min_x = p1.x + half_view.x
	var max_x = p2.x - half_view.x
	var min_y = p1.y + half_view.y
	var max_y = p2.y - half_view.y
	
	var pos = cam.position
	
	if min_x > max_x:
		pos.x = (p1.x + p2.x) / 2.0
	else:
		pos.x = clamp(pos.x, min_x, max_x)
		
	if min_y > max_y:
		pos.y = (p1.y + p2.y) / 2.0
	else:
		pos.y = clamp(pos.y, min_y, max_y)
		
	cam.position = pos

# Position alétoire entre deux points
func random_pos(point1 : Vector2, point2 : Vector2) -> Vector2:
	var x = randf_range(point1.x, point2.x)
	var y = randf_range(point1.y, point2.y)
	return Vector2(x,y)

func random_pos_ast(p1 : Vector2, p2 : Vector2, p3 : Vector2, p4 : Vector2) -> Vector2:
	var area1 = tri_area(p1, p2, p3)
	var area2 = tri_area(p1, p3, p4)
	var total_area = area1 + area2

	if randf() < area1 / total_area:
		return r_in_tri(p1, p2, p3)
	else:
		return r_in_tri(p1, p3, p4)

func tri_area(a: Vector2, b: Vector2, c: Vector2) -> float:
	return abs((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)) / 2.0
	
func r_in_tri(a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var r1 = randf()
	var r2 = randf()
	if r1 + r2 > 1.0:
		r1 = 1.0 - r1
		r2 = 1.0 - r2
	return a + r1 * (b - a) + r2 * (c - a)

# Vérifie que la pos est valide
func pos_valide(pos : Vector2, is_planet: bool) -> bool:
	var d : float
	if is_planet:
		d = distance_min_planets
	else:
		d = distance_min_to_planets
	
	for autre_pos in pos_used:
		if pos.distance_to(autre_pos) < d:
			return false
	return true
	
func spawn_planete():
	var pos : Vector2
	var essais = 0
	
	pos = random_pos(p1, p2)
	while not pos_valide(pos, true) and essais < max_essais:
		pos = random_pos(p1, p2)
		essais += 1
		
	if essais >= max_essais:
		print("plus de place")
		return
	
	pos_used.append(pos)
	
	var planete_instance = planete.instantiate()
	planete_instance.position = pos
	add_child(planete_instance)
	planete_instance.visible = false
	planete_instance.fade_in()
	
	var vitesse = randf_range(vitesse_rotation_min, vitesse_rotation_max)
	var taille = randf_range(scale_min, scale_max)
	if vitesse == 0.0:
		vitesse = 0.1
	planetes_data.append({"node": planete_instance, "vitesse": vitesse, "taille": taille})

func spawn_asteroids():
	var pos : Vector2
	var essais = 0
	
	pos = random_pos_ast(ap1, ap2, ap3, ap4)
	while not pos_valide(pos, false) and essais < max_essais:
		pos = random_pos_ast(ap1, ap2, ap3, ap4)
		essais += 1
		
	if essais >= max_essais:
		print("plus de place")
		return
		
	var asteroid_instance = asteroid.instantiate()
	asteroid_instance.position = pos
	add_child(asteroid_instance)

func _on_launch_zone_mouse_entered() -> void:
	mouse_in_launch_zone = true

func _on_launch_zone_mouse_exited() -> void:
	mouse_in_launch_zone = false
