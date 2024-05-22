class_name States
## States class that holds different possible states for a character.
## This class encapsulates the various states that a character can be in.
## Each state is a constant string value.

class Character:
	## Default state of the character.
	const DEFAULT: String = 'default'
	
	## State when the character is moving to a point.
	const MOVING_TO_POINT: String = 'moving_to_point'

	## State indicating the character is ready to enter a dialogue.
	const READY_TO_DIALOGUE: String = 'ready_to_dialogue'

	## State indicating the character is disabled.
	const DISABLED: String = 'disabled'

	## State when the character is following another entity.
	const FOLLOWING: String = 'following'

	## State when the character is in a fight.
	const FIGHT: String = 'fight'
