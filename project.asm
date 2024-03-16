[org 0x0100]
jmp start

;-----------------------------------------VARIABLES-------------------------------------------------------
page1st1: db 'Game Started'			;12
top: db '________________________'	;24

speed1: db ' _  _  _ '				
speed2: db '| || || |'				;9
speed3: db '|_||_||_|'
speed4: db '_________'

time1: db 'P:01 L:01'
time2: db '  00:0'

map1: db '  _______  '				;11
map2: db ' |       | '
map3: db ' |       | '
map4: db ' |_______| '

meter1: db '5 6 7' 					;5
meter2: db '4  *\ 8'				;7
meter3: db '3 2 1'					;5

fin1: db ' _                _      ';25
fin2: db '|_  |  |\ |   |  |_   |_|'
fin3: db '|   |  | \|   |   _|  | |'

lost1: db '    _            _  _ ___ ';25
lost2: db '|_|| || |    |  | ||_  |  '
lost3: db ' | |_||_|    |_ |_| _| |  '

score: dw 10000 						;variable used to display the score

sec: dw 1
min: dw 0
turncount: dw 0
startagain: db 'Went out of bound, start again!'		;31
presskey: db 'Press any key to continue'				;25


;---------------------------------------------DELAY--------------------------------------------------------
delay:
	push cx
	mov cx, 10

	delay_loop1:
	push cx
	mov cx, 0xFFFF
	
	delay_loop2:
	loop delay_loop2
		
	pop cx	
	loop delay_loop1
		
	pop cx
	ret

;-----------------------------------------CLEAR SCREEN----------------------------------------------------
; this function fills the whole screen segment that is of 2000 words with a blank spot 0x0720
clrscr:
	push ax
	push cx
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, 0

	mov ax, 0x0720
	mov cx, 80*25
	cld
	rep stosw

	pop di
	pop es
	pop cx
	pop ax
	ret
	
;----------------------------------------PRINT COLORED LINE------------------------------------------------
; this function fills a specific color from a specific starting point to a certain number of blocks to be printed
colored_line:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]		;starting point
	shl di, 1
	mov ax, [bp+8]		;color
	mov cx, [bp+4]		;number of blocks

l1:
	mov [es:di], ax
	add di, 2
	loop l1

	pop di
	pop es
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
		
;----------------------------------------------------CUSTOM PRINT-----------------------------------------
; this function is same as the function print text only that it takes the color of the text to print as an input parameter
Print_text:
	push bp
	mov bp, sp

	push ax
	push bx
	push es
	push si
	push di

	mov ax, 0xb800
	mov es, ax
	mov si, [bp+6]		;string to be printed
	mov di, [bp+4]		;coordinates
	shl di, 1
	mov bx, [bp+8]		;Color
	mov cx, [bp+10]		;size
	mov ah, bl

nextchar:
	lodsb		
	stosw
	loop nextchar
	
	pop di
	pop si
	pop es
	pop bx
	pop ax
	pop bp
	ret 8


print_number:
	push bp
	mov bp, sp

	push ax
	push bx
	push cx
	push dx
	push es
	push di

	mov bx, [bp+6]
	mov ax, [bx]
	mov bx, 10
	mov cx, 0

get_digits_loop:
	mov dx, 0
	div bx

	push dx

	add cx, 1
	cmp ax, 0

	jnz get_digits_loop

	mov ax, 0xb800
	mov es, ax
	mov di, [bp+4]
	
print_number_loop:
	pop dx

	add dx, 0x30
	mov dh, [bp+8]

	mov [es:di], dx
	add di, 2

	loop print_number_loop

	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax

	pop bp
	ret 6
	
print_text:
	push bp
	mov bp, sp

	push ax
	push ds
	push si
	push es
	push di

	mov ax, 0xb800
	mov es, ax
	mov si, [bp+6]
	mov di, [bp+4]

	mov ah, 0x07

print_text_loop:
	lodsb
	stosw
	cmp al, -1
	jne print_text_loop

	pop di
	pop es
	pop si
	pop ds
	pop ax

	pop bp
	ret 4

		

results: db 'POS    NAME               NO.      TIME  '		;41
result1: db ' 1     Aatiqa Hussain     #01      00m21s'		
result2: db ' 2     Sayyeda Fatima     #03      00m22s'		
result3: db ' 3     Ayesha Saikhani    #31      00m23s'		
result4: db ' 4     Nighat Hussain     #16      00m24s'		
result5: db ' 5     Hafsa Masood       #28      00m25s'		
result6: db ' 6     YOU                #43      00m00s'		
result7: db ' 7     Hashir Saikhani    #41      04m31s'		
result8: db ' 8     Muhammad Umar      #11      04m51s'		
result9: db ' 9     Muhammad Abdullah  #02      05m22s'				

sheet1: db '  _  _  _      ___       _     _  _ ___ ' 		;40
sheet2: db ' |_||_ |_ | ||  |       |_ |_||_ |_  |  '
sheet3: db ' |\ |_  _||_||_ |        _|| ||_ |_  |  '

;------------------------------------PRINT RESULTS----------------------------------
printresults:
	push bx
	push cx

	push 4020h		;color
	push 0			;starting point
	push 640 		;number of blocks to be printed
	call colored_line
	
	mov cx, 3
	mov bx, 243
res1:	
	push 30b2h		;color
	push bx			;starting point
	push 3	 		;number of blocks to be printed
	call colored_line
	
	push 07b2h		;color
	add bx, 3
	push bx			;starting point
	push 3	 		;number of blocks to be printed
	call colored_line
	
	push 40b2h		;color
	add bx, 3
	push bx			;starting point
	push 3	 		;number of blocks to be printed
	call colored_line
	
	add bx, 74
	loop res1
	
	
	push 40			;size
	push 47h		;color
	push sheet1		;string to be printed
	push 260		;coordinates
	call Print_text

	push 40			;size
	push 47h		;color
	push sheet2		;string to be printed
	push 340		;coordinates
	call Print_text	
	
	push 40			;size
	push 47h		;color
	push sheet3		;string to be printed
	push 420		;coordinates
	call Print_text

	
	push 41			;size
	push 07h		;color
	push results	;string to be printed
	push 818		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result1	;string to be printed
	push 978		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result2	;string to be printed
	push 1058		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result3	;string to be printed
	push 1138		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result4	;string to be printed
	push 1218		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result5	;string to be printed
	push 1298		;coordinates
	call Print_text
	
	push 41			;size
	push 06h		;color
	push result6	;string to be printed
	push 1378		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result7	;string to be printed
	push 1458		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result8	;string to be printed
	push 1538		;coordinates
	call Print_text
	
	push 41			;size
	push 07h		;color
	push result9	;string to be printed
	push 1618		;coordinates
	call Print_text
	
	mov bx, 2832
	cmp word [sec], 10
	jge printsec
	add bx, 2
printsec:
	push 0x06
	push sec
	push bx
	call print_number
	

	mov bx, 2826
	cmp word [min], 10
	jge printmin
	add bx, 2
printmin:	
	push 0x06
	push min
	push bx
	call print_number
	
	pop cx
	pop bx
	ret
	
;------------------------------------------1st SCREEN-------------------------------------------------------
printscreen1:
	push 12			;size
	push 0x84		;color
	push page1st1	;text to be printed
	push 993		;starting point
	call Print_text
	ret
	
	
;------------------------------------------PRINT LOST-----------------------------------------------------
lost:
	call delay
	call delay
	call delay
	call delay
	call clrscr
	push 25			;size
	push 0x84		;color
	push lost1	;text to be printed
	push 985		;starting point
	call Print_text
	
	push 25			;size
	push 0x84		;color
	push lost2	;text to be printed
	push 1065		;starting point
	call Print_text
	
	push 25			;size
	push 0x84		;color
	push lost3	;text to be printed
	push 1145		;starting point
	call Print_text
	
	mov ax, 0x4c00
	int 0x21
	
;----------------------------------------------SKY----------------------------------------------------------
sky:
	push 1bb2h
	push 0
	push 640
	call colored_line
	ret 
	
;------------------------------------------LEFT GREEN PART----------------------------------------------------
lgp:
	push ax
	push bx
	push cx
	push dx

	mov dx, 0
	mov cx ,9
	mov bx, 0
l2:
	push 20b2h
	mov ax, 640
	add ax, bx
	push ax			
	mov ax, cx
	shl ax, 1
	add ax, dx
	push ax	
	call colored_line
	add bx, 80
	add dx, 1
	loop l2
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
;------------------------------------------RIGHT GREEN PART--------------------------------------------------
rgp:
	push ax
	push bx
	push cx
	push dx
	
	mov cx ,9
	mov bx, 0
	mov dx, -1
l3:
	push 20b2h		;color
	mov ax, 704			;starting point 
	add ax, bx
	add ax, dx
	push ax			
	mov ax, cx
	shl ax, 1			;number of blocks to be printed
	add ax, dx
	push ax				
	call colored_line
	add bx, 80
	add dx, 1
	loop l3
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
;---------------------------------------------ROAD-------------------------------------------------------
road:
	push 07b2h		;color
	push 640			;starting point
	push 720			;number of blocks to be printed
	call colored_line
	
	call rd1
	ret
	
	
;-------------------------------------------BUILT AREA-----------------------------------------------------
building:
	push 10b2h		;color
	push 486		;starting point
	push 68	 		;number of blocks to be printed
	call colored_line

	push 50b2h		;color  
	push 410		;starting point
	push 60	 		;number of blocks to be printed
	call colored_line

	push 16b2h		;color
	push 334		;starting point
	push 52	 		;number of blocks to be printed
	call colored_line

	ret
	
;-------------------------------------------BOUNDARY LINE-------------------------------------------------
boundary_line:
	push ax
	push bx
	
	mov bx, 0
l4:
	add bx, 5
	push 102Ah		;color
	mov ax, 555		;starting point
	add ax, bx
	push ax			
	push 5			;number of blocks to be printed
	call colored_line
	
	add bx, 5
	push 402Ah		;color
	mov ax, 555		;starting point
	add ax, bx
	push ax			
	push 5	 		;number of blocks to be printed
	call colored_line
	cmp bx, 80
	jne l4
	
	pop bx
	pop ax
	ret
	
;----------------------------------------------SIGNALS---------------------------------------------------
signals:
	push bx
	push cx
	
	mov cx, 7
	mov bx, 80
s1:	
	push 0020h		;color
	push bx			;starting point
	push 8	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop s1
	
	mov cx, 2
	mov bx, 161
s2:	
	push 40b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop s2
	
	mov cx, 2
	mov bx, 321
s3:	
	push 40b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop s3
	
	mov cx, 2
	mov bx, 481
s4:	
	push 70b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop s4
	
	pop cx
	pop bx
	ret
	
;-----------------------------------------------MAP----------------------------------------------------
map:
	push bx
	push cx
	
	mov cx, 5
	mov bx, 88
m1:	
	push 30b2h		;color
	push bx			;starting point
	push 13	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop m1
	
	push 0120h		;color
	push 409		;starting point
	push 11	 		;number of blocks to be printed
	call colored_line
	
	;to print the map on the board
	push 11			;size
	push 07h		;color
	push map1		;string to be printed
	push 89			;coordinates
	call Print_text
	
	push 11			;size
	push 07h		;color
	push map2		;string to be printed
	push 169		;coordinates
	call Print_text
	
	push 11			;size
	push 07h		;color
	push map3		;string to be printed
	push 249		;coordinates
	call Print_text
	
	push 11			;size
	push 07h		;color
	push map4		;string to be printed
	push 329		;coordinates
	call Print_text
	
	pop cx
	pop bx
	ret
	
;--------------------------------------------CAR PRINTING----------------------------------------------------
car:
	push 48b2h			;color
	push 1360			;starting point		
	push 640	 		;number of blocks to be printed
	call colored_line

	call car_top
	call steering
	call leftmirror
	call rightmirror
	call speedo_meter
	call indicators
	call gearbox

	ret

;----------------------------------------------STEERING------------------------------------------------------
steering:
	push bx
	push cx

	push 0020h			;color
	push 1634			;starting point		
	push 10		 		;number of blocks to be printed
	call colored_line
	
	mov cx, 2
	mov bx, 1712
ls1:
	push 0020h			;color
	push bx				;starting point		
	push 2	 			;number of blocks to be printed
	call colored_line
	add bx, 12
	loop ls1
	
	mov cx, 2
	mov bx, 1790
ls2:
	push 0020h			;color
	push bx				;starting point			
	push 2	 			;number of blocks to be printed
	call colored_line
	add bx, 16
	loop ls2

	mov cx, 2
	mov bx, 1868
ls3:
	push 0020h			;color
	push bx				;starting point		
	push 2	 			;number of blocks to be printed
	call colored_line
	add bx, 20
	loop ls3
	
	push 0020h			;color
	push 1948			;starting point		
	push 22	 			;number of blocks to be printed
	call colored_line

	push 70b2h			;color
	push 1950			;starting point			
	push 18	 			;number of blocks to be printed
	call colored_line

	push 40b2h			;color
	push 1958			;starting point		
	push 2	 			;number of blocks to be printed
	call colored_line
	
	pop cx
	pop bx
	ret
	
;----------------------------------------------LEFT MIRROR---------------------------------------------------
leftmirror:
	push bx
	push cx
	
	push 0bb2h		;color
	push 1360		;starting point		
	push 9	 		;number of blocks to be printed
	call colored_line
	
	mov cx, 2
	mov bx, 1440
lm1:
	push 20b2h		;color
	push bx			;starting point
	push 9	 		;number of blocks to be printed	
	call colored_line
	add bx, 80
	loop lm1
	
	mov cx, 2
	mov bx, 1443
lm2:
	push 7020h		;color
	push bx			;starting point
	push 6	 		;number of blocks to be printed	
	call colored_line
	add bx, 80
	loop lm2
	
	mov cx, 2
	mov bx, 1447
lm3:
	push 707Ch		;color
	push bx			;starting point		
	push 1	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop lm3
	
	pop cx
	pop bx
	ret
	
;---------------------------------------------RIGHT MIRROR---------------------------------------------------
rightmirror:
	push bx
	push cx
	
	push 0bb2h		;color
	push 1431		;starting point
	push 9	 		;number of blocks to be printed
	call colored_line
	
	mov cx, 2
	mov bx, 1511
rm1:
	push 20b2h		;color
	push bx			;starting point
	push 9	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop rm1
	
	mov cx, 2
	mov bx, 1511
rm2:
	push 7020h		;color
	push bx			;starting point
	push 6	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop rm2
		
	mov cx, 2
	mov bx, 1512
rm3:
	push 707Ch		;color
	push bx			;starting point
	push 1	 		;number of blocks to be printed	
	call colored_line
	add bx, 80
	loop rm3
	
	pop cx
	pop bx
	ret
	
;-------------------------------------------SPEEDO METER----------------------------------------------------
speedo_meter:
	push 5
	push 0x70
	push meter1
	push 1716
	call Print_text
	
	push 7
	push 0x70
	push meter2
	push 1795
	call Print_text
	
	push 5
	push 0x70
	push meter3
	push 1876
	call Print_text

	ret
	
;---------------------------------------------CAR TOP-------------------------------------------------------
car_top:
	push bx
	push cx
	
	mov cx, 4
	mov bx, 1380
c1:	
	push 70b2h			;color
	push bx				;starting point
	push 41	 			;number of blocks to be printed
	call colored_line
	add bx, 80
	loop c1
	
	push 0020h			;color
	push 1393			;starting point
	push 24	 			;number of blocks to be printed
	call colored_line
	
	push 24				;size
	push 07h			;color
	push top			;string to be printed
	push 1473			;coordinates
	call Print_text
	
	push 9				;size
	push 04h			;color
	push speed1			;string to be printed
	push 1382			;coordinates
	call Print_text
	
	push 9				;size
	push 04h			;color
	push speed2			;string to be printed
	push 1462			;coordinates
	call Print_text
	
	push 9			;size
	push 04h		;color
	push speed3		;string to be printed
	push 1542		;coordinates
	call Print_text
	
	push 9			;size
	push 07h		;color
	push speed4		;string to be printed
	push 1622		;coordinates
	call Print_text
	
	mov cx, 2
	mov bx, 1498
c2:	
	push 675Fh		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 160
	loop c2
	
	push 675Fh		;color
	push 1654		;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	
	pop cx
	pop bx
	ret

;---------------------------------------INDICATORS--------------------------------------
indicators:
	push 20b2h		;color
	push 1783		;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line

	push 40b2h		;color
	push 1813		;starting point
	push 2	 		;number of blocks to be printed
	call colored_line

	ret

;-------------------------------------------FINAL LINES-----------------------------------------------------
final_lines:
	push bx
	push cx
		
	mov cx, 17
	mov bx, 1046
l5:
	push 00b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l5
	
	mov cx, 18
	mov bx, 1124
l6:
	push 00b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l6
		
	mov cx, 19
	mov bx, 1202
l7:
	push 00b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l7
		
	mov cx, 17
	mov bx, 1048
l8:
	push 77b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l8
	
	mov cx, 18
	mov bx, 1126
l9:
	push 77b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l9
	
	mov cx, 19
	mov bx, 1204
l10:
	push 77b2h		;color
	push bx			;starting point		
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 4
	loop l10
	
	pop cx
	pop bx
	ret

;-------------------------------------------FINISH-----------------------------------------------------
finish:
	push bx
	push cx
	
	mov cx, 13
	mov bx, 84
f1:
	push 6020h			;color   60b2
	push bx				;starting point
	push 1	 			;number of blocks to be printed
	call colored_line
	add bx, 80
	loop f1

	mov cx, 13
	mov bx, 155
f2:
	push 6020h			;color   60b2
	push bx				;starting point
	push 1	 			;number of blocks to be printed
	call colored_line
	add bx, 80
	loop f2
	
	mov cx, 4
	mov bx, 04
f3:
	push 6020h			;color   60b2
	push bx				;starting point
	push 72	 			;number of blocks to be printed
	call colored_line
	add bx, 80
	loop f3
	
	;to print FINISH on the board
	push 25				;size
	push 60h			;color
	push fin1			;string to be printed
	push 107			;coordinates
	call Print_text
	
	push 25				;size
	push 60h			;color
	push fin2			;string to be printed
	push 187			;coordinates
	call Print_text
	
	push 25				;size
	push 60h			;color
	push fin3			;string to be printed
	push 267			;coordinates
	call Print_text
	
	pop cx
	pop bx
	ret

;----------------------------------------------GEAR PRINTING-------------------------------------------------
gearbox:
	push bx
	push cx
	
	mov cx, 4
	mov bx, 1746
gb1:
	push 70b2h		;color
	push bx			;starting point		
	push 10 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop gb1
	
	mov cx, 2
	mov bx, 1829
gb2:
	push 70b4h		;color
	push bx			;starting point
	push 4 			;number of blocks to be printed
	call colored_line
	add bx, 80
	loop gb2	
	
	push 0720h			;color
	push 1830			;starting point			
	push 2 				;number of blocks to be printed
	call colored_line	
	
	pop cx
	pop bx
	ret

;----------------------------------------------TOP LINE------------------------------------------------------
printsky:
	push 1bb2h		;color
	push 0			;starting point			
	push 80 		;number of blocks to be printed
	call colored_line
	
	ret
	
;------------------------------------------MAIN SCREEN-------------------------------------------------------
printmainscreen:
	push bx
	call sky
	call road
	call lgp
	call rgp
	call boundary_line
	call building
	call signals
	call map
	call printsky
	call car
	call timer1
	
	push 40b2h			;color
	push 92				;starting point
	push 1		 		;number of blocks to be printed
	call colored_line
	
	pop bx
	ret
	
;----------------------------------------FINISHING POINT----------------------------------------------------
finish_point:
	call final_lines
	call finish
	call delay
	call delay
	call delay
	ret

;-------------------------------------------ROAD LINES-----------------------------------------------------
rd1:
	call clr_rd
	push bx
	push cx
	
	mov cx, 3
	mov bx, 759
r1:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r1

	mov cx, 3
	mov bx, 1159
r2:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r2
	
	pop cx
	pop bx
	ret
	
rd2:
	call clr_rd
	push bx
	push cx
	
	mov cx, 3
	mov bx, 839
r21:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r21

	mov cx, 3
	mov bx, 1239
r22:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r22

	pop cx
	pop bx
	ret
	
rd3:
	call clr_rd
	push bx
	push cx
	
	push 00b2h		;color
	push 679			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	
	mov cx, 3
	mov bx, 919
r32:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r32

	mov cx, 2
	mov bx, 1319
r33:
	push 00b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop r33

	pop cx
	pop bx
	ret
	
;-----------------------------------------CLEAR ROAD LINES--------------------------------------------
clr_rd:
	push bx
	push cx
	
	mov cx, 9
	mov bx, 679
crd:
	push 07b2h		;color
	push bx			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop crd

	pop cx
	pop bx
	ret
	
again:
	call clrscr
	push 31			;size
	push 84h		;color
	push startagain	;string to be printed
	push 982		;coordinates
	call Print_text
	
	push 25			;size
	push 84h		;color
	push presskey	;string to be printed
	push 1065		;coordinates
	call Print_text
	mov ah, 0
	int 0x16
	
	call printmainscreen
	call printtime
	mov word [turncount], 0


ll3:
	mov ah, 0
	int 0x16 						; call BIOS keyboard service
	in al, 0x60
	cmp al, 0x48 					; is the Up key pressed
	jne ll3

	call timer	
;---------------------------------------------RIGHT TURN-----------------------------------------------
turn:
	push ax
	push bx
	push cx
	push dx
	
	mov ax, 0xC0b2
	push ax			;color
	push 1813		;starting point
	push 2	 		;number of blocks to be printed
	call colored_line

	mov dx, 7
	mov cx ,4
	mov bx, 0
rr1:
	push 20b2h
	mov ax, 640
	add ax, bx
	push ax			
	mov ax, cx
	shl ax, 1
	add ax, dx
	push ax	
	call colored_line
	add bx, 80
	add dx, 1
	loop rr1

	mov cx ,2
	mov bx, 690
rr2:
	push 07b2h
	push bx			
	push 30	
	call colored_line
	add bx, 80
	loop rr2
	call delay
	call delay
	
	call clr_rd
	call rd2
	
	mov cx ,4
	mov bx, 690
rr3:
	push 07b2h
	push bx			
	push 30	
	call colored_line
	add bx, 80
	loop rr3
	call delay
	call delay
	
	call clr_rd
	call rd3
	
	mov cx , 6
	mov bx, 690
rr4:
	push 07b2h
	push bx			
	push 30	
	call colored_line
	add bx, 80
	loop rr4

	call delay
	call delay
	call delay
	
;----------------------------------------TURNING POINT---------------------------------------------------
inputagain:
	mov ah, 0
	int 0x16 				; call BIOS keyboard service
	in al, 0x60
	cmp al, 0x4d 				; is the Up key pressed
	je nexx
	cmp al, 0xcd
	je nexx
	cmp al, 0x4b
	je again
	cmp al, 0xcb
	je again
	cmp al, 0x48
	je again
	cmp al, 0xc8
	je again
	jmp inputagain

nexx:	
	add word [sec], 1
	call printtime
	
	push 48b2h
	push 1950			
	push 18	
	call colored_line

	mov cx , 4
	mov bx, 1718
rr5:
	push 70b2h
	push bx			
	push 2	
	call colored_line
	add bx, 80
	loop rr5
	
	push 40b2h
	push 1958			
	push 2	
	call colored_line
	
	call road
	call clr_rd
	mov dx, 6
	mov cx ,9
	mov bx, 0
rr21:
	push 20b2h
	mov ax, 640
	add ax, bx
	push ax			
	mov ax, cx
	shl ax, 1
	shl ax, 1
	add ax, dx
	push ax	
	call colored_line
	add bx, 80
	add dx, 2
	loop rr21

	mov cx, 3
	mov bx, 716
	mov dx, 0
rdr1:
	push 00b2h		;color
	mov ax, bx
	sub ax, dx
	push ax			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	add dx, 1
	loop rdr1

	mov cx, 3
	mov bx, 1188
	mov dx, 0
rdr2:
	push 00b2h		;color
	mov ax, bx
	sub ax, dx
	push ax			;starting point
	push 2	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	add dx, 1
	loop rdr2

	call delay
	call delay
	call delay

	call road
	call lgp
	call rgp
	call indicators
	call steering 
	call speedo_meter
	pop dx
	pop cx
	pop bx
	pop ax
	ret

taketurn:
	add word [turncount], 1
	call turn
	call sky
	call boundary_line
	call signals
	call map
	call printsky

	add word [sec], 1
	call timer1
	call printtime

	cmp word [turncount], 4
	jne nec
	call building
	call signals
	call map
nec:
	sub dx, 5
	ret
 
 ;----------------------------------------------TIMER---------------------------------------------------
timer1:
	push bx
	push cx

	mov cx, 4
	mov bx, 147
t1:	
	push 30b2h		;color
	push bx			;starting point
	push 13	 		;number of blocks to be printed
	call colored_line
	add bx, 80
	loop t1

	push 9
	push 0x07
	push time1
	push 229
	call Print_text

					
	push 9
	push 0x07
	push time2
	push 309
	call Print_text

	pop cx
	pop bx
	ret
;--------------------------------------PRINT TIME-------------------------------------------
zero: db 0
printtime:
	push ax
	
	mov ax, 628
	cmp word [sec], 10
	jge nextit
	add ax, 2
nextit:
	cmp word [sec], 60
	jne endit

	mov word [sec], 0
	add word [min], 1

	push 07h
	push zero
	push 628
	call print_number


endit:	
	push 07h
	push sec
	push ax
	call print_number
	
	push 07h
	push min
	push 624
	call print_number	

	pop ax
	ret
;------------------------------------INCREASING TIMER---------------------------------------
timer:	
	push 9
	push 0x07
	push time1
	push 229
	call Print_text
				
	push 9
	push 0x07
	push time2
	push 309
	call Print_text

	mov dx, 20
	mov cx, 25
e1:
	in al, 0x60 				; read a char from keyboard port	
	cmp al, 0xcb 				; is the key left shift
	jne nextcmp1 				; no, try next comparison
	pop ax
	jmp again
nextcmp1:  
	cmp al, 0xd0 				; is the key down arrow
	jne nomatch 				; no, leave interrupt routine
ll1:
	mov ah, 0
	int 0x16 				; call BIOS keyboard service
	in al, 0x60
	cmp al, 0x48 				; is the Up key pressed
	jne ll1
	
nomatch:
	cmp word [min], 10
	jne nex1
	jmp lost
nex1:
	add word [sec], 1
	call printtime	

movement:
	call delay
	call rd1
	call delay
	call rd2
	call delay
	call rd3

	cmp cx, dx
	jne next
	call beforeturn
	call taketurn
	call afterturn
next:
	loop e1
	call final_lines
	call finish
	call delay
	call rd1
	call final_lines
	call delay
	call delay
	call delay
	call delay
	call end

 ;-----------------------------------------START OF GAME-----------------------------------------------------
start:
	call clrscr
	call printscreen1
	call delay
	call delay
	call delay
	call delay
	call delay
	call printmainscreen
	call finish_point

ll2:
	mov ah, 0
	int 0x16 						; call BIOS keyboard service
	in al, 0x60
	cmp al, 0x48 					; is the Up key pressed
	jne ll2
	
	call printmainscreen
	call timer

end:
	call clrscr
	call printresults
	mov ax, 0x4c00
	int 0x21
	
;----------------------------------UPDATE MAP--------------------------------------

afterturn:
	call map
	push bx

	cmp word [turncount], 1
	jne nextcomp11
	mov bx, 178
	jmp return11
	
nextcomp11:
	cmp word [turncount], 2
	jne nextcomp12
	mov bx, 336	
	jmp return11
	
nextcomp12:
	cmp word [turncount], 3
	jne nextcomp13
	mov bx, 330	
	jmp return11
	
nextcomp13:
	mov bx, 92
	
return11:
	push 40b2h			;color
	push bx				;starting point
	push 1		 		;number of blocks to be printed
	call colored_line
	pop bx
	ret
	
	
beforeturn:
	call map
	push bx

	cmp word [turncount], 1
	jne nextcomp21
	mov bx, 338
	jmp return21
	
nextcomp21:
	cmp word [turncount], 2
	jne nextcomp22
	mov bx, 332	
	jmp return21
	
nextcomp22:
	cmp word [turncount], 3
	jne nextcomp23
	mov bx, 170	
	jmp return11
	
nextcomp23:
	mov bx, 96
	
return21:
	push 40b2h			;color
	push bx				;starting point
	push 1		 		;number of blocks to be printed
	call colored_line
	pop bx
	ret