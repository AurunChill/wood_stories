extends BaseNPC
class_name Skeleton
## Code of skeleton npc

## Called when the node enters the scene tree for the first time.
func _ready():
	# Play the idle animation
	anim.play('idle')
