	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0
	.globl	_counter_thread_thread          ; -- Begin function counter_thread_thread
	.p2align	2
_counter_thread_thread:                 ; @counter_thread_thread
	.cfi_startproc
; %bb.0:
	; InlineAsm Start
	ldr	x10, [x0]
loop:
	add	x10, x10, #1
	str	x10, [x0]
	b	loop

	; InlineAsm End
	mov	x0, #0                          ; =0x0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_timer_start                    ; -- Begin function timer_start
	.p2align	2
_timer_start:                           ; @timer_start
	.cfi_startproc
; %bb.0:
	adrp	x8, _timers_active@PAGE
	ldr	w9, [x8, _timers_active@PAGEOFF]
	add	w10, w9, #1
	str	w10, [x8, _timers_active@PAGEOFF]
	cbz	w9, LBB1_2
; %bb.1:
	ret
LBB1_2:
Lloh0:
	adrp	x0, _counter_thread@PAGE
Lloh1:
	add	x0, x0, _counter_thread@PAGEOFF
Lloh2:
	adrp	x2, _counter_thread_thread@PAGE
Lloh3:
	add	x2, x2, _counter_thread_thread@PAGEOFF
Lloh4:
	adrp	x3, _timestamp@PAGE
Lloh5:
	add	x3, x3, _timestamp@PAGEOFF
	mov	x1, #0                          ; =0x0
	b	_pthread_create
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.globl	_timer_stop                     ; -- Begin function timer_stop
	.p2align	2
_timer_stop:                            ; @timer_stop
	.cfi_startproc
; %bb.0:
	adrp	x8, _timers_active@PAGE
	ldr	w9, [x8, _timers_active@PAGEOFF]
	subs	w9, w9, #1
	str	w9, [x8, _timers_active@PAGEOFF]
	b.eq	LBB2_2
; %bb.1:
	ret
LBB2_2:
Lloh6:
	adrp	x8, _counter_thread@PAGE
Lloh7:
	ldr	x0, [x8, _counter_thread@PAGEOFF]
	b	_pthread_cancel
	.loh AdrpLdr	Lloh6, Lloh7
	.cfi_endproc
                                        ; -- End function
	.globl	_timers_active                  ; @timers_active
.zerofill __DATA,__common,_timers_active,4,2
	.globl	_counter_thread                 ; @counter_thread
.zerofill __DATA,__common,_counter_thread,8,3
	.globl	_timestamp                      ; @timestamp
.zerofill __DATA,__common,_timestamp,8,3
.subsections_via_symbols
