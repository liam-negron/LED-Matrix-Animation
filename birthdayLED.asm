.include "/home/liam/uP/tn84def.inc"

;EQUATES
.equ TC_PER = 976

.cseg
.org 0x00
rjmp MAIN

.org 0x100
MAIN:
	rcall IO_INIT
	rcall MAX7219_REG_INIT
	rcall TC_INIT
LOOP:

	rcall BDAY_MESSAGE_OUT
	rjmp LOOP
DONE:
	rjmp DONE

IO_INIT:
	push r16
	;set DO and USCK pins as outputs in DDRE
	;set the Data Out PA5 to an output 
	;set PA3 as the slave select
	ldi r16, (1<<PA3) | (1<<PA4) | (1<<PA5) | (0<<PA6) 
	out DDRA, r16

	;set the slave select high
	ldi r16, (1<<PA3)
	out PORTA, r16

	;set DI as an input PA6

	pop r16
	ret

SPI_TRANSFER_16:
	out USIDR, r16
	ldi r16, (1<<USIWM0) | (1<<USITC)
	ldi r17, (1<<USIWM0) | (1<<USITC) | (1<<USICLK)

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17
	
	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17
	
	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	nop
	out USIDR, r18
	ldi r16, (1<<USIWM0) | (1<<USITC)
	ldi r17, (1<<USIWM0) | (1<<USITC) | (1<<USICLK)

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17
	
	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17
	
	out USICR, r16
	out USICR, r17

	out USICR, r16
	out USICR, r17

	ret


;INPUTS: r16 - holds the address of the register to write to on MAX7219
;	 r18 - holds the data to write in the register
MAX7219_WRITE:
	;clear the slave select
	cbi PORTA, PA3
	
	;write the data
	rcall SPI_TRANSFER_16

	;set the slave select
	sbi PORTA, PA3

	ret

MAX7219_REG_INIT:
	;set all registers to 0 except scan limit(0x0B)
	;and shutdown (0x0C)

	ldi r16, 0x00
	ldi r18, 0x00
	rcall MAX7219_WRITE
	
	ldi r16, 0x01
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x02
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x03
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x04
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x05
	ldi r18, 0x00
	rcall MAX7219_WRITE
	
	ldi r16, 0x06
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x07
	ldi r18, 0x00
	rcall MAX7219_WRITE
	
	ldi r16, 0x08
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x09
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x0A
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x0B
	ldi r18, 0x07
	rcall MAX7219_WRITE

	ldi r16, 0x0C
	ldi r18, 0x01
	rcall MAX7219_WRITE
	
	ldi r16, 0x0F
	ldi r18, 0x00
	rcall MAX7219_WRITE
	ret

CLEAR_DISPLAY:

	ldi r16, 0x01
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x02
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x03
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x04
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x05
	ldi r18, 0x00
	rcall MAX7219_WRITE
	
	ldi r16, 0x06
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ldi r16, 0x07
	ldi r18, 0x00
	rcall MAX7219_WRITE
	
	ldi r16, 0x08
	ldi r18, 0x00
	rcall MAX7219_WRITE

	ret

J_OUT:
	;write to first column
	ldi r16, 0x01
	ldi r18, 0b00000101
	rcall MAX7219_WRITE

	;write to the second column
	ldi r16, 0x02
	ldi r18, 0b00000111
	rcall MAX7219_WRITE

	;write to the third column
	ldi r16, 0x03
	ldi r18, 0x01
	rcall MAX7219_WRITE

	ret

E_OUT:
	;write to third column
	ldi r16, 0x03
	ldi r18, 0b00011100
	rcall MAX7219_WRITE

	;write to the fourth column
	ldi r16, 0x04
	ldi r18, 0b00011100
	rcall MAX7219_WRITE
	
	;write to the fifth column
	ldi r16, 0x05
	ldi r18, 0b00010100
	rcall MAX7219_WRITE

	ret

N_OUT:
	;write to the sixth column
	ldi r16, 0x06
	ldi r18, 0b11100000
	rcall MAX7219_WRITE

	;write to the seventh column
	ldi r16, 0x07
	ldi r18, 0b00100000
	rcall MAX7219_WRITE
	
	;write to the eight column
	ldi r16, 0x08
	ldi r18, 0b11100000
	rcall MAX7219_WRITE

	ret

HASHTAG_OUT:
	;write to the third column
	ldi r16, 0x03
	ldi r18, 0b00010100
	rcall MAX7219_WRITE

	;write to the fourth column
	ldi r16, 0x04
	ldi r18, 0b00111110
	rcall MAX7219_WRITE

	;write the fifth column
	ldi r16, 0x05
	ldi r18, 0b00010100
	rcall MAX7219_WRITE

	;write the sixth column
	ldi r16, 0x06
	ldi r18, 0b00111110
	rcall MAX7219_WRITE

	;write the seventh column
	ldi r16, 0x07
	ldi r18, 0b00010100
	rcall MAX7219_WRITE

	ret

ONE_OUT:
	;write the fourth column
	ldi r16, 0x04
	ldi r18, 0b00100100
	rcall MAX7219_WRITE

	;write to the fifth column
	ldi r16, 0x05
	ldi r18, 0b00111110
	rcall MAX7219_WRITE

	;write to the sixth column
	ldi r16, 0x06
	ldi r18, 0b00100000
	rcall MAX7219_WRITE

	ret

M_OUT:
	;write to the first column
	ldi r16, 0x01
	ldi r18, 0b11111111
	rcall MAX7219_WRITE

	;write the second column
	ldi r16, 0x02
	ldi r18, 0b00000010
	rcall MAX7219_WRITE

	;write the third column
	ldi r16, 0x03
	ldi r18, 0b00000100
	rcall MAX7219_WRITE

	;write the fourth column
	ldi r16, 0x04
	ldi r18, 0b00001000
	rcall MAX7219_WRITE

	;write the fifth column
	ldi r16, 0x05
	ldi r18, 0b00001000
	rcall MAX7219_WRITE

	;write the sixth column
	ldi r16, 0x06
	ldi r18, 0b00000100
	rcall MAX7219_WRITE

	;write the seventh column
	ldi r16, 0x07
	ldi r18, 0b00000010
	rcall MAX7219_WRITE

	;write the eight column
	ldi r16, 0x08
	ldi r18, 0b11111111
	rcall MAX7219_WRITE

	ret

O_OUT:
	;write the first column 
	ldi r16, 0x02
	ldi r18, 0b01111110
	rcall MAX7219_WRITE

	;write the third column
	ldi r16, 0x03
	ldi r18, 0b01000010
	rcall MAX7219_WRITE

	;write the fourth column
	ldi r16, 0x04
	ldi r18, 0b01000010
	rcall MAX7219_WRITE

	;write the fifth column
	ldi r16, 0x05
	ldi r18, 0b01000010
	rcall MAX7219_WRITE

	;write the sixth column
	ldi r16, 0x06
	ldi r18, 0b01000010
	rcall MAX7219_WRITE

	;write the eight column
	ldi r16, 0x07
	ldi r18, 0b01111110
	rcall MAX7219_WRITE

	ret

HEART_OUTLINE_OUT:
	;write to the first column
	ldi r16, 0x01
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	ldi r16, 0x02
	ldi r18, 0b00010010
	rcall MAX7219_WRITE

	ldi r16, 0x03
	ldi r18, 0b00100010
	rcall MAX7219_WRITE

	ldi r16, 0x04
	ldi r18, 0b01000100
	rcall MAX7219_WRITE

	ldi r16, 0x05
	ldi r18, 0b01000100
	rcall MAX7219_WRITE

	ldi r16, 0x06
	ldi r18, 0b00100010
	rcall MAX7219_WRITE

	ldi r16, 0x07
	ldi r18, 0b00010010
	rcall MAX7219_WRITE

	ldi r16, 0x08
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	ret

HEART_FULL_OUT:
	;write to the first column
	ldi r16, 0x01
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	ldi r16, 0x02
	ldi r18, 0b00011110
	rcall MAX7219_WRITE

	ldi r16, 0x03
	ldi r18, 0b00111110
	rcall MAX7219_WRITE

	ldi r16, 0x04
	ldi r18, 0b01111100
	rcall MAX7219_WRITE

	ldi r16, 0x05
	ldi r18, 0b01111100
	rcall MAX7219_WRITE

	ldi r16, 0x06
	ldi r18, 0b00111110
	rcall MAX7219_WRITE

	ldi r16, 0x07
	ldi r18, 0b00011110
	rcall MAX7219_WRITE

	ldi r16, 0x08
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	ret

HEART_OUTLINE_OUT_INC:
	;L indicates lower section
	;H indicates higher section
	;HL indicated both

	;4L
	ldi r16, 0x04
	ldi r18, 0b01000000
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;5L
	ldi r16, 0x05
	ldi r18, 0b01000000
	rcall MAX7219_WRITE
	
	;delay
	rcall FRAME_DELAY

	;6L
	ldi r16, 0x06
	ldi r18, 0b00100000
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;7L
	ldi r16, 0x07
	ldi r18, 0b00010000
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;8L
	ldi r16, 0x08
	ldi r18, 0b00001000
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;8HL
	ldi r16, 0x08
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;7HL
	ldi r16, 0x07
	ldi r18, 0b00010010
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;6HL
	ldi r16, 0x06
	ldi r18, 0b00100010
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;5HL
	ldi r16, 0x05
	ldi r18, 0b01000100
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;4HL
	ldi r16, 0x04
	ldi r18, 0b01000100
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;3H
	ldi r16, 0x03
	ldi r18, 0b00000010
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;2H
	ldi r16, 0x02
	ldi r18, 0b00000010
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;1H
	ldi r16, 0x01
	ldi r18, 0b00000100
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;1HL
	ldi r16, 0x01
	ldi r18, 0b00001100
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY

	;2HL
	ldi r16, 0x02
	ldi r18, 0b00010010
	rcall MAX7219_WRITE

	;delay
	rcall FRAME_DELAY
	
	;3HL
	ldi r16, 0x03
	ldi r18, 0b00100010
	rcall MAX7219_WRITE
	
	;delay
	rcall FRAME_DELAY

	ret

TC_INIT:
	;use OCR1A register to set the period
	;use CTC clear timer on compare mode

	;set the digital period
	ldi r16, LOW(TC_PER)
	out OCR1AL, r16
	ldi r16, HIGH(TC_PER)
	out OCR1AH, r16

	;set the prescaler 0x05 is DIV1024
	ldi r16, (0x05 | (1<<WGM12))
	out TCCR1B, r16

	ret


FRAME_DELAY:
POLL:
	;poll the compare flag
	in r16, TIFR1
	sbrs r16, OCF1A
	rjmp POLL

	;clear the flag
	ldi r16, (1<<OCF1A)
	out TIFR1, r16

	ret

JEN_OUT:
	;output first frame
	rcall J_OUT
	;delay
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY

	;output second frame
	rcall E_OUT
	;delay
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	
	;output third frame
	rcall N_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	
	ret

BDAY_MESSAGE_OUT:
	rcall JEN_OUT

	;#1
	rcall HASHTAG_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY

	rcall ONE_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY

	;MOM
	rcall M_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY


	rcall O_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY

	rcall M_OUT
	rcall FRAME_DELAY
	rcall FRAME_DELAY
	;clear display
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY

	rcall HEART_OUTLINE_OUT_INC
	rcall FRAME_DELAY
	rcall HEART_FULL_OUT
	rcall FRAME_DELAY
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	rcall HEART_FULL_OUT
	rcall FRAME_DELAY
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	rcall HEART_FULL_OUT
	rcall FRAME_DELAY
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	rcall HEART_FULL_OUT
	rcall FRAME_DELAY
	rcall CLEAR_DISPLAY
	rcall FRAME_DELAY
	rcall HEART_FULL_OUT
	rcall FRAME_DELAY
	rcall CLEAR_DISPLAY

	ret
