extends BaseNPC

## The AnimatedSprite2D node for controlling animations.
## Automatically initialized when the scene is loaded.

# Called when the node is added to the scene.
func _ready():
	# Start the idle animation and flip it horizontally
	anim.play('idle')
	anim.flip_h = true
