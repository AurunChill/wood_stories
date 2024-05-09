extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	"""
	Initial setup for the Necromancer, setting the initial state and starting the idle animation.
	"""
	anim.play('idle')
	anim.flip_h = true
