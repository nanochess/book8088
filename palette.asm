	;
	; Show the VGA palette
	; by Oscar Toledo G.
	; Creation date: Jun/27/2019.
	;

	cpu 8086
	
	org 0x0100

        ;
        ; Memory screen uses 64000 pixels,
        ; this means 0xfa00 is the first byte of
        ; memory not visible on the screen.
        ;
v_a:    equ 0xfa00
v_b:    equ 0xfa02

start:
        mov ax,0x0013   ; Set mode 320x200x256
        int 0x10        ; Video interruption vector

        mov ax,0xa000   ; 0xa000 video segment
        mov ds,ax       ; Setup data segment
        mov es,ax       ; Setup extended segment

m4:
        mov ax,127      ; 127 as row
        mov [v_a],ax    ; Save into v_a
m0:     mov ax,127      ; 127 as column
        mov [v_b],ax    ; Save into v_b

m1:
        mov ax,[v_a]    ; Get Y-coordinate
        mov dx,320      ; Multiply by 320 (size of pixel row)
        mul dx
        add ax,[v_b]    ; Add X-coordinate to result
        xchg ax,di      ; Pass AX to DI

        mov ax,[v_a]    ; Get current Y-coordinate
        and ax,0x78     ; Separate 4 bits = 16 rows
        add ax,ax       ; Value between 0x00 and 0xf0

        mov bx,[v_b]    ; Get current X-coordinate
        and bx,0x78     ; Separate 4 bits = 16 columns 
        mov cl,3        ; Shift right by 3 places
        shr bx,cl
        add ax,bx       ; Combine with previous value

        stosb           ; Write AL into address pointed by DI
        
        dec word [v_b]  ; Decrease column
        jns m1          ; Is it negative? No, jump
        
        dec word [v_a]  ; Decrease row
        jns m0          ; Is it negative? No, jump

        mov ah,0x00     ; Wait for a key
        int 0x16        ; Keyboard interruption vector.

        mov ax,0x0002   ; Set mode 80x25 text.
        int 0x10        ; Video interruption vector.

        int 0x20        ; Exit to command-line.


