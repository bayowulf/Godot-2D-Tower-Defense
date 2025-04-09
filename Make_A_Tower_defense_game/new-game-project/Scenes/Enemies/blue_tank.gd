extends PathFollow2D

var speed = 150
var hp = 50

func _physics_process(delta):
	move(delta)
	
# delta is seconds, so speed(m/s) * delta(s) = meters which is the additional distance along the path.
func move(delta):
	#set_progress(get_progress() + speed * delta)
	progress += speed * delta
	#print('PROGRESS')
	#print(progress)
func on_hit(damage):
	hp -= damage
	if hp <=0:
		on_destroy()
		
func on_destroy():
	self.queue_free()

	
