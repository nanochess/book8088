        ;
        ; Draw a Mandelbrot set
        ; by Oscar Toledo G.
        ; Creation date: Jun/24/2019.
        ;

        cpu 8086        ; NASM warns us of non-8086 instructions

        org 0x0100      ; Start of code

        ;
        ; Working in VGA 320x200x256 colors
        ;
        ; 0xfa00 is the first byte of video memory
        ; not visible on the screen.
        ; 
v_a:    equ 0xfa00      ; Y-coordinate 
v_b:    equ 0xfa02      ; X-coordinate
v_x:    equ 0xfa04      ; x 32-bit for Mandelbrot 24.8 fraction
v_y:    equ 0xfa08      ; y 32-bit for Mandelbrot 24.8 fraction
v_s1:   equ 0xfa0c      ; temporal s1
v_s2:   equ 0xfa10      ; temporal s2

start:
        mov ax,0x0013   ; Set mode 320x200x256
        int 0x10        ; Video interruption vector

        mov ax,0xa000   ; 0xa000 video segment
        mov ds,ax       ; Setup data segment
        mov es,ax       ; Setup extended segment

m4:
        mov ax,199      ; 199 is the bottommost row
        mov [v_a],ax    ; Save into v_a
m0:     mov ax,319      ; 319 is the rightmost column
        mov [v_b],ax    ; Save into v_b

m1:     xor ax,ax       
        mov [v_x],ax    ; x = 0.0
        mov [v_x+2],ax
        mov [v_y],ax    ; y = 0.0
        mov [v_y+2],ax
        mov cx,0        ; Iteration counter

m2:     push cx         ; Save counter
        mov ax,[v_x]    ; Read x
        mov dx,[v_x+2]
        call square32   ; Get x² (x * x)
        push dx         ; Save result to stack
        push ax
        mov ax,[v_y]    ; Read y
        mov dx,[v_y+2]
        call square32   ; Get y² (y * y)

        pop bx          
        add ax,bx       ; Add both (x² + y²)
        pop bx
        adc dx,bx

        pop cx          ; Restore counter
        cmp dx,0        ; Result is >= 4.0 ?
        jne m3
        cmp ax,4*256
        jnc m3          ; Yes, jump

        push cx
        mov ax,[v_y]    ; Read y
        mov dx,[v_y+2]
        call square32   ; Get y² (y * y)
        push dx
        push ax
        mov ax,[v_x]    ; Read x
        mov dx,[v_x+2]
        call square32   ; Get x² (x * x)

        pop bx
        sub ax,bx       ; Subtract (x² - y²)	
        pop bx
        sbb dx,bx

        ;
        ; Adding x coordinate like a fraction
        ; to current value.
        ;
        add ax,[v_b]    ; Add x coordinate
        adc dx,0
;        add ax,[v_b]    ; Add x coordinate
;        adc dx,0
        sub ax,480      ; Center coordinate
        sbb dx,0        

        push ax         ; Save result to stack
        push dx

        mov ax,[v_x]    ; Get x
        mov dx,[v_x+2]
        mov bx,[v_y]    ; Get y
        mov cx,[v_y+2]
        call mul32      ; Multiply (x * y)

        shl ax,1        ; Multiply by 2
        rcl dx,1

        add ax,[v_a]    ; Add y coordinate
        adc dx,0
;        add ax,[v_a]    ; Add y coordinate
;        adc dx,0
        sub ax,250      ; Center coordinate
        sbb dx,0

        mov [v_y],ax    ; Save as new y value
        mov [v_y+2],dx

        pop dx          ; Restore value from stack
        pop ax

        mov [v_x],ax    ; Save as new x value
        mov [v_x+2],dx

        pop cx
        inc cx          ; Increase iteration counter
        cmp cx,100      ; Attempt 100?
        je m3           ; Yes, jump
        jmp m2          ; No, continue

m3:     mov ax,[v_a]    ; Get Y-coordinate
        mov dx,320      ; Multiply by 320 (size of pixel row)
        mul dx
        add ax,[v_b]    ; Add X-coordinate to result
        xchg ax,di      ; Pass AX to DI

        add cl,0x20     ; Index counter into rainbow colors
        mov [di],cl     ; Put pixel on the screen
        
        dec word [v_b]  ; Decrease column
        jns m1          ; Is it negative? No, jump
        
        dec word [v_a]  ; Decrease row
        jns m0          ; Is it negative? No, jump

        mov ah,0x00     ; Wait for a key
        int 0x16        ; Keyboard interruption vector.

        mov ax,0x0002   ; Set mode 80x25 text.
        int 0x10        ; Video interruption vector.

        int 0x20        ; Exit to command-line.

        ;
        ; Calculate a squared number
        ; DX:AX = (DX:AX * DX:AX) / 256
        ;
square32:
                        ; Copy multiplicand to multiplier
        mov bx,ax       ; Copy AX -> BX 
        mov cx,dx       ; Copy DX -> CX
        ;
        ; 32-bit signed fractional multiplication
        ; DX:AX = (DX:AX * CX:BX) / 256
        ;
mul32:
        xor dx,cx       ; Look for different signs
        pushf
        xor dx,cx       ; Restore DX (pair of XOR = unaffected)
        jns mul32_2     ; If multiplicand is positive then jump.
        not ax          ; Negate multiplicand
        not dx
        add ax,1
        adc dx,0
mul32_2:
        test cx,cx      ; Test if multiplier is positive
        jns mul32_3     ; Is it positive? Yes, jump.
        not bx          ; Negate multiplier
        not cx
        add bx,1
        adc cx,0
mul32_3:
        mov [v_s1],ax   ; Save multiplicand (S1)
        mov [v_s1+2],dx

                        ; In this diagram each point and letter
                        ; is a word.
                        ;    . = not calculated
                        ;    + = calculated
                        ;    A = AX value
                        ;    B = multiplier
                        ;    C = result
                        ; rightmost column of result goes into v_s2
                        ; next to last goes into v_s2+2
                        ; next into v_s2+4

                        ;       .A
                        ;     x .B
                        ;     ----
                        ;       .C
                        ;      ..

        mul bx          ; S1:low * BX = DX:AX
        mov [v_s2],ax   ; Save provisional result
        mov [v_s2+2],dx

                        ;       A.
                        ;     x B.
                        ;     ----
                        ;       .+
                        ;      C.

        mov ax,[v_s1+2] ; S1:high * CX = DX:AX
        mul cx         
        mov [v_s2+4],ax ; Save next word of result
                        ; Notice it doesn't need DX

                        ;       A.
                        ;     x .B
                        ;     ----
                        ;       C+
                        ;      +.

        mov ax,[v_s1+2] ; S1:high * BX = DX:AX
        mul bx
        add [v_s2+2],ax ; Adds to previous result
        adc [v_s2+4],dx
        
                        ;       .A
                        ;     x B.
                        ;     ----
                        ;       ++
                        ;      +C

        mov ax,[v_s1]   ; S1:low * CX = DX:AX
        mul cx
        add [v_s2+2],ax ; Adds to previous result
        adc [v_s2+4],dx

        mov ax,[v_s2+1] ; Reads result shifted by 1 byte
        mov dx,[v_s2+3] ; equivalent to divide by 256

        popf            ; Restore flags
        jns mul32_1     ; Different signs? No, jump.
        not ax          ; Negate result.
        not dx
        add ax,1
        adc dx,0
mul32_1:
        ret             ; Return.

