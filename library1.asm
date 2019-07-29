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

