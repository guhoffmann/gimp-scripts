;******************************************************************************
; Create a 'starfield' picture in a new layer of the current image!
; Place this script in:
; 	~/.config/GIMP/2.xx/scripts for normal GIMP installations
;  ~/snap/gimp/current/.config/GIMP/2.xx/scripts for snapcraft installations
;******************************************************************************

;******************************************************************************
; Define the main function for the script

(define
	(script-fu-stars activeImage numStars maxSize sparkle seedStars)
	(let*
		(	;+++ variable declarations for let* block +++

			;all variables declared here!
			(imageHeight (car (gimp-image-height activeImage)))
			(imageWidth (car (gimp-image-width activeImage)))
			(brushSize (car (gimp-context-get-brush-size)))
			(brushName (car (gimp-context-get-brush)))
			(starLayer)
			(starX)
			(starY)
			(starCol)
			(minSize 1)
			(sparkleFak 0.02)
			(sizeDiff (- maxSize minSize))
			(points (cons-array 4 'double))
			(i 0) ;iterator variable

		)	;--- end of variable declarations for let* block ---

		(set! starLayer
			(car
				(gimp-layer-new
					activeImage
					imageWidth
					imageHeight
					RGB-IMAGE
					"StarLayer"
					100
					0 ;don't use NORMAL as in orig. tut 'cause Gimp 2.10 won't recognize it!		
		)))

		;save original context
		(gimp-context-push)

		;start group for undo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(gimp-image-undo-group-start activeImage)

		(gimp-image-add-layer activeImage starLayer 0) ;add layer to image
		(srand seedStars)	;do random seRed
		
		;make the sparkling stars background
		(plug-in-randomize-hurl 1 activeImage starLayer 50 1 FALSE seedStars)
		(gimp-drawable-desaturate starLayer 0)
		(gimp-drawable-levels starLayer 0 (- 1 (* 0.0008 numStars)) 1 TRUE 1 0 1 TRUE)

		;set the white foreground color
		;(gimp-palette-set-foreground '(255 255 255))
		;now draw bigger stars with a brush 'manually'
		(gimp-context-set-brush "2. Hardness 100")

		;do the star drawing loop
		(while (< i numStars)
			(set! starX (random imageWidth))
			(set! starY (random imageHeight))
			(set! starCol (+ 96 (random 160)))
			(gimp-context-set-foreground (list starCol starCol starCol))
			(aset points 0 starX)
			(aset points 1 starY)
			(aset points 2 starX)
			(aset points 3 starY)
			(gimp-context-set-brush-size (+ minSize (random sizeDiff)))
			(gimp-paintbrush-default starLayer 4 points)
			(gimp-progress-update (/ i numStars))
			(set! i (+ i 1))
		)

		;make the stars better visible
		(gimp-drawable-brightness-contrast starLayer 0.5 0.5)

		;now add sparkling details according to selection
		(if (> sparkle 3)
			(set! sparkleFak 0.04)
		)
		(if (> sparkle 0)
			(plug-in-sparkle 1 activeImage starLayer 0.002 0.5 6 4 15 sparkleFak 0.0 0.0 0.0 0 0 0 0 )	
		)
		(if (> sparkle 1)
			(plug-in-sparkle 1 activeImage starLayer 0.002 0.5 8 4 15 sparkleFak 0.0 0.0 0.0 0 0 0 0 )	
		)
		(if (> sparkle 2)
			(plug-in-sparkle 1 activeImage starLayer 0.002 0.5 10 4 15 sparkleFak 0.0 0.0 0.0 0 0 0 0 )	
		)

    	; mark the end of the undo group -----------------------------------------
		(gimp-image-undo-group-end activeImage)

		;restore original settings
		(gimp-context-pop)

		;Flush display to see the result!!!
		(gimp-displays-flush) 
 	
		;--- end of actions for script-fu-stars ---

	);of let*

); of define script-fu-stars

;******************************************************************************
;  Register the function to gimp database

(script-fu-register
	"script-fu-stars"								;func name
	"Starfield"										;menu label
"Add a layer full of stars to the current image.\
If you have an image opened/created, this one adds a layer with a black and white starfield.\
You can create different pseudo random distributed starfields by changing then Random-Seed setting.\
If you set the 'Sparkle' to '0', same Random-Seed always creates the same picture."	;description
	"Uwe Hoffmann"									;author
	"(c) 2019 Uwe Hoffmann"						;copyright notice
	"27. Januar 2019"								;date created
	""													;image type that the script works on
	SF-IMAGE "Image" 0
	SF-ADJUSTMENT "Density" 			'(80 10 300 1 10 0 SF-SPINNER)
	SF-ADJUSTMENT "Star size  max."	'(3 1 5 1 1 0 SF-SPINNER)
	SF-ADJUSTMENT "Sparkle" 			'(2 0 4 1 1 0 SF-SPINNER)
	SF-ADJUSTMENT "Random-Seed"		'(1114 0 111111 1 100 0 SF-SPINNER)
)

;******************************************************************************
; Register how to call script in Gimp

(script-fu-menu-register "script-fu-stars" "<Image>/Uwes-Scripts")

