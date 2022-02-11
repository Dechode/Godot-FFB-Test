extends Control

var is_ffb: bool = false
var is_running: bool = false
var effect_id = -1

var amplitude: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = $ffbplugin.init_ffb(0) # Initializes the haptic subsystem for given device id
	if err < 0:
		print("Cant initialize haptic subsystem, most likely device not haptic")
	is_ffb = $ffbplugin.force_feedback
		
	print("Has force feedback = ",is_ffb)
	
	$AmplitudeSlider.value = amplitude
	$CurrentValue.text = amplitude as String
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var ffb_signal = $AmplitudeSlider.value
	
	if is_running:
#		print(ffb_signal)
#		if $ffbplugin.update_constant_force_effect(ffb_signal, 0) != 0:
		if $ffbplugin.update_constant_force_effect(ffb_signal, effect_id) != 0:
			print("Updating constant force effect failed!")
			is_running = false
		$ColorRect.color = Color.green
	else:
		$ColorRect.color = Color.red
#		$ffbplugin.destroy_ffb_effect(effect_id)


func _on_AmplitudeSlider_value_changed(value: float) -> void:
	amplitude = value
	$CurrentValue.text = value as String


func _on_StartBtn_pressed() -> void:
	# TODO If more than 1 cf effects are initialized, this project does not work as intented
	effect_id = $ffbplugin.init_constant_force_effect() # Initializes constant force effect and returns its effect_id
	if effect_id < 0:
		print("Error initialising constant force effect")
		is_running = false
#	if $ffbplugin.play_constant_force_effect(effect_id, 0) < 0: # Second parameter is how many times the effect is played. 0 == infinite
	elif $ffbplugin.play_constant_force_effect(effect_id, 0) < 0: # Second parameter is how many times the effect is played. 0 == infinite
		print("Starting ffb effect failed")
		is_running = false
	else:
		is_running = true
#	is_running = true


func _on_StopBtn_pressed() -> void:
	is_running = false
	$ffbplugin.destroy_ffb_effect(effect_id)
	effect_id = -1
	

