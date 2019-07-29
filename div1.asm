	; div1.asm
	org 0x0100
start:
	mov ax,0x64	; Load register AX with 0x64 (100 decimal)
	mov cl,0x21	; Load register CL with 0x1e (33 decimal)
	div cl			; Divide AX by CL, result into AL, remainder in AH
        mov al,ah
	;
	add al,0x30	; Convert to ASCII digit
	call display_letter
	; Add library1.asm here
	; Save this library as library1.asm
	int 0x20		; Exit to command line.

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
