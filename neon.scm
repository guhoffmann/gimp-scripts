;********************************************************************
; Mimic a simple neon light
; Place this script in:
; 	~/.config/GIMP/2.xx/scripts for normal GIMP installations
;  ~/snap/gimp/current/.config/GIMP/2.xx/scripts for snapcraft installations
;******************************************************************************

(define
	(script-fu-neon activeImage activeDrawable haloSize)
	(let*
		(
			(activePath (car (gimp-image-get-active-vectors activeImage)))
			(brushSize (car (gimp-context-get-brush-size)))
			(color (car (gimp-context-get-foreground)))
			(backColor (list (* 0.5 (car color)) (* 0.5 (cadr color)) (* 0.5 (caddr color))) )
		)

		(gimp-context-push)

		(gimp-image-undo-group-start activeImage)

		;draw the halo
		(gimp-context-set-brush "2. Hardness 025")
		(gimp-context-set-foreground backColor)
		(gimp-context-set-brush-size (* brushSize haloSize) )
    	(gimp-edit-stroke-vectors activeDrawable activePath)

    	;draw the smaller beam for lamp
		(gimp-context-set-brush "2. Hardness 025")
    	(gimp-context-set-foreground color)
    	(gimp-context-set-brush-size brushSize)
    	(gimp-edit-stroke-vectors activeDrawable activePath)
    
 		(gimp-image-undo-group-end activeImage)

		(gimp-displays-flush)

		(gimp-context-pop)
 
 		; -- end of actions

	);of let*

); of define script-fu-neon

;Register the function to gimp database
	
(script-fu-register
	"script-fu-neon"					;func name
	"Neon light"						;menu label
	"Mimic a simple neon light"	;description
	"Uwe Hoffmann"						;author
	"(c) 2019 Uwe Hoffmann"			;copyright notice
	"27. Januar 2019"					;date created
	""										;image type that the script works on
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-ADJUSTMENT "Halo size" '(2 1 5 0.2 10 1 SF-SPINNER)
)

;Register how to call script in Gimp
(script-fu-menu-register "script-fu-neon" "<Image>/Uwes-Scripts")

