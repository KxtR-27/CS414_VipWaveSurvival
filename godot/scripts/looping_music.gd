class_name LoopingMusic
extends Resource

@export var start: AudioStream
@export var loop: AudioStream
@export var end: AudioStream

@export_group("Debug")

## warns that [code]start[/code] and [code]end[/code] segments don't exist 
## when trying to [code]play_start()[/code] or [code]play_end()[/code] respectively. 
## regardless of this check, the player will play the looping segment in this case.
## [br][br]
## if your Looping Music [b]intentionally[/b] lacks a starting and/or ending segment,
## [b]disable this[/b]. Otherwise, [b]leave this checked[/b].
@export var push_missing_segment_warnings: bool = true
