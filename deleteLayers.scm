;******************************************************************************
; Delete all layers marked visible!
; Place this script in:
; 	~/.config/GIMP/2.xx/scripts for normal GIMP installations
;  ~/snap/gimp/current/.config/GIMP/2.xx/scripts for snapcraft installations
;******************************************************************************

;******************************************************************************
; Define the main function for the script

(define
	(script-fu-delete-layers activeImage)
	(let*
		(	;+++ variable declarations for let* block +++
			;all variables declared here!
			(i 0) ;iterator variable
			(numLayers (car (gimp-image-get-layers activeImage)))
			(allLayers (cadr (gimp-image-get-layers activeImage)))
			(aktLayer)
			(item)

		)	;--- end of variable declarations for let* block ---

		;start group for undo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(gimp-image-undo-group-start activeImage)

		;display number of Layers
		;(gimp-message (string-append "Num. of Layers: " (number->string numLayers)))
		
		(while (< i numLayers)
			;(set! aktLayer (cadr (gimp-image-get-layers activeImage)))
			;(set! aktLayer (car allLayers))
			(set! item (aref allLayers i))

			;(if (equal? (gimp-item-get-visible item) 0)
				(gimp-image-remove-layer activeImage item)
			;)
			;(set! allLayers (cdr allLayers))
			(set! i (+ i 1)) 
		)
    	; mark the end of the undo group -----------------------------------------
		(gimp-image-undo-group-end activeImage)

		;Flush display to see the result!!!
		(gimp-displays-flush) 
 	
		;--- end of actions for script-fu-laser ---

	);of let*

); of define

;******************************************************************************
;  Register the function to gimp database

(script-fu-register
	"script-fu-delete-layers"					;func name
	"Delete Layers"								;menu label
	"Delete all layers marked visible."		;description
	"Uwe Hoffmann"									;author
	"(c) 2019 Uwe Hoffmann"						;copyright notice
	"27. Januar 2019"								;date created
	""													;image type that the script works on
	SF-IMAGE "Image" 0
	;SF-TOGGLE "Dummy" 1
)

;******************************************************************************
; Register how to call script in Gimp

(script-fu-menu-register "script-fu-delete-layers" "<Image>/Uwes")

