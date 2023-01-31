extends CanvasLayer

var UIQueue = []

func _ready():
	pass

func AddUI(ElementInstance, queue=false):
	if queue == true:
		UIQueue.append(ElementInstance)
		#check if UI is in queue/node
		if UIQueue.size() > 0 and $Queue.get_child_count() <= 0:
			$Queue.add_child(UIQueue[0])
			UIQueue[0].AddToViewport()
			
	else:
		add_child(ElementInstance)
		ElementInstance.AddToViewport()
	pass

func RemoveUI(ElementInstance):
	ElementInstance.queue_free()
	
	UIQueue.pop_front()
	if UIQueue.size() > 0 and $Queue.get_child_count() > 0:
#		yield(get_tree(), "idle_frame")
		yield(get_tree().create_timer(0.05), "timeout")
		$Queue.add_child(UIQueue[0])
		UIQueue[0].AddToViewport()
	
	pass
