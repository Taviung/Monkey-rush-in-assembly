.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc

public start

.data

area_width EQU 243
area_height EQU 610
area DD 0
window_title db "MINION RUSH 2D",0
counter DD 0 

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

positiony dd 520
positionx dd 43

sped dd 10 ;select between 10 and 20 for dificulty (10 - easy, 20 - hard);
shft dd 0
shft1 dd 120
shft2 dd 300
shft3 dd 20
shft4 dd 380
shft5 dd 240
shft6 dd 400

bana dd 100
bana1 dd 260
bana2 dd 200
bana3 dd 60
bana4 dd 460
bana5 dd 40

symbol_width EQU 10
symbol_height EQU 20

monkey_width EQU 37
monkey_height EQU 31

block_width equ 37
block_height equ 40

banana_width equ 37
banana_height equ 31

include digits.inc
include letters.inc
include assets.inc

.code

make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] 
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] 
	mov eax, [ebp+arg4] 
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] 
	shl eax, 2 
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_monkey proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, monkey
	
draw_image:
	mov ecx, monkey_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, monkey_height
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, monkey_width; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_monkey endp

make_monkey_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_monkey
	add esp, 12
endm

make_block proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, block
	
draw_image:
	mov ecx, block_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, block_height
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, block_width; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_block endp

; a macro to call the drawing function
make_block_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_block
	add esp, 12
endm

make_banana proc
	push ebp
	mov ebp, esp
	pusha

	lea esi, banana
	
draw_image:
	mov ecx, banana_height
loop_draw_lines:
	mov edi, [ebp+arg1] ; pointer to pixel area
	mov eax, [ebp+arg3] ; pointer to coordinate y
	
	add eax, banana_height
	sub eax, ecx ; current line to draw (total - ecx)
	
	mov ebx, area_width
	mul ebx	; get to current line
	
	add eax, [ebp+arg2] ; get to coordinate x in current line
	shl eax, 2 ; multiply by 4 (DWORD per pixel)
	add edi, eax
	
	push ecx
	mov ecx, banana_width; store drawing width for drawing loop
	
loop_draw_columns:

	push eax
	mov eax, dword ptr[esi] 
	mov dword ptr [edi], eax ; take data from variable to canvas
	pop eax
	
	add esi, 4
	add edi, 4 ; next dword (4 Bytes)
	
	loop loop_draw_columns
	
	pop ecx
	loop loop_draw_lines
	popa
	
	mov esp, ebp
	pop ebp
	ret
make_banana endp

; simple macro to call the procedure easier
make_banana_macro macro drawArea, x, y
	push y
	push x
	push drawArea
	call make_banana
	add esp, 12
endm

line_vertical macro x,y,len,color
local bucla_linie
	mov eax, y; eax=y
	mov ebx, area_width
	mul ebx ;eax=y*area_width
	add eax, x
	shl eax,2
	add eax, area
	mov ecx,len
bucla_linie:
	mov dword ptr[eax],color
	mov dword ptr[eax+4],color
	mov dword ptr[eax+8],color
	add eax,area_width*4
	loop bucla_linie
endm
 
; function to draw - it's being called on every click
; or at every 200ms interval in which no click has been recorded
; arg1 - evt (0 - initialize, 1 - click, 2 - time has passed with nothig being recorded, 3 - a key was pressed)
; arg2 - x (in the case that a key has been pressed, x contains the ascii code of the key)
; arg3 - y
	
draw proc
	;block_banana_movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push ebp
	mov ebp, esp
	pusha
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	
   mov eax,sped
   
	add shft,eax
	add shft1,eax
	add shft2,eax
	add shft3,eax
	add shft4,eax
	add shft5,eax
	add shft6,eax
	add bana,eax
	add bana1,eax
	add bana2,eax
	add bana3,eax
	add bana4,eax
	add bana5,eax
	
	
	cmp shft,area_height-block_height-10
	jz zero
	cmp shft1,area_height-block_height-10
	jz zero1
	cmp shft2,area_height-block_height-10
	jz zero2
	cmp shft3,area_height-block_height-10
	jz zero3
	cmp shft4,area_height-block_height-10
	jz zero4
	cmp shft5,area_height-block_height-10
	jz zero5
	cmp shft6,area_height-block_height-10
	jz zero6
	
	cmp bana,area_height-block_height-10
	jz zero7
	cmp bana1,area_height-block_height-10
	jz zero8
	cmp bana2,area_height-block_height-10
	jz zero9
	cmp bana3,area_height-block_height-10
	jz zero10
	cmp bana4,area_height-block_height-10
	jz zero11
	cmp bana5,area_height-block_height-10
	jz zero12
	jmp past_zero
	
	zero:
	mov shft,0
	jmp past_zero
	zero1:
	mov shft1,0
	jmp past_zero
	zero2:
	mov shft2,0
	jmp past_zero
	zero3:
	mov shft3,0
	jmp past_zero
	zero4:
	mov shft4,0
	jmp past_zero
	zero5:
	mov shft5,0
	jmp past_zero
	zero6:
	mov shft6,0
	jmp past_zero
	
	zero7:
	mov bana,0
	jmp past_zero
	zero8:
	mov bana1,0
	jmp past_zero
	zero9:
	mov bana2,0
	jmp past_zero
	zero10:
	mov bana3,0
	jmp past_zero
	zero11:
	mov bana4,0
	jmp past_zero
	zero12:
	mov bana5,0

	past_zero:
	

game:

	mov ebx, 10
	mov eax, counter
	
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 100, 590

	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 90, 590
	
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 80, 590
	make_text_macro 'S',area,20,590
	make_text_macro 'C',area,30,590
	make_text_macro 'O',area,40,590
	make_text_macro 'R',area,50,590
	make_text_macro 'E',area,60,590
	
	line_vertical 0,0,area_height-20,096B00h
	line_vertical area_width/6,0,area_height-20,096B00h
	line_vertical area_width/6*2,0,area_height-20,096B00h
	line_vertical area_width/6*3,0,area_height-20,096B00h
	line_vertical area_width/6*4,0,area_height-20,096B00h
	line_vertical area_width/6*5,0,area_height-20,096B00h
	line_vertical area_width/6*6,0,area_height-20,096B00h
	
	;comparison;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 mov eax, positionx
	 mov ebx, 490
	
	cmp ebx,shft
	jg past_ver
	cmp eax,3
	jl past_ver
	cmp ebx,shft+block_height
	jl past_ver
	cmp eax,3+block_width
	jg past_ver
	
	add positionx,1000000
	past_ver:
	
	cmp ebx,shft1
	jg past_ver1
	cmp eax,43
	jl past_ver1
	cmp ebx,shft1+block_height
	jl past_ver1
	cmp eax,43+block_width
	jg past_ver1
	
	add positionx,1000000
	
	past_ver1:
	
	cmp ebx,shft2
	jg past_ver2
	cmp eax,83
	jl past_ver2
	cmp ebx,shft2+block_height
	jl past_ver2
	cmp eax,83+block_width
	jg past_ver2
	
	add positionx,1000000
	past_ver2:
	
	cmp ebx,shft3
	jg past_ver3
	cmp eax,123
	jl past_ver3
	cmp ebx,shft3+block_height
	jl past_ver3
	cmp eax,123+block_width
	jg past_ver3
	
	add positionx,1000000
	past_ver3:
	
	cmp ebx,shft4
	jg past_ver4
	cmp eax,163
	jl past_ver4
	cmp ebx,shft4+block_height
	jl past_ver4
	cmp eax,163+block_width
	jg past_ver4
	
	add positionx,1000000
	past_ver4:
	
	cmp ebx,shft6
	jg past_ver6
	cmp eax,3
	jl past_ver6
	cmp ebx,shft6+block_height
	jl past_ver6
	cmp eax,3+block_width
	jg past_ver6
	
	add positionx,1000000
	past_ver6:
	
	cmp ebx,shft5
	jg past_ver5
	cmp eax,203
	jl past_ver5
	
	add positionx,1000000
	past_ver5:
	
	cmp ebx,bana
	jg past_bana
	cmp eax,123
	jl past_bana
	cmp ebx,bana+banana_height
	jl past_bana
	cmp eax,123+banana_width
	jg past_bana
	
	inc counter
	past_bana:
	
	cmp ebx,bana1
	jg past_bana1
	cmp eax,43
	jl past_bana1
	cmp ebx,bana1+banana_height
	jl past_bana1
	cmp eax,43+banana_width
	jg past_bana1
	
	inc counter
	past_bana1:
	
	cmp ebx,bana2
	jg past_bana2
	cmp eax,163
	jl past_bana2
	cmp ebx,bana2+banana_height
	jl past_bana2
	cmp eax,163+banana_width
	jg past_bana2
	
	inc counter
	past_bana2:
	
	cmp ebx,bana3
	jg past_bana3
	cmp eax,203
	jl past_bana3
	cmp ebx,bana3+banana_height
	jl past_bana3
	cmp eax,203+banana_width
	jg past_bana3
	
	inc counter
	past_bana3:
	
	cmp ebx,bana4
	jg past_bana4
	cmp eax,3
	jl past_bana4
	cmp ebx,bana4+banana_height
	jl past_bana4
	cmp eax,3+banana_width
	jg past_bana4
	
	inc counter
	past_bana4:
	
	cmp ebx,bana5
	jg past_bana5
	cmp eax,83
	jl past_bana5
	cmp ebx,bana5+banana_height
	jl past_bana5
	cmp eax,83+banana_width
	jg past_bana5
	
	inc counter
	past_bana5:
	
	;movement;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	cmp dword ptr[ebp+arg2],'A'
	je left
	cmp dword ptr[ebp+arg2],'D'
	je right
	jmp past_game	
	
	left:
	cmp positionx,10
	jle past_game
	sub positionx,40
	jmp past_game
	
	right:
	cmp positionx,area_width-40
	jge past_game
	add positionx,40
	jmp past_game
		
	
past_game:
make_block_macro area,3,shft
make_block_macro area,40*1+3,shft1
make_block_macro area,40*2+3,shft2
make_block_macro area,40*3+3,shft3
make_block_macro area,40*4+3,shft4
make_block_macro area,40*5+3,shft5
make_block_macro area,3,shft6

make_banana_macro area, 123,bana
make_banana_macro area, 43,bana1
make_banana_macro area, 163,bana2
make_banana_macro area, 203,bana3
make_banana_macro area, 3,bana4
make_banana_macro area, 83,bana5


make_monkey_macro area,positionx,positiony

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp


start:
	;memory for drawing
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;drawing function
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;end of program
	push 0
	call exit
end start
