extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	UnimatrixProcessor.command_logger.connect(update_display)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_display(terminal_output: String):
	self.text += terminal_output
