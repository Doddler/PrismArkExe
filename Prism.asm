format binary as 'exe'
use32

include 'patching.inc'

patchfile 'P_ARK200_orig.exe'

;--------------------------------------------
; Addressing stuff
;--------------------------------------------

IMAGE_BASE = 0x00400000
TEXT_VOFFSET = 0x00001000
TEXT_ROFFSET = 0x00001000
PATCH_VOFFSET = 0x00476000
PATCH_ROFFSET = 0x00178000

TEXT_ORG = IMAGE_BASE + TEXT_VOFFSET - TEXT_ROFFSET
PATCH_ORG = + IMAGE_BASE + PATCH_VOFFSET - PATCH_ROFFSET

;--------------------------------------------
; Patching!
;--------------------------------------------

FontSize = 0x0066C948


patchsection TEXT_ORG

;patch the centering code
patchat (0x454F00 - TEXT_ORG)

	call ChangeCentering
	add esp, 0x20 			;this was in the original code, but we don't want it as part of the call for obvious reasons

patchuntil (0x454F18 - TEXT_ORG)



;patch the character spacing
patchat (0x454F4E - TEXT_ORG)

	call ChangeSpacing

patchuntil (0x454F57 - TEXT_ORG)


patchsection PATCH_ORG

patchat (0x876000 - PATCH_ORG)

ChangeCentering:
	mov eax, [ebp+0]		;load character count into eax
	mov ecx, eax			;move eax into ecx
	mov ebx, [FontSize]		;put font size into eax
	shr ebx, 1				;divide font size by 2 (shift right by 1)
	imul ecx, ebx			;multiply ecx (character count) by ebx (font size / 2), result goes into ecx
	mov ebx, 0x320			;put 800 into ebx
	sub ebx, ecx			;subtract 800 by ecx
	shr ebx, 1				;divide that result by 2 (shift right by 1)
	retn

ChangeSpacing:
	mov eax, [FontSize]
	shr eax, 1				;the only new line, divide font size by 2
	mov ecx, [ebp+0]
	add ebx, eax
	retn

patchend