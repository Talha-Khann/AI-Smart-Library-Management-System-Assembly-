; ============================================================
;  AI SMART LIBRARY MANAGEMENT SYSTEM
;  Assembler : JWasm (MASM-compatible) + Irvine32
;  Fixed for : JWasm strict mode (no scaled index in data ref,
;              no out-of-range short jumps)
; ============================================================

INCLUDE Irvine32.inc

; ---------- sizes ------------------------------------------
MAX_BOOKS    EQU 50
MAX_ISSUES   EQU 100
BID_SZ       EQU 12
BNM_SZ       EQU 40
BAU_SZ       EQU 40
STN_SZ       EQU 40
DEP_SZ       EQU 20
DAT_SZ       EQU 14
SEM_SZ       EQU 6
CRD_SZ       EQU 12

FINE_RATE    EQU 10

.data

; ===== LOGIN =====
s_title  BYTE "========================================",0dh,0ah
         BYTE "  AI SMART LIBRARY MANAGEMENT SYSTEM   ",0dh,0ah
         BYTE "========================================",0dh,0ah,0
s_uname  BYTE "Username: ",0
s_pword  BYTE "Password: ",0
s_ok     BYTE 0dh,0ah,"Login Successfully!",0dh,0ah
         BYTE "Welcome to AI Smart Library Management System",0dh,0ah,0
s_err    BYTE "Invalid Username or Password. Try Again.",0dh,0ah,0
s_max    BYTE "Maximum attempts reached. Exiting.",0dh,0ah,0
s_load   BYTE "Loading",0
s_dot    BYTE ".",0

c_user   BYTE "admin",0
c_pass   BYTE "1234",0
b_user   BYTE 20 DUP(0)
b_pass   BYTE 20 DUP(0)

; ===== MENU =====
s_menu   BYTE 0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE "              MAIN MENU                 ",0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE " 1. Add Book                            ",0dh,0ah
         BYTE " 2. View All Books                      ",0dh,0ah
         BYTE " 3. Search Book                         ",0dh,0ah
         BYTE " 4. Issue Book                          ",0dh,0ah
         BYTE " 5. Return Book                         ",0dh,0ah
         BYTE " 6. Delete Book                         ",0dh,0ah
         BYTE " 7. Update Book Information             ",0dh,0ah
         BYTE " 8. Reset All Data                      ",0dh,0ah
         BYTE " 9. Library Stats                       ",0dh,0ah
         BYTE "10. AI Chatbot Assistant                ",0dh,0ah
         BYTE "11. Exit                                ",0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE "Enter Your Choice: ",0

s_inv    BYTE "Invalid choice!",0dh,0ah,0

; ===== COMMON PROMPTS =====
s_bid    BYTE "Enter Book ID   : ",0
s_bnm    BYTE "Enter Book Name : ",0
s_bau    BYTE "Enter Author    : ",0
s_bqt    BYTE "Enter Quantity  : ",0
s_conf   BYTE "Are you sure? (Y/N): ",0
s_cncl   BYTE "Cancelled.",0dh,0ah,0
s_nl     BYTE 0dh,0ah,0

s_added  BYTE "Book Added Successfully!",0dh,0ah,0
s_dup    BYTE "Error: Book ID already exists!",0dh,0ah,0
s_neg    BYTE "Error: Quantity cannot be negative!",0dh,0ah,0
s_full   BYTE "Library is full!",0dh,0ah,0
s_nobk   BYTE "No books found.",0dh,0ah,0
s_fnd    BYTE "Book Found:",0dh,0ah,0
s_nfnd   BYTE "Book Not Found.",0dh,0ah,0
s_deld   BYTE "Book Deleted Successfully!",0dh,0ah,0
s_upd    BYTE "Book Updated Successfully!",0dh,0ah,0

; ===== TABLE HEADER =====
s_thdr   BYTE 0dh,0ah
         BYTE "ID          Name                    Author              Qty  Status",0dh,0ah
         BYTE "----------  ----------------------  ------------------  ---  ----------",0dh,0ah,0
s_avail  BYTE "Available",0
s_oos    BYTE "OutOfStock",0

; ===== SEARCH =====
s_smenu  BYTE 0dh,0ah,"Search by: 1.Name  2.ID  3.Author : ",0

; ===== ISSUE =====
s_isshdr BYTE 0dh,0ah
         BYTE "====================================",0dh,0ah
         BYTE "         ISSUE BOOK MODULE          ",0dh,0ah
         BYTE "====================================",0dh,0ah,0
s_stid   BYTE "Student/User ID   : ",0
s_stn    BYTE "Student/User Name : ",0
s_fth    BYTE "Father Name       : ",0
s_crd    BYTE "Card ID           : ",0
s_dep    BYTE "Department        : ",0
s_sem    BYTE "Semester          : ",0
s_idat   BYTE "Issue Date (DD-MM-YYYY): ",0
s_ddat   BYTE "Return Date (DD-MM-YYYY): ",0
s_iss_ok BYTE 0dh,0ah
         BYTE "====================================",0dh,0ah
         BYTE "      Book Issued Successfully!     ",0dh,0ah
         BYTE "====================================",0dh,0ah,0
s_noav   BYTE 0dh,0ah,"Book is currently unavailable!",0dh,0ah,0
s_noiss  BYTE "Issue record storage is full.",0dh,0ah,0
s_dupiss BYTE 0dh,0ah,"Error: This student already has this book issued!",0dh,0ah,0
s_empin  BYTE 0dh,0ah,"Error: Input cannot be empty!",0dh,0ah,0

; ===== ISSUE SLIP =====
s_sliphd BYTE 0dh,0ah
         BYTE "====================================",0dh,0ah
         BYTE "        ISSUED BOOK DETAILS         ",0dh,0ah
         BYTE "====================================",0dh,0ah,0
s_lstu   BYTE "Student Name  : ",0
s_lstid  BYTE "Student ID    : ",0
s_lbnm   BYTE "Book Name     : ",0
s_lbid   BYTE "Book ID       : ",0
s_laut   BYTE "Author        : ",0
s_lidat  BYTE "Issue Date    : ",0
s_lrdat  BYTE "Return Date   : ",0
s_lstat  BYTE "Status        : ",0
s_lline  BYTE "====================================",0dh,0ah,0
s_lissued BYTE "Issued",0
s_lretd  BYTE "Returned",0
s_overdue BYTE " *** OVERDUE ***",0dh,0ah,0

; ===== RETURN =====
s_rethdr BYTE 0dh,0ah
         BYTE "====================================",0dh,0ah
         BYTE "        RETURN BOOK MODULE          ",0dh,0ah
         BYTE "====================================",0dh,0ah,0
s_rcrd   BYTE "Enter Student ID  : ",0
s_rbid   BYTE "Enter Book ID     : ",0
s_lday   BYTE "Late Days (0 if on time): ",0
s_fine   BYTE "Fine: ",0
s_rs     BYTE " Rupees",0dh,0ah,0
s_ret_ok BYTE 0dh,0ah
         BYTE "====================================",0dh,0ah
         BYTE "    Book Returned Successfully!     ",0dh,0ah
         BYTE "====================================",0dh,0ah,0
s_nrec   BYTE 0dh,0ah,"No matching issue record found.",0dh,0ah,0
s_alrret BYTE 0dh,0ah,"This book has already been returned.",0dh,0ah,0

; ===== PRESS ENTER =====
s_press  BYTE 0dh,0ah,"Press Enter to return to Main Menu...",0dh,0ah,0

; ===== STATS =====
s_shdr   BYTE 0dh,0ah,"======= LIBRARY STATS =======",0dh,0ah,0
s_stbk   BYTE "Total Books   : ",0
s_savl   BYTE "Available     : ",0
s_siss   BYTE "Issued        : ",0
s_sstu   BYTE "Students      : ",0
s_sfin   BYTE "Fine Collected: Rs ",0
s_scap   BYTE "Capacity      : 500",0dh,0ah,0

; ===== RESET =====
s_wrn1   BYTE 0dh,0ah,"WARNING: ALL DATA WILL BE DELETED!",0dh,0ah,0
s_wrn2   BYTE "Type Y to confirm: ",0
s_rst_ok BYTE "All data reset.",0dh,0ah,0

; ===== EXIT =====
s_bye    BYTE 0dh,0ah,"Thank You For Using",0dh,0ah
         BYTE "AI Smart Library Management System",0dh,0ah,0

; ===== AI CHATBOT DATA =====
; Chatbot UI
s_cbhdr  BYTE 0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE "     AI SMART LIBRARY CHATBOT v1.0      ",0dh,0ah
         BYTE "  3 AI Assistants Ready To Help You!    ",0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE " TALHA   - Search, Recommend & Help     ",0dh,0ah
         BYTE " AHSAN   - Issue & Return Help          ",0dh,0ah
         BYTE " HUZAIFA - Library Stats & Info         ",0dh,0ah
         BYTE "========================================",0dh,0ah
         BYTE "Type 'exit' to return to Main Menu      ",0dh,0ah
         BYTE "Commands: search, issue, return,        ",0dh,0ah
         BYTE "          recommend, stats, help, fine  ",0dh,0ah
         BYTE "========================================",0dh,0ah,0

s_cbpmt  BYTE 0dh,0ah,"You >> ",0

; AI assistant name prefixes
s_talha  BYTE 0dh,0ah,"[TALHA]   >> ",0
s_ahsan  BYTE 0dh,0ah,"[AHSAN]   >> ",0
s_huz    BYTE 0dh,0ah,"[HUZAIFA] >> ",0

; Chatbot keywords
cb_search  BYTE "search",0
cb_issue   BYTE "issue",0
cb_return  BYTE "return",0
cb_help    BYTE "help",0
cb_rec     BYTE "recommend",0
cb_stats   BYTE "stats",0
cb_fine    BYTE "fine",0
cb_exit    BYTE "exit",0
cb_add     BYTE "add",0
cb_delete  BYTE "delete",0
cb_update  BYTE "update",0
cb_hello   BYTE "hello",0
cb_hi      BYTE "hi",0
cb_book    BYTE "book",0
cb_author  BYTE "author",0

; TALHA - Search & Recommendations responses
s_talha1  BYTE "To SEARCH a book, go to Main Menu > Option 3.",0dh,0ah
         BYTE "         You can search by: Name, ID, or Author!",0dh,0ah,0
s_talha2  BYTE "I can RECOMMEND books for you!",0dh,0ah
         BYTE "         > If you liked 'C Programming' try: Data Structures, Algorithms.",0dh,0ah
         BYTE "         > For 'Networks' try: OS Concepts, Computer Architecture.",0dh,0ah
         BYTE "         > For 'Maths' try: Discrete Math, Linear Algebra.",0dh,0ah,0
s_talha3  BYTE "Looking for a book by AUTHOR?",0dh,0ah
         BYTE "         Use Search (Option 3) and choose '3. Author' search mode.",0dh,0ah
         BYTE "         I will find all books by that author for you!",0dh,0ah,0

; AHSAN - Issue & Return responses
s_ahsan1 BYTE "To ISSUE a book:",0dh,0ah
         BYTE "         1. Go to Main Menu > Option 4",0dh,0ah
         BYTE "         2. Enter your Name, Student ID, Book details",0dh,0ah
         BYTE "         3. Enter Issue Date and Return Date",0dh,0ah
         BYTE "         4. You will receive a printed slip!",0dh,0ah,0
s_ahsan2 BYTE "To RETURN a book:",0dh,0ah
         BYTE "         1. Go to Main Menu > Option 5",0dh,0ah
         BYTE "         2. Enter your Student ID and Book ID",0dh,0ah
         BYTE "         3. Enter late days (0 if on time)",0dh,0ah
         BYTE "         4. Fine = Late Days x 10 Rupees",0dh,0ah,0
s_ahsan3 BYTE "FINE Calculation:",0dh,0ah
         BYTE "         Fine Rate = 10 Rupees per late day",0dh,0ah
         BYTE "         Example: 5 days late = 50 Rupees fine",0dh,0ah
         BYTE "         Always return books on the due date!",0dh,0ah,0

; HUZAIFA - Stats & Info responses
s_huz1  BYTE "LIBRARY STATISTICS available at Option 9.",0dh,0ah
         BYTE "         HUZAIFA shows you: Total Books, Available,",0dh,0ah
         BYTE "         Issued count, Student count & Fines collected!",0dh,0ah,0
s_huz2  BYTE "LIBRARY CAPACITY INFO:",0dh,0ah
         BYTE "         Max Books Allowed  : 50 titles",0dh,0ah
         BYTE "         Max Issue Records  : 100 records",0dh,0ah
         BYTE "         Fine Rate          : 10 Rs/day",0dh,0ah
         BYTE "         System             : AI Smart Library v1.0",0dh,0ah,0
s_huz3  BYTE "ADDING a new book (Admin only):",0dh,0ah
         BYTE "         Option 1 -> Enter ID, Name, Author, Quantity",0dh,0ah
         BYTE "         Duplicate IDs are not allowed!",0dh,0ah
         BYTE "         Quantity must be 0 or greater.",0dh,0ah,0

; TALHA - General Help & Tips responses
s_talha6  BYTE "Hi! I am TALHA, your friendly library guide!",0dh,0ah
         BYTE "         Available commands you can type:",0dh,0ah
         BYTE "         search, issue, return, recommend,",0dh,0ah
         BYTE "         stats, fine, help, add, delete, update",0dh,0ah,0
s_talha7  BYTE "TIPS for using the library system:",0dh,0ah
         BYTE "         * Always note your Book ID when issuing",0dh,0ah
         BYTE "         * Return books before the due date",0dh,0ah
         BYTE "         * Use Reset (Option 8) only when sure!",0dh,0ah
         BYTE "         * Admin login: username=admin, pass=1234",0dh,0ah,0
s_talha8  BYTE "MENU GUIDE - Quick Reference:",0dh,0ah
         BYTE "         1=Add  2=View  3=Search  4=Issue",0dh,0ah
         BYTE "         5=Return  6=Delete  7=Update",0dh,0ah
         BYTE "         8=Reset  9=Stats  10=Chatbot  11=Exit",0dh,0ah,0
s_talha4  BYTE "DELETE a book (Admin):",0dh,0ah
         BYTE "         Option 6 -> Enter Book ID -> Confirm Y/N",0dh,0ah
         BYTE "         Warning: This cannot be undone!",0dh,0ah,0
s_talha5  BYTE "UPDATE book info (Admin):",0dh,0ah
         BYTE "         Option 7 -> Enter Book ID",0dh,0ah
         BYTE "         You can update: Name, Author, Quantity",0dh,0ah,0

; Fallback response
s_cbunk  BYTE "Hmm, I did not understand that.",0dh,0ah
         BYTE "         Try typing: help, search, issue, return,",0dh,0ah
         BYTE "         recommend, stats, fine, add, delete, update",0dh,0ah,0
s_cbgreet BYTE "Hello! Welcome to AI Smart Library!",0dh,0ah
         BYTE "         I have 4 AI assistants ready to help you.",0dh,0ah
         BYTE "         Type 'help' to see what I can do!",0dh,0ah,0

; chatbot input buffer
cb_input BYTE 60 DUP(0)

; ===== BOOK DATA (flat arrays) =====
; We use flat byte arrays and compute offsets manually
; bookQty is a DWORD array stored as bytes (4 bytes each)

bkID     BYTE MAX_BOOKS * BID_SZ  DUP(0)
bkNM     BYTE MAX_BOOKS * BNM_SZ  DUP(0)
bkAU     BYTE MAX_BOOKS * BAU_SZ  DUP(0)
bkQT     BYTE MAX_BOOKS * 4       DUP(0)   ; DWORD stored as 4 bytes
bkCnt    DWORD 0

; ===== ISSUE DATA =====
isSTN    BYTE MAX_ISSUES * STN_SZ  DUP(0)
isSTID   BYTE MAX_ISSUES * CRD_SZ  DUP(0)   ; Student/User ID
isFTH    BYTE MAX_ISSUES * STN_SZ  DUP(0)
isCRD    BYTE MAX_ISSUES * CRD_SZ  DUP(0)
isDEP    BYTE MAX_ISSUES * DEP_SZ  DUP(0)
isSEM    BYTE MAX_ISSUES * SEM_SZ  DUP(0)
isBID    BYTE MAX_ISSUES * BID_SZ  DUP(0)
isBNM    BYTE MAX_ISSUES * BNM_SZ  DUP(0)
isBAU    BYTE MAX_ISSUES * BAU_SZ  DUP(0)   ; Author per issue record
isIDT    BYTE MAX_ISSUES * DAT_SZ  DUP(0)
isDDT    BYTE MAX_ISSUES * DAT_SZ  DUP(0)
isACT    BYTE MAX_ISSUES           DUP(0)   ; 1=active/issued  0=returned
isCnt    DWORD 0

totFine  DWORD 0
stuCnt   DWORD 0

; ===== TEMP BUFFERS =====
tID      BYTE BID_SZ  DUP(0)
tNM      BYTE BNM_SZ  DUP(0)
tAU      BYTE BAU_SZ  DUP(0)
tQT      DWORD 0
tSTN     BYTE STN_SZ  DUP(0)
tSTID    BYTE CRD_SZ  DUP(0)   ; Student/User ID temp
tFTH     BYTE STN_SZ  DUP(0)
tCRD     BYTE CRD_SZ  DUP(0)
tDEP     BYTE DEP_SZ  DUP(0)
tSEM     BYTE SEM_SZ  DUP(0)
tIDT     BYTE DAT_SZ  DUP(0)
tDDT     BYTE DAT_SZ  DUP(0)
tDAY     DWORD 0

gIdx     DWORD 0
gFlg     DWORD 0
yn_buf   BYTE 4 DUP(0)

; helper: space string for padding
sp2      BYTE "  ",0
sp1      BYTE " ",0

.code

; ============================================================
; ZeroBuffer  EDI=start, ECX=count
; ============================================================
ZeroBuffer PROC
    push eax
    push ecx
    push edi
zb_lp:
    cmp  ecx, 0
    je   zb_dn
    mov  BYTE PTR [edi], 0
    inc  edi
    dec  ecx
    jmp  zb_lp
zb_dn:
    pop  edi
    pop  ecx
    pop  eax
    ret
ZeroBuffer ENDP

; ============================================================
; StrCopyN  ESI=src, EDI=dst, ECX=maxbytes
; ============================================================
StrCopyN PROC
    push eax
    push ecx
    push esi
    push edi
scn_lp:
    cmp  ecx, 0
    je   scn_dn
    mov  al, [esi]
    mov  [edi], al
    cmp  al, 0
    je   scn_dn
    inc  esi
    inc  edi
    dec  ecx
    jmp  scn_lp
scn_dn:
    ; null-terminate
    mov  BYTE PTR [edi], 0
    pop  edi
    pop  esi
    pop  ecx
    pop  eax
    ret
StrCopyN ENDP

; ============================================================
; StrCmpEqual  ESI=s1, EDI=s2  -> EAX=1 if equal, 0 if not
; ============================================================
StrCmpEqual PROC
    push esi
    push edi
    push ebx
sce_lp:
    mov  al, [esi]
    mov  bl, [edi]
    cmp  al, bl
    jne  sce_no
    cmp  al, 0
    je   sce_yes
    inc  esi
    inc  edi
    jmp  sce_lp
sce_yes:
    mov  eax, 1
    jmp  sce_dn
sce_no:
    mov  eax, 0
sce_dn:
    pop  ebx
    pop  edi
    pop  esi
    ret
StrCmpEqual ENDP

; ============================================================
; ToLower AL -> AL
; ============================================================
ToLower PROC
    cmp  al, 'A'
    jb   tl_dn
    cmp  al, 'Z'
    ja   tl_dn
    add  al, 32
tl_dn:
    ret
ToLower ENDP

; ============================================================
; StrContainsCI  ESI=haystack, EDI=needle -> EAX=1/0
; ============================================================
StrContainsCI PROC
    push esi
    push edi
    push ebx
    push ecx

    mov  ebx, esi          ; save haystack start
scci_outer:
    mov  al, [esi]
    cmp  al, 0
    je   scci_fail

    ; try matching needle from here
    push esi
    push edi
scci_inner:
    mov  cl, [edi]
    cmp  cl, 0
    je   scci_match        ; needle exhausted = match

    mov  al, [esi]
    cmp  al, 0
    je   scci_inner_fail

    call ToLower
    push eax
    mov  al, cl
    call ToLower
    mov  cl, al
    pop  eax
    cmp  al, cl
    jne  scci_inner_fail
    inc  esi
    inc  edi
    jmp  scci_inner

scci_inner_fail:
    pop  edi
    pop  esi
    inc  esi
    jmp  scci_outer

scci_match:
    pop  edi
    pop  esi
    mov  eax, 1
    jmp  scci_dn
scci_fail:
    mov  eax, 0
scci_dn:
    pop  ecx
    pop  ebx
    pop  edi
    pop  esi
    ret
StrContainsCI ENDP

; ============================================================
; GetBookQty  EBX=book_index -> EAX=qty
; ============================================================
GetBookQty PROC
    push edx
    mov  eax, ebx
    mov  edx, 4
    mul  edx               ; eax = ebx*4
    add  eax, OFFSET bkQT
    mov  eax, DWORD PTR [eax]
    pop  edx
    ret
GetBookQty ENDP

; ============================================================
; SetBookQty  EBX=book_index, ECX=qty
; ============================================================
SetBookQty PROC
    push eax
    push edx
    mov  eax, ebx
    mov  edx, 4
    mul  edx
    add  eax, OFFSET bkQT
    mov  DWORD PTR [eax], ecx
    pop  edx
    pop  eax
    ret
SetBookQty ENDP

; ============================================================
; FindBookByID  EDX=id_ptr -> EAX=index or -1
; ============================================================
FindBookByID PROC
    push esi
    push edi
    push ebx
    push ecx
    push edx

    mov  ebx, 0
fbid_lp:
    cmp  ebx, bkCnt
    jae  fbid_fail

    ; address of bkID[ebx * BID_SZ]
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET bkID
    mov  esi, eax
    mov  edi, edx          ; edi = search term

    call StrCmpEqual
    cmp  eax, 1
    je   fbid_ok

    inc  ebx
    jmp  fbid_lp

fbid_ok:
    mov  eax, ebx
    jmp  fbid_dn
fbid_fail:
    mov  eax, 0FFFFFFFFh
fbid_dn:
    pop  edx
    pop  ecx
    pop  ebx
    pop  edi
    pop  esi
    ret
FindBookByID ENDP

; ============================================================
; PrintFixed  EDX=str, ECX=field_width  (pads with spaces)
; ============================================================
PrintFixed PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov  esi, edx
    ; count length
    mov  ebx, 0
pf_cnt:
    mov  al, [esi]
    cmp  al, 0
    je   pf_pr
    inc  ebx
    inc  esi
    jmp  pf_cnt
pf_pr:
    call WriteString       ; print str (EDX)

    ; pad
    mov  eax, ecx
    sub  eax, ebx
    jle  pf_dn
pf_sp:
    push eax
    mov  al, ' '
    call WriteChar
    pop  eax
    dec  eax
    cmp  eax, 0
    jg   pf_sp
pf_dn:
    pop  esi
    pop  edx
    pop  ecx
    pop  ebx
    pop  eax
    ret
PrintFixed ENDP

; ============================================================
; PrintBookRow  EBX=book_index
; ============================================================
PrintBookRow PROC
    push eax
    push ecx
    push edx

    ; ID
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET bkID
    mov  edx, eax
    mov  ecx, 12
    call PrintFixed

    ; Name
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  edx, eax
    mov  ecx, 24
    call PrintFixed

    ; Author
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  edx, eax
    mov  ecx, 20
    call PrintFixed

    ; Qty
    call GetBookQty        ; eax = qty (ebx = index)
    push eax
    call WriteDec
    pop  eax
    mov  edx, OFFSET sp2
    call WriteString

    ; Status
    push eax
    call GetBookQty
    cmp  eax, 0
    je   pbr_oos
    mov  edx, OFFSET s_avail
    call WriteString
    jmp  pbr_nl
pbr_oos:
    mov  edx, OFFSET s_oos
    call WriteString
pbr_nl:
    pop  eax
    call Crlf

    pop  edx
    pop  ecx
    pop  eax
    ret
PrintBookRow ENDP

; ============================================================
; ShowLoading
; ============================================================
ShowLoading PROC
    mov  edx, OFFSET s_load
    call WriteString
    mov  ecx, 5
sl_lp:
    push ecx
    mov  edx, OFFSET s_dot
    call WriteString
    mov  eax, 300
    call Delay
    pop  ecx
    loop sl_lp
    call Crlf
    ret
ShowLoading ENDP

; ============================================================
; DoLogin
; ============================================================
DoLogin PROC
    mov  ecx, 3
dol_try:
    push ecx

    ; clear buffers
    mov  edi, OFFSET b_user
    mov  ecx, 20
    call ZeroBuffer
    mov  edi, OFFSET b_pass
    mov  ecx, 20
    call ZeroBuffer

    call Clrscr
    mov  edx, OFFSET s_title
    call WriteString

    mov  edx, OFFSET s_uname
    call WriteString
    mov  edx, OFFSET b_user
    mov  ecx, 19
    call ReadString

    mov  edx, OFFSET s_pword
    call WriteString
    mov  edx, OFFSET b_pass
    mov  ecx, 19
    call ReadString

    ; check username
    mov  esi, OFFSET b_user
    mov  edi, OFFSET c_user
    call StrCmpEqual
    cmp  eax, 1
    jne  dol_fail

    ; check password
    mov  esi, OFFSET b_pass
    mov  edi, OFFSET c_pass
    call StrCmpEqual
    cmp  eax, 1
    jne  dol_fail

    ; success
    mov  edx, OFFSET s_ok
    call WriteString
    call ShowLoading
    pop  ecx
    ret

dol_fail:
    mov  edx, OFFSET s_err
    call WriteString
    pop  ecx
    dec  ecx
    cmp  ecx, 0
    je   dol_out
    push ecx
    jmp  dol_try
dol_out:
    mov  edx, OFFSET s_max
    call WriteString
    call WaitMsg
    invoke ExitProcess, 0
DoLogin ENDP

; ============================================================
; AddBook
; ============================================================
AddBook PROC
    call Clrscr

    ; check capacity
    cmp  bkCnt, MAX_BOOKS
    jb   ab_go
    mov  edx, OFFSET s_full
    call WriteString
    ret
ab_go:
    mov  edx, OFFSET s_bid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString

    ; check duplicate
    mov  edx, OFFSET tID
    call FindBookByID
    cmp  eax, 0FFFFFFFFh
    je   ab_nodup
    mov  edx, OFFSET s_dup
    call WriteString
    ret
ab_nodup:

    mov  edx, OFFSET s_bnm
    call WriteString
    mov  edx, OFFSET tNM
    mov  ecx, BNM_SZ - 1
    call ReadString

    mov  edx, OFFSET s_bau
    call WriteString
    mov  edx, OFFSET tAU
    mov  ecx, BAU_SZ - 1
    call ReadString

    mov  edx, OFFSET s_bqt
    call WriteString
    call ReadInt
    cmp  eax, 0
    jge  ab_qok
    mov  edx, OFFSET s_neg
    call WriteString
    ret
ab_qok:
    mov  tQT, eax

    ; get slot index into EBX
    mov  ebx, bkCnt

    ; store ID
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET bkID
    mov  edi, eax
    mov  esi, OFFSET tID
    mov  ecx, BID_SZ
    call StrCopyN

    ; store Name
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  edi, eax
    mov  esi, OFFSET tNM
    mov  ecx, BNM_SZ
    call StrCopyN

    ; store Author
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  edi, eax
    mov  esi, OFFSET tAU
    mov  ecx, BAU_SZ
    call StrCopyN

    ; store Qty
    mov  ecx, tQT
    call SetBookQty        ; ebx=index, ecx=qty

    inc  bkCnt
    mov  edx, OFFSET s_added
    call WriteString
    ret
AddBook ENDP

; ============================================================
; ViewAllBooks
; ============================================================
ViewAllBooks PROC
    call Clrscr
    cmp  bkCnt, 0
    jne  vab_go
    mov  edx, OFFSET s_nobk
    call WriteString
    ret
vab_go:
    mov  edx, OFFSET s_thdr
    call WriteString
    mov  ebx, 0
vab_lp:
    cmp  ebx, bkCnt
    jae  vab_dn
    call PrintBookRow
    inc  ebx
    jmp  vab_lp
vab_dn:
    call Crlf
    mov  edx, OFFSET s_stbk
    call WriteString
    mov  eax, bkCnt
    call WriteDec
    call Crlf
    ret
ViewAllBooks ENDP

; ============================================================
; SearchBook
; ============================================================
SearchBook PROC
    call Clrscr
    mov  edx, OFFSET s_smenu
    call WriteString
    call ReadInt
    mov  gFlg, eax

    cmp  gFlg, 1
    je   sb_name
    cmp  gFlg, 2
    je   sb_id
    cmp  gFlg, 3
    je   sb_auth
    ret

; --- by name ---
sb_name:
    mov  edx, OFFSET s_bnm
    call WriteString
    mov  edx, OFFSET tNM
    mov  ecx, BNM_SZ - 1
    call ReadString

    mov  ebx, 0
    mov  gIdx, 0FFFFFFFFh
sb_nm_lp:
    cmp  ebx, bkCnt
    jae  sb_show

    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  esi, eax
    mov  edi, OFFSET tNM
    call StrContainsCI
    cmp  eax, 1
    jne  sb_nm_nx
    mov  gIdx, ebx
    jmp  sb_show
sb_nm_nx:
    inc  ebx
    jmp  sb_nm_lp

; --- by id ---
sb_id:
    mov  edx, OFFSET s_bid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString
    mov  edx, OFFSET tID
    call FindBookByID
    mov  gIdx, eax
    jmp  sb_show

; --- by author ---
sb_auth:
    mov  edx, OFFSET s_bau
    call WriteString
    mov  edx, OFFSET tAU
    mov  ecx, BAU_SZ - 1
    call ReadString

    mov  ebx, 0
    mov  gIdx, 0FFFFFFFFh
sb_au_lp:
    cmp  ebx, bkCnt
    jae  sb_show

    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  esi, eax
    mov  edi, OFFSET tAU
    call StrContainsCI
    cmp  eax, 1
    jne  sb_au_nx
    mov  gIdx, ebx
    jmp  sb_show
sb_au_nx:
    inc  ebx
    jmp  sb_au_lp

sb_show:
    cmp  gIdx, 0FFFFFFFFh
    jne  sb_print
    mov  edx, OFFSET s_nfnd
    call WriteString
    ret
sb_print:
    mov  edx, OFFSET s_fnd
    call WriteString
    mov  edx, OFFSET s_thdr
    call WriteString
    mov  ebx, gIdx
    call PrintBookRow
    ret
SearchBook ENDP

; ============================================================
; CheckEmpty  EDX=str_ptr -> EAX=1 if empty, 0 if not
; ============================================================
CheckEmpty PROC
    push esi
    mov  esi, edx
    mov  al, [esi]
    cmp  al, 0
    je   ce_empty
    mov  eax, 0
    jmp  ce_dn
ce_empty:
    mov  eax, 1
ce_dn:
    pop  esi
    ret
CheckEmpty ENDP

; ============================================================
; PressEnterPrompt  - shows "Press Enter..." and waits
; ============================================================
PressEnterPrompt PROC
    mov  edx, OFFSET s_press
    call WriteString
    ; consume any remaining chars then wait for Enter
    mov  edx, OFFSET yn_buf
    mov  ecx, 2
    call ReadString
    ret
PressEnterPrompt ENDP

; ============================================================
; PrintIssueRecord  EBX=issue_index
; prints a single formatted issue record
; ============================================================
PrintIssueRecord PROC
    push eax
    push ecx
    push edx
    push esi

    mov  edx, OFFSET s_lline
    call WriteString

    ; Student Name
    mov  edx, OFFSET s_lstu
    call WriteString
    mov  eax, ebx
    mov  ecx, STN_SZ
    mul  ecx
    add  eax, OFFSET isSTN
    mov  edx, eax
    call WriteString
    call Crlf

    ; Student ID
    mov  edx, OFFSET s_lstid
    call WriteString
    mov  eax, ebx
    mov  ecx, CRD_SZ
    mul  ecx
    add  eax, OFFSET isSTID
    mov  edx, eax
    call WriteString
    call Crlf

    ; Book Name
    mov  edx, OFFSET s_lbnm
    call WriteString
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET isBNM
    mov  edx, eax
    call WriteString
    call Crlf

    ; Book ID
    mov  edx, OFFSET s_lbid
    call WriteString
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET isBID
    mov  edx, eax
    call WriteString
    call Crlf

    ; Author
    mov  edx, OFFSET s_laut
    call WriteString
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET isBAU
    mov  edx, eax
    call WriteString
    call Crlf

    ; Issue Date
    mov  edx, OFFSET s_lidat
    call WriteString
    mov  eax, ebx
    mov  ecx, DAT_SZ
    mul  ecx
    add  eax, OFFSET isIDT
    mov  edx, eax
    call WriteString
    call Crlf

    ; Return Date
    mov  edx, OFFSET s_lrdat
    call WriteString
    mov  eax, ebx
    mov  ecx, DAT_SZ
    mul  ecx
    add  eax, OFFSET isDDT
    mov  edx, eax
    call WriteString
    call Crlf

    ; Status
    mov  edx, OFFSET s_lstat
    call WriteString
    mov  eax, ebx
    add  eax, OFFSET isACT
    mov  al, BYTE PTR [eax]
    cmp  al, 1
    jne  pir_ret
    mov  edx, OFFSET s_lissued
    call WriteString
    call Crlf
    ; show overdue note (simple: always show if issued - user enters overdue date manually)
    ; We print the overdue warning as a reminder to check dates
    mov  edx, OFFSET s_overdue
    call WriteString
    jmp  pir_dn
pir_ret:
    mov  edx, OFFSET s_lretd
    call WriteString
    call Crlf
pir_dn:
    mov  edx, OFFSET s_lline
    call WriteString
    call Crlf

    pop  esi
    pop  edx
    pop  ecx
    pop  eax
    ret
PrintIssueRecord ENDP

; ============================================================
; IssueBook
; Asks user for all details manually, stores them, shows slip
; ============================================================
IssueBook PROC
    call Clrscr

    ; --- Header ---
    mov  edx, OFFSET s_isshdr
    call WriteString

    ; check storage not full
    cmp  isCnt, MAX_ISSUES
    jb   ib_go
    mov  edx, OFFSET s_noiss
    call WriteString
    call PressEnterPrompt
    ret
ib_go:

    ; ---- 1. Student Name ----
    mov  edx, OFFSET s_stn
    call WriteString
    mov  edx, OFFSET tSTN
    mov  ecx, STN_SZ - 1
    call ReadString
    mov  edx, OFFSET tSTN
    call CheckEmpty
    cmp  eax, 1
    jne  ib_stn_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_stn_ok:

    ; ---- 2. Student ID ----
    mov  edx, OFFSET s_stid
    call WriteString
    mov  edx, OFFSET tSTID
    mov  ecx, CRD_SZ - 1
    call ReadString
    mov  edx, OFFSET tSTID
    call CheckEmpty
    cmp  eax, 1
    jne  ib_stid_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_stid_ok:

    ; ---- 3. Book Name ----
    mov  edx, OFFSET s_bnm
    call WriteString
    mov  edx, OFFSET tNM
    mov  ecx, BNM_SZ - 1
    call ReadString
    mov  edx, OFFSET tNM
    call CheckEmpty
    cmp  eax, 1
    jne  ib_bnm_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_bnm_ok:

    ; ---- 4. Book ID ----
    mov  edx, OFFSET s_bid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString
    mov  edx, OFFSET tID
    call CheckEmpty
    cmp  eax, 1
    jne  ib_bid_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_bid_ok:

    ; ---- 5. Author ----
    mov  edx, OFFSET s_bau
    call WriteString
    mov  edx, OFFSET tAU
    mov  ecx, BAU_SZ - 1
    call ReadString
    mov  edx, OFFSET tAU
    call CheckEmpty
    cmp  eax, 1
    jne  ib_au_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_au_ok:

    ; ---- 6. Issue Date ----
    mov  edx, OFFSET s_idat
    call WriteString
    mov  edx, OFFSET tIDT
    mov  ecx, DAT_SZ - 1
    call ReadString
    mov  edx, OFFSET tIDT
    call CheckEmpty
    cmp  eax, 1
    jne  ib_idt_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_idt_ok:

    ; ---- 7. Return Date ----
    mov  edx, OFFSET s_ddat
    call WriteString
    mov  edx, OFFSET tDDT
    mov  ecx, DAT_SZ - 1
    call ReadString
    mov  edx, OFFSET tDDT
    call CheckEmpty
    cmp  eax, 1
    jne  ib_ddt_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
ib_ddt_ok:

    ; ---- Store record into issue arrays ----
    mov  esi, isCnt          ; ESI = current slot index

    ; Student Name -> isSTN[slot]
    mov  eax, esi
    mov  ecx, STN_SZ
    mul  ecx
    add  eax, OFFSET isSTN
    mov  edi, eax
    push esi
    mov  esi, OFFSET tSTN
    mov  ecx, STN_SZ
    call StrCopyN
    pop  esi

    ; Student ID -> isSTID[slot]
    mov  eax, esi
    mov  ecx, CRD_SZ
    mul  ecx
    add  eax, OFFSET isSTID
    mov  edi, eax
    push esi
    mov  esi, OFFSET tSTID
    mov  ecx, CRD_SZ
    call StrCopyN
    pop  esi

    ; Book Name -> isBNM[slot]
    mov  eax, esi
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET isBNM
    mov  edi, eax
    push esi
    mov  esi, OFFSET tNM
    mov  ecx, BNM_SZ
    call StrCopyN
    pop  esi

    ; Book ID -> isBID[slot]
    mov  eax, esi
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET isBID
    mov  edi, eax
    push esi
    mov  esi, OFFSET tID
    mov  ecx, BID_SZ
    call StrCopyN
    pop  esi

    ; Author -> isBAU[slot]
    mov  eax, esi
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET isBAU
    mov  edi, eax
    push esi
    mov  esi, OFFSET tAU
    mov  ecx, BAU_SZ
    call StrCopyN
    pop  esi

    ; Issue Date -> isIDT[slot]
    mov  eax, esi
    mov  ecx, DAT_SZ
    mul  ecx
    add  eax, OFFSET isIDT
    mov  edi, eax
    push esi
    mov  esi, OFFSET tIDT
    mov  ecx, DAT_SZ
    call StrCopyN
    pop  esi

    ; Return Date -> isDDT[slot]
    mov  eax, esi
    mov  ecx, DAT_SZ
    mul  ecx
    add  eax, OFFSET isDDT
    mov  edi, eax
    push esi
    mov  esi, OFFSET tDDT
    mov  ecx, DAT_SZ
    call StrCopyN
    pop  esi

    ; Mark as Issued (active = 1)
    mov  eax, esi
    add  eax, OFFSET isACT
    mov  BYTE PTR [eax], 1

    inc  isCnt
    inc  stuCnt

    ; ---- Success message ----
    mov  edx, OFFSET s_iss_ok
    call WriteString

    ; ---- Print formatted slip ----
    mov  edx, OFFSET s_sliphd
    call WriteString

    mov  edx, OFFSET s_lstu
    call WriteString
    mov  edx, OFFSET tSTN
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lstid
    call WriteString
    mov  edx, OFFSET tSTID
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lbnm
    call WriteString
    mov  edx, OFFSET tNM
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lbid
    call WriteString
    mov  edx, OFFSET tID
    call WriteString
    call Crlf

    mov  edx, OFFSET s_laut
    call WriteString
    mov  edx, OFFSET tAU
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lidat
    call WriteString
    mov  edx, OFFSET tIDT
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lrdat
    call WriteString
    mov  edx, OFFSET tDDT
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lstat
    call WriteString
    mov  edx, OFFSET s_lissued
    call WriteString
    call Crlf

    mov  edx, OFFSET s_lline
    call WriteString

    call PressEnterPrompt
    ret
IssueBook ENDP

; ============================================================
; ReturnBook  (enhanced)
; ============================================================
ReturnBook PROC
    call Clrscr

    mov  edx, OFFSET s_rethdr
    call WriteString

    mov  edx, OFFSET s_rcrd
    call WriteString
    mov  edx, OFFSET tSTID
    mov  ecx, CRD_SZ - 1
    call ReadString

    ; validate not empty
    mov  edx, OFFSET tSTID
    call CheckEmpty
    cmp  eax, 1
    jne  rb_stid_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
rb_stid_ok:

    mov  edx, OFFSET s_rbid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString

    mov  edx, OFFSET tID
    call CheckEmpty
    cmp  eax, 1
    jne  rb_bid_ok
    mov  edx, OFFSET s_empin
    call WriteString
    call PressEnterPrompt
    ret
rb_bid_ok:

    ; find matching record (student ID + book ID)
    mov  ebx, 0
rb_lp:
    cmp  ebx, isCnt
    jae  rb_nfnd

    ; compare student ID
    push ebx
    mov  eax, ebx
    mov  ecx, CRD_SZ
    mul  ecx
    add  eax, OFFSET isSTID
    mov  esi, eax
    mov  edi, OFFSET tSTID
    call StrCmpEqual
    pop  ebx
    cmp  eax, 0
    je   rb_nx

    ; compare book ID
    push ebx
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET isBID
    mov  esi, eax
    mov  edi, OFFSET tID
    call StrCmpEqual
    pop  ebx
    cmp  eax, 0
    je   rb_nx

    jmp  rb_fnd
rb_nx:
    inc  ebx
    jmp  rb_lp

rb_nfnd:
    mov  edx, OFFSET s_nrec
    call WriteString
    call PressEnterPrompt
    ret

rb_fnd:
    ; check if already returned
    mov  eax, ebx
    add  eax, OFFSET isACT
    mov  al, BYTE PTR [eax]
    cmp  al, 1
    je   rb_do_return
    mov  edx, OFFSET s_alrret
    call WriteString
    call PressEnterPrompt
    ret

rb_do_return:
    ; mark as returned (0)
    mov  eax, ebx
    add  eax, OFFSET isACT
    mov  BYTE PTR [eax], 0

    ; restore book quantity
    push ebx
    mov  edx, OFFSET tID
    call FindBookByID
    cmp  eax, 0FFFFFFFFh
    je   rb_skip_qty
    mov  ebx, eax
    call GetBookQty
    inc  eax
    mov  ecx, eax
    call SetBookQty
rb_skip_qty:
    pop  ebx

    ; ask late days fine
    mov  edx, OFFSET s_lday
    call WriteString
    call ReadInt
    mov  tDAY, eax

    cmp  eax, 0
    jle  rb_no_fine

    ; calculate fine = late days * FINE_RATE
    mov  eax, tDAY
    mov  ecx, FINE_RATE
    mul  ecx
    add  totFine, eax

    mov  edx, OFFSET s_fine
    call WriteString
    mov  eax, tDAY
    mov  ecx, FINE_RATE
    mul  ecx
    call WriteDec
    mov  edx, OFFSET s_rs
    call WriteString

rb_no_fine:
    mov  edx, OFFSET s_ret_ok
    call WriteString

    ; print returned record details
    mov  edx, OFFSET s_sliphd
    call WriteString
    call PrintIssueRecord

    call PressEnterPrompt
    ret
ReturnBook ENDP

; ============================================================
; DeleteBook
; ============================================================
DeleteBook PROC
    call Clrscr
    mov  edx, OFFSET s_bid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString

    mov  edx, OFFSET tID
    call FindBookByID
    cmp  eax, 0FFFFFFFFh
    jne  db_fnd
    mov  edx, OFFSET s_nfnd
    call WriteString
    ret
db_fnd:
    mov  ebx, eax

    mov  edx, OFFSET s_conf
    call WriteString
    mov  edx, OFFSET yn_buf
    mov  ecx, 3
    call ReadString
    mov  al, yn_buf
    cmp  al, 'Y'
    je   db_yes
    cmp  al, 'y'
    je   db_yes
    mov  edx, OFFSET s_cncl
    call WriteString
    ret
db_yes:
    ; shift books after ebx left by 1
    mov  ecx, bkCnt
    dec  ecx
    sub  ecx, ebx
    jle  db_done_shift

db_shift:
    push ecx
    push ebx

    ; next slot = ebx+1
    mov  eax, ebx
    inc  eax

    ; copy ID from slot eax to ebx
    push eax
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET bkID
    mov  esi, eax
    pop  eax
    push eax
    mov  eax, ebx
    mov  ecx, BID_SZ
    mul  ecx
    add  eax, OFFSET bkID
    mov  edi, eax
    mov  ecx, BID_SZ
    call StrCopyN

    ; copy Name
    pop  eax
    push eax
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  esi, eax
    pop  eax
    push eax
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  edi, eax
    mov  ecx, BNM_SZ
    call StrCopyN

    ; copy Author
    pop  eax
    push eax
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  esi, eax
    pop  eax
    push eax
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  edi, eax
    mov  ecx, BAU_SZ
    call StrCopyN

    ; copy Qty: read from slot ebx+1
    pop  eax              ; eax = ebx+1 (original)
    push eax
    mov  ecx, 4
    mul  ecx
    add  eax, OFFSET bkQT
    mov  ecx, DWORD PTR [eax]   ; qty from next slot

    pop  eax
    ; store into slot ebx
    mov  eax, ebx
    mov  edx, 4
    mul  edx
    add  eax, OFFSET bkQT
    mov  DWORD PTR [eax], ecx

    pop  ebx
    inc  ebx
    pop  ecx
    dec  ecx
    cmp  ecx, 0
    jg   db_shift

db_done_shift:
    dec  bkCnt
    mov  edx, OFFSET s_deld
    call WriteString
    ret
DeleteBook ENDP

; ============================================================
; UpdateBook
; ============================================================
UpdateBook PROC
    call Clrscr
    mov  edx, OFFSET s_bid
    call WriteString
    mov  edx, OFFSET tID
    mov  ecx, BID_SZ - 1
    call ReadString

    mov  edx, OFFSET tID
    call FindBookByID
    cmp  eax, 0FFFFFFFFh
    jne  ub_fnd
    mov  edx, OFFSET s_nfnd
    call WriteString
    ret
ub_fnd:
    mov  ebx, eax

    ; show + get new name
    mov  edx, OFFSET s_bnm
    call WriteString
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  edx, eax
    call WriteString
    call Crlf
    mov  edx, OFFSET s_bnm
    call WriteString
    mov  edx, OFFSET tNM
    mov  ecx, BNM_SZ - 1
    call ReadString

    ; show + get new author
    mov  edx, OFFSET s_bau
    call WriteString
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  edx, eax
    call WriteString
    call Crlf
    mov  edx, OFFSET s_bau
    call WriteString
    mov  edx, OFFSET tAU
    mov  ecx, BAU_SZ - 1
    call ReadString

    ; new qty
    mov  edx, OFFSET s_bqt
    call WriteString
    call ReadInt
    mov  tQT, eax

    ; store name
    mov  eax, ebx
    mov  ecx, BNM_SZ
    mul  ecx
    add  eax, OFFSET bkNM
    mov  edi, eax
    mov  esi, OFFSET tNM
    mov  ecx, BNM_SZ
    call StrCopyN

    ; store author
    mov  eax, ebx
    mov  ecx, BAU_SZ
    mul  ecx
    add  eax, OFFSET bkAU
    mov  edi, eax
    mov  esi, OFFSET tAU
    mov  ecx, BAU_SZ
    call StrCopyN

    ; store qty if >= 0
    mov  eax, tQT
    cmp  eax, 0
    jl   ub_skip
    mov  ecx, eax
    call SetBookQty
ub_skip:
    mov  edx, OFFSET s_upd
    call WriteString
    ret
UpdateBook ENDP

; ============================================================
; ResetAll
; ============================================================
ResetAll PROC
    call Clrscr
    mov  edx, OFFSET s_wrn1
    call WriteString
    mov  edx, OFFSET s_wrn2
    call WriteString
    mov  edx, OFFSET yn_buf
    mov  ecx, 3
    call ReadString
    mov  al, yn_buf
    cmp  al, 'Y'
    je   ra_yes
    cmp  al, 'y'
    je   ra_yes
    mov  edx, OFFSET s_cncl
    call WriteString
    ret
ra_yes:
    mov  bkCnt, 0
    mov  isCnt, 0
    mov  stuCnt, 0
    mov  totFine, 0

    mov  edi, OFFSET bkID
    mov  ecx, MAX_BOOKS * BID_SZ
    call ZeroBuffer

    mov  edi, OFFSET bkNM
    mov  ecx, MAX_BOOKS * BNM_SZ
    call ZeroBuffer

    mov  edi, OFFSET bkAU
    mov  ecx, MAX_BOOKS * BAU_SZ
    call ZeroBuffer

    mov  edi, OFFSET bkQT
    mov  ecx, MAX_BOOKS * 4
    call ZeroBuffer

    mov  edi, OFFSET isACT
    mov  ecx, MAX_ISSUES
    call ZeroBuffer

    mov  edi, OFFSET isSTID
    mov  ecx, MAX_ISSUES * CRD_SZ
    call ZeroBuffer

    mov  edi, OFFSET isBAU
    mov  ecx, MAX_ISSUES * BAU_SZ
    call ZeroBuffer

    mov  edx, OFFSET s_rst_ok
    call WriteString
    ret
ResetAll ENDP

; ============================================================
; LibraryStats
; ============================================================
LibraryStats PROC
    call Clrscr
    mov  edx, OFFSET s_shdr
    call WriteString

    ; total books
    mov  edx, OFFSET s_stbk
    call WriteString
    mov  eax, bkCnt
    call WriteDec
    call Crlf

    ; count available vs oos
    mov  ebx, 0
    mov  ecx, 0            ; available count
    mov  edx, 0            ; oos count
ls_lp:
    cmp  ebx, bkCnt
    jae  ls_dn
    call GetBookQty
    cmp  eax, 0
    je   ls_oos
    inc  ecx
    jmp  ls_nx
ls_oos:
    inc  edx
ls_nx:
    inc  ebx
    jmp  ls_lp
ls_dn:
    push ecx
    push edx

    pop  edx
    push edx
    mov  edx, OFFSET s_siss
    call WriteString
    pop  eax
    call WriteDec
    call Crlf

    pop  eax
    push eax
    mov  edx, OFFSET s_savl
    call WriteString
    pop  eax
    call WriteDec
    call Crlf

    mov  edx, OFFSET s_sstu
    call WriteString
    mov  eax, stuCnt
    call WriteDec
    call Crlf

    mov  edx, OFFSET s_sfin
    call WriteString
    mov  eax, totFine
    call WriteDec
    call Crlf

    mov  edx, OFFSET s_scap
    call WriteString
    ret
LibraryStats ENDP

; ============================================================
; AIChatBot  - 3 AI Assistants: TALHA, AHSAN, HUZAIFA
; Keyword-based chatbot loop with intelligent routing
; ============================================================
AIChatBot PROC
    call Clrscr
    mov  edx, OFFSET s_cbhdr
    call WriteString

cb_loop:
    ; Print prompt
    mov  edx, OFFSET s_cbpmt
    call WriteString

    ; Read user input
    mov  edx, OFFSET cb_input
    mov  ecx, 59
    call ReadString

    ; --- Check EXIT first ---
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_exit
    call StrCmpEqual
    cmp  eax, 1
    je   cb_done

    ; --- Check HELLO / HI  (TALHA greets) ---
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_hello
    call StrContainsCI
    cmp  eax, 1
    je   cb_greet
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_hi
    call StrContainsCI
    cmp  eax, 1
    je   cb_greet
    jmp  cb_chk_help

cb_greet:
    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_cbgreet
    call WriteString
    jmp  cb_loop

    ; --- HELP  (TALHA) ---
cb_chk_help:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_help
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_search

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha6
    call WriteString
    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha8
    call WriteString
    jmp  cb_loop

    ; --- SEARCH  (TALHA) ---
cb_chk_search:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_search
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_author

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha1
    call WriteString
    jmp  cb_loop

    ; --- AUTHOR  (TALHA) ---
cb_chk_author:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_author
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_recommend

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha3
    call WriteString
    jmp  cb_loop

    ; --- RECOMMEND  (TALHA) ---
cb_chk_recommend:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_rec
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_issue

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha2
    call WriteString
    jmp  cb_loop

    ; --- ISSUE  (AHSAN) ---
cb_chk_issue:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_issue
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_return

    mov  edx, OFFSET s_ahsan
    call WriteString
    mov  edx, OFFSET s_ahsan1
    call WriteString
    jmp  cb_loop

    ; --- RETURN  (AHSAN) ---
cb_chk_return:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_return
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_fine

    mov  edx, OFFSET s_ahsan
    call WriteString
    mov  edx, OFFSET s_ahsan2
    call WriteString
    jmp  cb_loop

    ; --- FINE  (AHSAN) ---
cb_chk_fine:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_fine
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_stats

    mov  edx, OFFSET s_ahsan
    call WriteString
    mov  edx, OFFSET s_ahsan3
    call WriteString
    jmp  cb_loop

    ; --- STATS  (HUZAIFA) ---
cb_chk_stats:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_stats
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_add

    mov  edx, OFFSET s_huz
    call WriteString
    mov  edx, OFFSET s_huz1
    call WriteString
    mov  edx, OFFSET s_huz
    call WriteString
    mov  edx, OFFSET s_huz2
    call WriteString
    jmp  cb_loop

    ; --- ADD  (HUZAIFA) ---
cb_chk_add:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_add
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_delete

    mov  edx, OFFSET s_huz
    call WriteString
    mov  edx, OFFSET s_huz3
    call WriteString
    jmp  cb_loop

    ; --- DELETE  (TALHA) ---
cb_chk_delete:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_delete
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_update

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha4
    call WriteString
    jmp  cb_loop

    ; --- UPDATE  (TALHA) ---
cb_chk_update:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_update
    call StrContainsCI
    cmp  eax, 1
    jne  cb_chk_book

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha5
    call WriteString
    jmp  cb_loop

    ; --- BOOK generic  (TALHA tips) ---
cb_chk_book:
    mov  esi, OFFSET cb_input
    mov  edi, OFFSET cb_book
    call StrContainsCI
    cmp  eax, 1
    jne  cb_unknown

    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_talha7
    call WriteString
    jmp  cb_loop

    ; --- UNKNOWN input ---
cb_unknown:
    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_cbunk
    call WriteString
    jmp  cb_loop

cb_done:
    mov  edx, OFFSET s_talha
    call WriteString
    mov  edx, OFFSET s_cbgreet
    call WriteString
    call Crlf
    ret
AIChatBot ENDP

; ============================================================
; MAIN
; ============================================================
main PROC
    call DoLogin

mm_top:
    call Clrscr
    mov  edx, OFFSET s_menu
    call WriteString
    call ReadInt
    mov  gFlg, eax

    cmp  gFlg, 1
    jne  mm_c2
    call AddBook
    call PressEnterPrompt
    jmp  mm_top
mm_c2:
    cmp  gFlg, 2
    jne  mm_c3
    call ViewAllBooks
    call PressEnterPrompt
    jmp  mm_top
mm_c3:
    cmp  gFlg, 3
    jne  mm_c4
    call SearchBook
    call PressEnterPrompt
    jmp  mm_top
mm_c4:
    cmp  gFlg, 4
    jne  mm_c5
    call IssueBook
    jmp  mm_top
mm_c5:
    cmp  gFlg, 5
    jne  mm_c6
    call ReturnBook
    jmp  mm_top
mm_c6:
    cmp  gFlg, 6
    jne  mm_c7
    call DeleteBook
    call PressEnterPrompt
    jmp  mm_top
mm_c7:
    cmp  gFlg, 7
    jne  mm_c8
    call UpdateBook
    call PressEnterPrompt
    jmp  mm_top
mm_c8:
    cmp  gFlg, 8
    jne  mm_c9
    call ResetAll
    call PressEnterPrompt
    jmp  mm_top
mm_c9:
    cmp  gFlg, 9
    jne  mm_c10
    call LibraryStats
    call PressEnterPrompt
    jmp  mm_top
mm_c10:
    cmp  gFlg, 10
    jne  mm_c11
    call AIChatBot
    call PressEnterPrompt
    jmp  mm_top
mm_c11:
    cmp  gFlg, 11
    jne  mm_inv
    mov  edx, OFFSET s_bye
    call WriteString
    call WaitMsg
    invoke ExitProcess, 0
mm_inv:
    mov  edx, OFFSET s_inv
    call WriteString
    call PressEnterPrompt
    jmp  mm_top

main ENDP
END main