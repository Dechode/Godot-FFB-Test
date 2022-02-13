extends Control

var is_ffb: bool = false
var is_running: bool = false
var effect_id = -1

var amplitude: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $ffbplugin.init_ffb(0) < 0: # Initializes the haptic subsystem for given device id
		print("Cant initialize haptic subsystem, most likely device not haptic")
	is_ffb = $ffbplugin.force_feedback
		
	print("Has force feedback = ",is_ffb)
	
	$AmplitudeSlider.value = amplitude
	$CurrentValue.text = amplitude as String
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	amplitude = $AmplitudeSlider.value
	
	if is_running:
		if $ffbplugin.update_constant_force_effect(amplitude, 0, effect_id) != 0:
			print("Updating constant force effect failed!")
			is_running = false
	$RunningLabel.text = "Running = " + str(is_running)


func _on_AmplitudeSlider_value_changed(value: float) -> void:
	amplitude = value
	$CurrentValue.text = value as String


func _on_StartBtn_pressed() -> void:
	if !is_running:
		effect_id = $ffbplugin.init_constant_force_effect() # Initializes constant force effect and returns its effect_id
	
	if effect_id < 0:
		print("Error initialising constant force effect")
		is_running = false
	
	elif $ffbplugin.play_constant_force_effect(effect_id, 1) < 0: # Second parameter is how many times the effect is played. 0 == infinite
		print("Starting ffb effect failed")
		is_running = false
	
	else:
		is_running = true


func _on_StopBtn_pressed() -> void:
	is_running = false
	$ffbplugin.destroy_ffb_effect(effect_id)
	effect_id = -1
	

