
(
	global collisionGen

	try destroyDialog collisionGen catch()	
	
	
rollout collisionGen "UE4 Collision Gen" width:162 height:141
(
	button 'createButton' "Create Collision" pos:[13,18] width:122 height:29 align:#left
	progressBar 'pb1' "ProgressBar" pos:[14,86] width:122 height:29 align:#left
	label 'lbl1' "Progress" pos:[14,52] width:122 height:29 align:#left
	
	on createButton pressed do
	(
		pb1.value = 0
		for obj in $ do (
			if convertToPoly obj != undefined do (						
				
				lbl1.text = "Exploding elements"
				
				elements = #()
				index = 1
				
				while polyOp.getNumFaces obj != 0 do (
					local f_list = polyOp.getElementsUsingFace obj #{1}
					newName = (index as string)
					local elem = polyOp.detachFaces obj f_list asNode:true name:(newName)
	
					append elements newName
					index+=1
					pb1.value = index
				) 		
				
				lbl1.text = "Generating bounding boxes"
	
				for i=1 to elements.count do (
					pb1.value = 100.*i/elements.count
					local o = getnodebyname elements[i]
					centerPivot o
					worldAlignPivot o
					resetXForm o
					bounds = o.max - o.min
					boundingBox = box()
					boundingBox.width = bounds.x
					boundingBox.height = bounds.z
					boundingBox.length = bounds.y					
					boundingBox.name = "UBX_"+obj.name+"_"+(i as string)
					centerPivot boundingBox
					worldAlignPivot boundingBox
					resetXForm boundingBox
					boundingBox.position = o.position
					polyop.attach obj o
				)				
				
				lbl1.text = "done"
			)
		)
	)
)

createDialog collisionGen
)