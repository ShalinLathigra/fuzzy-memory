
class_name PlantState extends BaseState
var target: Seed
var max_duration: float
var elapsed_t: float
func init(t: Seed, max_d: float) -> void:
	target = t
	max_duration = max_d
func enter():
	pass
func exit():
	pass
func tick(_delta: float):
	pass

class Grow extends PlantState:
	var water_growth_modifier: float = 2.0
	var increase_on_watered: float = 1.0
	func enter():
		target.t = 0.0
		target.on_apply.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		var growth_rate = 1.0 + water_growth_modifier * target.times_watered
		elapsed_t = minf(elapsed_t + delta * (growth_rate), max_duration)
		target.t = min((elapsed_t + target.times_watered * increase_on_watered) / max_duration, 1.0)
		if target.t >= 1.0:
			target.set_state(target.bloom_state)
	func exit():
		pass

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
		target.on_wilt.emit()
		target.times_watered = 0.0
	func tick(delta: float):
		elapsed_t = minf(elapsed_t + delta, max_duration)
		target.t = 1.0 - elapsed_t / max_duration
		if target.t == 0.0:
			target.remove()
