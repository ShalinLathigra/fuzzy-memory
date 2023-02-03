
class_name PlantState extends BaseState
var target: Seed
var next_state: PlantState
var max_duration: float
var elapsed_t: float
func enter():
	pass
func exit():
	pass
func tick(_delta: float):
	pass

class Grow extends PlantState:
	var water_growth_mod: float = 2.0
	var water_inst_jump: float = 1.0
	func enter():
		target.t = 0.0
		target.on_apply.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		var growth_rate = (1.0 / max_duration) + water_growth_mod * target.times_watered
		elapsed_t = minf(elapsed_t + delta * (growth_rate), max_duration)
		target.t = min((elapsed_t + target.times_watered * water_inst_jump) / max_duration, 1.0)
		if target.t >= 1.0:
			target.set_state(target.bloom_state)
	func exit():
		target.current_state = next_state

class Bloom extends PlantState:
	func enter():
		elapsed_t = 0.0
		target.on_bloom.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		elapsed_t = minf(elapsed_t + delta, max_duration)
		if elapsed_t >= max_duration:
			target.set_state(target.wilt_state)
	func exit():
		pass

class Wilt extends PlantState:
	var wilt_duration: float
	func enter():
		target.t = 1.0
		target.on_wither.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		elapsed_t = minf(elapsed_t + delta, max_duration)
		target.t = 1.0 - elapsed_t / max_duration
		if target.t == 0.0:
			target.remove()
