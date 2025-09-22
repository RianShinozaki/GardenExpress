extends RichTextLabel

func _ready() -> void:
	text = "Final Score: %d" % GameController.final_score
