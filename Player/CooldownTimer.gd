class_name CooldownTimer extends Node

var cooldown: int
var msec_of_next_use: int

var is_ready : bool :
	get: return Time.get_ticks_msec() > msec_of_next_use

func reset() -> bool:
	msec_of_next_use = Time.get_ticks_msec() + cooldown
	return true
