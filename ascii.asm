	;
	; Create an ASCII chart
	; by Oscar Toledo G.
	; Creation date: Jun/27/2019.
	;

	cpu 8086

	org 0x7c00	; Start for boot sector
	
	mov ax,0x0002	; Text mode 80x25
	int 0x10	; Set video mode

	mov ax,0xb800	; Screen segment
	mov ds,ax	; Load for using it
	mov es,ax

	xor di,di	; DI = 0x0000
	mov cx,0x07d0	; CX = 2000 characters
	mov ax,0xf020	; AX = Black on white
	rep stosw	; Fill the screen

	mov di,0x00a4	; Point to row 1, column 2
	mov al,0x00	; AL = Character 0x00
a1:
	push di		; Save current address
	push ax		; Save current letter
	mov cl,4	; Take high nibble
	shr al,cl
	add al,0x30	; Convert to ASCII
	cmp al,0x3a	; Higher than 9?
	jb a3		; No, jump
	add al,0x07	; Add 7 to make it a letter
a3:	stosb		; Put on screen
	inc di		; Avoid attribute

	pop ax
	push ax
	and al,0x0f	; Take lower nibble
	add al,0x30	; Convert to ASCII
	cmp al,0x3a	; Higher than 9?
	jb a4		; No, jump
	add al,0x07	; Add 7 to make it a letter
a4:	stosb		; Put on screen
	inc di		; Avoid attribute

	mov al,0x2d	; Hyphen
	stosb		; Put on screen
	inc di		; Avoid attribute

	inc di		; Jump one letter
	inc di
	pop ax
	stosb		; Put current letter
	pop di		; Restore address
	inc al		; Next letter
	jz a2		; Jump if zero (ending)

	add di,0x00a0	; Go to next line
	cmp di,0x0fa0	; Reached end of screen?
	jb a1		; No, jump.
	sub di,0x0f00-14  ; Go back 24 lines
	               ; and move 7 columns to right.
	jmp a1         ; Repeat cycle.

a2:	jmp $          ; Completed.

	times 510-($-$$) db 0x4f   ; Fill boot sector

	db 0x55,0xaa   ; Make it bootable
