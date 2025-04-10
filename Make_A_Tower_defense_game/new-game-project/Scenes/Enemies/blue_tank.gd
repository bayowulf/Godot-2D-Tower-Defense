extends PathFollow2D

var speed = 150
var hp = 50
@onready var health_bar = get_node("HealthBar")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	get_node("HealthBar").set_as_top_level(true)


func _physics_process(delta):
	move(delta)
	
# delta is seconds, so speed(m/s) * delta(s) = meters which is the additional distance along the path.
func move(delta):
	#set_progress(get_progress() + speed * delta)
	progress += speed * delta
	health_bar.set_position(position - Vector2(30, 30))
	#print('PROGRESS')
	#print(progress)
func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <=0:
		on_destroy()
		
func on_destroy():
	self.queue_free()

	
