class_name UnimatrixCommandSpawner extends UnimatrixCommand

@export var entities: Dictionary = {}

var keymap = {
	'-p': set_position.bind(UnimatrixProcessor.parse_vec2)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func parse_vec(val: PackedStringArray):
#	var position_indices = str.split(',')
	var indices = val[0].split(',') 
	if len(indices) == 3:
		return Vector3(indices[0].to_float(), indices[1].to_float(), indices[2].to_float())
	elif  len(indices) == 2:
		return Vector2(indices[0].to_float(), indices[1].to_float())
	else:
		push_error("ERROR: Failed to parse coordinates from input vector: \"%s\"" % val)

func activate(args: PackedStringArray, logger_callback: Callable):
	if args[0].begins_with('-h'):
		logger_callback.call(self.help())
		return
	var target_entity = args[0]
	
	if not entities.has(target_entity):
		var error_str = "ERROR: No entity named \"%s\"" % target_entity
		push_error(error_str)
		logger_callback.call(error_str)
		return
	
	var target = entities.get(target_entity)
	if target is PackedScene:
		var spawned = target.instantiate()
		get_tree().current_scene.add_child(spawned)
		
		logger_callback.call("Spawned %s" % spawned.name)
		
		if len(args) > 1:
			for subcommand in args.slice(1):
				var subcommand_key = subcommand.split('=')[0]
				var subcommand_args = subcommand.split('=').slice(1)
				var f_set_position = self.keymap.get(subcommand_key)
				f_set_position.call(spawned, subcommand_args, logger_callback)

func set_position(entity, position, logger_callback, parser):
	var p: Vector2 = parser.call(position)
	entity.global_position = p
	logger_callback.call("\tat %s" % str(p))
