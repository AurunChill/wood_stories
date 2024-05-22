extends CharacterBody2D

## The AnimatedSprite2D node for controlling animations.
## Automatically initialized when the scene is loaded.
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node is added to the scene.
func _ready():
	# Start the idle animation and flip it horizontally
	anim.play('idle')
	anim.flip_h = true
