extends Node2D

var map_node 
var build_mode= false
var build_valid = false 
var build_tile  
var build_location
var build_type 
var current_wave = 0
var enemies_in_wave = 0

#'build_buttons' is the name of a group created in the engine.  
#Select GUN node:Inspector:node:Groups:click +:create new group
#Select 'Missile' node: go to groups in the Inspector and 'check' build_buttons' group.
func _ready():
	map_node = get_node("Map1") 	##TODO:when more maps are available, turn this into a variable based on the selected map
	#creates an array of items in the build_buttons group.
	for i in get_tree().get_nodes_in_group("build_buttons"):
		#bind(i.name) passes the name of the group item to 'tower_type' of the called function.
		i.pressed.connect(initiate_build_mode.bind(i.name))
	#start_next_wave()
	
func _process(_delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
	
##
## Wave Functions
##
func start_next_wave():
	var wave_data = retrieve_wave_data()
#await (get_tree().create_timer(i[1])).timeout
	await(get_tree().create_timer(0.2)).timeout #padding between waves so they don't start instantly
	spawn_enemies(wave_data)
	
	
func retrieve_wave_data():
	var wave_data = [["BlueTank", 0.7], ["BlueTank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	
	
func spawn_enemies(wave_data):
	for i in wave_data:
		#var new_enemy = load("res://Scenes/Enemies/"+ i[0]+".tscn").instantiate()
		var new_enemy = load("res://Scenes/Enemies/" + i[0]+".tscn").instantiate()
		#print(new_enemy)
		map_node.get_node("Path").add_child(new_enemy, true)
		await(get_tree().create_timer(i[1])).timeout
		
		
		
		
	
	

##
## Build Functions
##
func initiate_build_mode(tower_type):
	#check if alreadt in build mode
	if build_mode:
		cancel_build_mode()
	#the guns/missile are saved as scenes. T1=built, T2=upgraded.
	build_type = tower_type + "T1"
	build_mode = true 
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	#local_to_map: Returns the map coordinates of the cell containing the given local_position. If local_position is in global coordinates, consider using Node2D.to_local() before passing it to this method.
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	#print(current_tile)
	#map_to_local: Returns the centered position of a cell in the TileMapLayer's local coordinate space. To convert the returned value into global coordinates, use Node2D.to_global().
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	#get_cell_source_id" Returns the tile source ID of the cell at coordinates coords. Returns -1 if the cell does not exist.
	if map_node.get_node("TowerExclusion").get_cell_source_id(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "59ff29")
		build_valid = true 
		build_location = tile_position
		build_tile = current_tile
		
	
	else:
		get_node("UI").update_tower_preview(tile_position, "d11b0d")
		build_valid = false
		

func cancel_build_mode():
	build_mode = false 
	build_valid = false 
	#get_node("UI/TowerPreview").queue_free()
	get_node("UI/TowerPreview").free()
	
func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type ## the '.type' variable is defined in the Turrets.gd script
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(build_tile, 2, Vector2i(1,0))
		
	
