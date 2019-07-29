	; guess.asm
	; Guess a number between 0 and 7.
	org 0x0100

	in al,(0x40)	; Read the timer counter
	and al,0x07	; Mask bits so the value becomes 0-7
	add al,0x30	; Convert into ASCII digit
	mov cl,al
game_loop:
	mov al,0x3f	; AL now is question-mark sign
	call display_letter	; Display
	call read_keyboard	; Read keyboard
	cmp al,cl	; AL equals CL?
	jne game_loop	; No, jumps (Jump if Not Equal)
	call display_letter	; Display number
	mov al,0x3a		; Display happy face
	call display_letter
	mov al,0x29
	call display_letter
	; add library1.asm here

	; Save this library as library1.asm
	int 0x20		; Exit to command line.

	; Display letter contained in AL (ASCII code, see appendix B)
display_letter:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	mov ah,0x0e	; Load AH with code for terminal output
	mov bx,0x000f	; Load BH with page zero and BL with color (only graphic mode)
	int 0x10		; Call the BIOS for displaying one letter
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	; Read keyboard into AL (ASCII code, see appendix B)
read_keyboard:
	push bx
	push cx
	push dx
	push si
	push di
	mov ah,0x00	; Load AH with code for keyboard read
	int 0x16		; Call the BIOS for reading keyboard
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	ret

