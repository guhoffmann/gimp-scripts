;******************************************************************************
; Delete all layers marked visible/unvisible!
; Place this script in:
; 	~/.config/GIMP/2.xx/scripts for normal GIMP installations
;  ~/snap/gimp/current/.config/GIMP/2.xx/scripts for snapcraft installations
;******************************************************************************

;******************************************************************************
; Define the main function for the script

(define (script-fu-delete-layers activeImage deleteUnvisible deleteVisible)

	;define local let* namespace
	(let*
		(	;+++ variable declarations for let* block +++
			;all variables declared here!
			(i 0) ;iterator variable
			(numLayers (car (gimp-image-get-layers activeImage)))
			(allLayers (cadr (gimp-image-get-layers activeImage)))
			(aktLayer)
			(item)

		)	;--- end of variable declarations for let* block ---

		(gimp-context-push)

		;start group for undo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		(gimp-image-undo-group-start activeImage)
		
		;display number of Layers
		(gimp-message-set-handler 2)

		;loop over layers
		(while (< i numLayers)
			;get layers item ID
			(set! item (aref allLayers i))
 
			(if (= (car (gimp-item-get-visible item)) 1)
				(if (= deleteVisible 1)
					(gimp-image-remove-layer activeImage item)
				)
				(if (= deleteUnvisible 1)
					(gimp-image-remove-layer activeImage item)
				)
			)
			(set! i (+ i 1)) 
		)

    	;end of the undo group ----------------------------------------------------

		(gimp-image-undo-group-end activeImage)

		;Flush display to see the result!!!
		(gimp-displays-flush) 
		
		(gimp-context-pop)

		;--- end of actions ------------------------------------------------------

	);end of local let* namespace

); of define script-fu-delete-layers

;*******************************************************************************
;  Register the function to gimp database

(script-fu-register
	"script-fu-delete-layers"				;func name
	"Delete all layers"							;menu label
	"Delete all layers visible/unvisible."	;description
	"Uwe Hoffmann"								;author
	"(c) 2019 Uwe Hoffmann"					;copyright notice
	"27. Januar 2019"							;date created
	""												;image type that the script works on
	SF-IMAGE "Image" 0
	SF-TOGGLE "Delete UNVISIBLE layers" 1
	SF-TOGGLE "Delete VISIBLE layers" 0
)

;*******************************************************************************
; Register how to call script in Gimp

(script-fu-menu-register "script-fu-delete-layers" "<Image>/Uwes-Scripts")

