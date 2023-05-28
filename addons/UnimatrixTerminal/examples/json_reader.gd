class_name UnimatrixCommandJsonReader extends UnimatrixCommand

func activate(args: PackedStringArray, logger_callback: Callable):
	if args[0].begins_with('-h'):
		logger_callback.call(self.help())
		return
	
	var target_file = args[0]
	
	var output: Dictionary = UnimatrixProcessor.parse_json(target_file)
	
	logger_callback.call(JSON.stringify(output, '\t'))
