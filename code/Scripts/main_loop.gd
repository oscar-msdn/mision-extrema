extends SceneTree
class_name CustomLoop

var time_elapsed = 0
var keys_typed = []
var quit = false

func _initialize():
	print("Initialized:")
	print("  Starting time: %s" % str(time_elapsed))

func _idle(delta) -> bool:
	time_elapsed += delta
	# Return true to end the main loop.
	print("Idle")
	return quit

# warning-ignore:unused_argument
func _iteration(delta) -> bool:
	print("iteration")
	return quit

# warning-ignore:unused_argument
func _input_event(event):
	# Record keys.
#    if event is InputEventKey and event.pressed and !event.echo:
#        keys_typed.append(OS.get_scancode_string(event.scancode))
#        # Quit on Escape press.
#        if event.scancode == KEY_ESCAPE:
#            quit = true
#    # Quit on any mouse click.
#    if event is InputEventMouseButton:
#        quit = true
 print("Input")

func _finalize():
	print("Finalized:")
	print("  End time: %s" % str(time_elapsed))
	print("  Keys typed: %s" % var2str(keys_typed))
