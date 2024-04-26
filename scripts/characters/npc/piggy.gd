extends CharacterBody2D
class_name Piggy

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var main_char: Main

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: float

enum States {
	FOLLOWING,
	STANDING	
}
var current_state = States.STANDING


func _stand(delta):
	anim.play('idle')
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	
func _follow(delta: float):
	var dir = _update_direction(main_char.is_looking_left)
	_move(delta, dir)
	
	
func _update_direction(is_follow_left: bool) -> int:
	anim.flip_h = is_follow_left
	return -1 if is_follow_left else 1


func _move(delta, dir):
	anim.play('walk')
	velocity.x = dir * speed
	


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


# Engine methods
func _ready():
	_stand(0)
	main_char = get_parent().get_node('main')
	speed = main_char.SPEED - 3
	
	
func _physics_process(delta):
	_apply_gravity(delta)
	match current_state:
		States.STANDING:
			_stand(delta)
		States.FOLLOWING:
			_follow(delta)
	move_and_slide()	
		

func _on_area_2d_body_entered(body):
	if body == main_char:
		current_state = States.STANDING


func _on_area_2d_body_exited(body):
	if body == main_char:
		current_state = States.FOLLOWING
