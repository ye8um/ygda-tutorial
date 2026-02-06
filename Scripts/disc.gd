extends Area2D

const SPEED: int = 225

var x_direction: int = 1
var y_direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += SPEED* x_direction * delta
	position.y += SPEED* y_direction * delta
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.queue_free()
		
	if not body.is_in_group("Player"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
