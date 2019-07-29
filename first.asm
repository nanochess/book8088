	org 0x0100
start:
	mov bx,string
repeat:
	mov al,[bx]
	test al,al
	je end
	push bx
	mov ah,0x0e
	mov bx,0x000f
	int 0x10
	pop bx
	inc bx
	jmp repeat

end:
        int 0x20

string:
	db "Hello, world",0
