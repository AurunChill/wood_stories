extends AnimatedSprite2D
class_name Skeleton
## Code of skeleton npc

## Called when the node enters the scene tree for the first time.
func _ready():
	# Play the idle animation
	self.play('idle')
