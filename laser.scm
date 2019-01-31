;********************************************************************
;Textbox demo script from gimp official scripting tutorial!
;Commented from/for myself to get a better understanding.
;Place this script in your ~/.config/GIMP/2.xx/scripts directory.
;********************************************************************

(define
	(script-fu-laser activeImage activeDrawable color haloSize)
	(let*
		(
			; Aktiven Pfad holen
			(activePath (car (gimp-image-get-active-vectors activeImage)))
			(brushSize (car (gimp-context-get-brush-size)))
		)

		(gimp-context-push)

		(gimp-image-undo-group-start activeImage)

		;Hintergrundfarbe holen, Halo malen
    	(gimp-context-swap-colors)
		(gimp-context-set-brush-size (* brushSize haloSize) )
		(gimp-context-set-brush "2. Hardness 025")
    	(gimp-edit-stroke-vectors activeDrawable activePath)
    
    	;Grösse verkleinern, Farbe einstellen, Strahl malen
    	(gimp-context-swap-colors)
    	(gimp-context-set-brush-size brushSize)
		(gimp-context-set-brush "2. Hardness 050")
    	(gimp-edit-stroke-vectors activeDrawable activePath)
    
    	;Gausschen Weichzeichner
    	;pdb.plug_in_gauss(pic, layer, smudge, smudge, 0)
    
	 	;Flush display to see the result!!!
		(gimp-displays-flush) 

 		(gimp-image-undo-group-end activeImage)

		(gimp-context-pop)
 
 		; -- end of actions

	);of let*
); of define = end of the function script-fu-text-box

;Register the function to gimp database
(script-fu-register
	"script-fu-laser"								;func name
	"Einfacher Laser-Effekt"					;menu label
	"Lichtstrahl auf Pfad erzeugen"			;description
	"Uwe Hoffmann"									;author
	"(c) 2019 Uwe Hoffmann"						;copyright notice
	"27. Januar 2019"								;date created
	""													;image type that the script works on
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-COLOR "Color" '(128 128 255)
	SF-ADJUSTMENT "Halogröße" (list 2 1 5 0.2 10 1 SF-SPINNER)
)

;Register how to call script in Gimp
(script-fu-menu-register "script-fu-laser" "<Image>/Uwes")

