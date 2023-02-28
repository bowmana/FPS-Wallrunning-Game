extends Node


func play_sfx(sound: AudioStream, parent: Node):
	if sound != null and parent != null:
		var stream = AudioStreamPlayer.new()
		
		stream.stream = sound
		
		stream.connect("finished", stream, "queue_free")
#		stream.connect("tree_exited", stream, "queue_free")
		
		parent.add_child(stream)
		stream.play()


func play_sfx_3d(sound: AudioStreamPlayer3D, parent: Node, position: Vector3):
	if sound != null and parent != null:
		var stream = AudioStreamPlayer3D.new()
		stream.stream = sound
		stream.global_position = position
		stream.connect("finished", stream, "queue_free")
#		stream.connect("tree_exited", stream, "queue_free")
		
		parent.add_child(stream)
		stream.play()
