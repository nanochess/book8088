    ;
    ; Tic-Tac-Toe
    ; by Oscar Toledo G.
    ; Creation date: Jun/21/2019
    ;
    org 0x0100

board:  equ 0x0300

start:
    mov bx,board    
    mov cx,9
    mov al,'1'
b09:
    mov [bx],al
    inc al
    inc bx
    loop b09

b10:
    call show_board

    call find_line

    call get_movement
    mov byte [bx],'X'

    call show_board

    call find_line

    call get_movement
    mov byte [bx],'O'

    jmp b10

show_board:
    mov bx,board
    call show_row
    call show_div
    mov bx,board+3
    call show_row
    call show_div
    mov bx,board+6
    jmp show_row

show_row:
    call show_square
    mov al,0x7c
    call display_letter
    call show_square
    mov al,0x7c
    call display_letter
    call show_square
show_crlf:
    mov al,0x0d
    call display_letter
    mov al,0x0a
    jmp display_letter

show_div:
    mov al,0x2d
    call display_letter
    mov al,0x2b
    call display_letter
    mov al,0x2d
    call display_letter
    mov al,0x2b
    call display_letter
    mov al,0x2d
    call display_letter
    jmp show_crlf

show_square:
    mov al,[bx]
    inc bx
    jmp display_letter

get_movement:
    call read_keyboard
    cmp al,0x1b		; Esc key pressed?
    je do_exit		; Yes, exit
    sub al,0x31		; Subtract code for ASCII digit 1
    jc get_movement	; Is it less than? Wait for another key
    cmp al,0x09		; Comparison with 9
    jnc get_movement	; Is it greater than or equal to? Wait
    cbw			; Expand AL to 16 bits using AH.
    mov bx,board	; BX points to board
    add bx,ax		; Add the key entered
    mov al,[bx]		; Get square content
    cmp al,0x40		; Comparison with 0x40
    jnc get_movement	; Is it greater than or equal to? Wait
    call show_crlf	; Line change
    ret			; Return, now BX points to square

do_exit:
    int 0x20		; Exit to command-line

find_line:
    mov al,[board]
    cmp al,[board+1]
    jne b01
    cmp al,[board+2]
    je won
b01:
    cmp al,[board+3]
    jne b04
    cmp al,[board+6]
    je won
b04:
    cmp al,[board+4]
    jne b05
    cmp al,[board+8]
    je won
b05:
    mov al,[board+3]
    cmp al,[board+4]
    jne b02
    cmp al,[board+5]
    je won
b02:    
    mov al,[board+6]
    cmp al,[board+7]
    jne b03
    cmp al,[board+8]
    je won
b03:
    mov al,[board+1]
    cmp al,[board+4]
    jne b06
    cmp al,[board+7]
    je won
b06:
    mov al,[board+2]
    cmp al,[board+5]
    jne b07
    cmp al,[board+8]
    je won
b07:
    cmp al,[board+4]
    jne b08
    cmp al,[board+6]
    je won
b08:
    ret

won:
    ; At this point AL contains the letter which made the line
    call display_letter
    mov al,0x20
    call display_letter
    mov al,0x77
    call display_letter
    mov al,0x69
    call display_letter
    mov al,0x6e
    call display_letter
    mov al,0x73
    call display_letter
    int 0x20

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

