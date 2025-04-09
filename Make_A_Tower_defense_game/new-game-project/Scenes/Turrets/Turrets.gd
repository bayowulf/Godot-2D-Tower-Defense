extends Node2D

var enemy_array = []
var built = false
var enemy
var type ##this will get a value of 'build_type' in the GameScene.gd 'build_and_verify' function
var readyfreddy = true



func _ready():
	if built:
		#self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]
		#debugprint
		#print(type) 
# Add a line: "new_tower.built = true" in GameScene.gd func 'verify_and_build' 


func _physics_process(_delta: float) -> void:
	if enemy_array.size() != 0 and built:
		#debugprint
		#print(type)
		
		select_enemy()
		turn()
		if readyfreddy:
			fire()
	else:
		enemy = null 
	
func turn():
	#var enemy_position = get_global_mouse_position()
	#get_node("Turret").look_at(enemy_position)
	get_node("Turret").look_at(enemy.position)
	
	#debugprint
	#var temp1 = get_node("Turret")
	#print(temp1)
	
	
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress) ## Progress is how may pixels enemy has travelled
##print(enemy_progress_array)
##print(enemy_array)
##
##[260.0] <- only one tank in range
##[BlueTank:<PathFollow2D#52042925454>] <- this one is only tank in range
##[262.5, 157.5] <- two tanks in range
##[BlueTank:<PathFollow2D#52042925454>, BlueTank2:<PathFollow2D#53619983756>] <-these two are in range
## note: the index of the max progress tank (index = 0 in this case) also identifies the enemy tank to target in the enemy_array (index = 0)
##
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
		
		
	
func fire():
	readyfreddy = false
	#debugprint
	#print(type)
	enemy.on_hit(GameData.tower_data[type]["damage"])
	#creating a timer that waits for the amount of time specified in tahe 'rof' variable
	await(get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	readyfreddy = true
#The await keyword functions the exact same way the old yield keyword does.
# The only thing that changes here is the syntax.
#Before you would use:
#yield(get_tree().create_timer(1.0), "timeout")
#var value = yield(some_function(), "completed")
#Now you simply use:
#await get_tree().create_timer(1.0).timeout
#var value = await some_function()
	
	
	
func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())
	#debugprint
	#print("on-range-body-entered")


func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
