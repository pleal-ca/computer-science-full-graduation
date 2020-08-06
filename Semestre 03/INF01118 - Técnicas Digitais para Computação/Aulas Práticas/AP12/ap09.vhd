ENTITY conversor8 IS
	PORT (	A		: IN BIT;
			B		: IN BIT;
			C		: IN BIT;
			D		: IN BIT;
			E		: IN BIT;
			F		: IN BIT;
			G		: IN BIT;
			H		: IN BIT;
			En		: IN BIT;
			C1		: OUT BIT;
			C0		: OUT BIT;
			D3		: OUT BIT;
			D2		: OUT BIT;
			D1		: OUT BIT;
			D0		: OUT BIT;
			U3		: OUT BIT;
			U2		: OUT BIT;
			U1		: OUT BIT;
			U0		: OUT BIT);
END conversor8;

ARCHITECTURE data_flow OF conversor8 IS
BEGIN
C1 <= (A AND B AND C) OR (A AND B AND D) OR (A AND B AND E);

C0 <= (NOT A AND B AND C AND D) OR (NOT A AND B AND C AND E) OR (NOT A AND B AND C AND F) OR (A AND NOT C AND NOT D AND NOT E) OR (A AND NOT B);

D3 <= (A AND NOT B AND C AND D AND E) OR (NOT A AND B AND C AND NOT D AND NOT E AND NOT F) OR (A AND NOT B AND C AND D AND F) OR (A AND B AND NOT C AND NOT D AND NOT E) OR (
    NOT A AND B AND NOT C AND D);

D2 <= (A AND NOT B AND D AND NOT E AND NOT F) OR (A AND NOT B AND NOT D AND E AND F) OR (NOT B AND C AND NOT D AND E) OR (NOT A AND B AND NOT C AND NOT D) OR (A AND B AND C
     AND D) OR (A AND NOT B AND NOT C AND D) OR (NOT A AND NOT B AND C AND D) OR (A AND NOT B AND C AND NOT D);

D1 <= (NOT A AND C AND D AND E AND F) OR (A AND B AND NOT C AND D AND E AND F) OR (NOT A AND NOT B AND NOT C AND D AND E) OR (NOT A AND B AND C AND D AND E) OR (NOT A
     AND NOT B AND NOT C AND D AND F) OR (A AND NOT B AND C AND NOT E AND NOT F) OR (NOT A AND B AND NOT C AND NOT D) OR (A AND NOT B AND NOT D AND NOT F) OR (A AND C AND NOT D) OR (
    A AND NOT B AND NOT D AND NOT E) OR (NOT B AND C AND NOT D AND NOT E);

D0 <= (A AND NOT C AND NOT D AND NOT E AND G) OR (A AND B AND NOT C AND NOT E AND G) OR (NOT A AND NOT C AND NOT D AND E AND G) OR (A AND C AND NOT D AND E AND G) OR (NOT A
     AND B AND NOT C AND E AND G) OR (A AND B AND C AND E AND G) OR (B AND NOT C AND NOT D AND NOT E AND F AND G) OR (A AND B AND NOT D AND NOT E AND F AND G) OR (A AND NOT C
     AND NOT E AND F AND G) OR (B AND C AND NOT D AND E AND F AND G) OR (NOT A AND NOT C AND E AND F AND G) OR (A AND C AND E AND F AND G) OR (NOT A AND C AND NOT E AND NOT F
     AND G) OR (NOT A AND C AND NOT D AND NOT E AND NOT F) OR (NOT A AND NOT B AND C AND NOT E AND F) OR (NOT A AND B AND C AND D AND NOT E) OR (NOT A AND NOT B AND NOT C AND D
     AND NOT E AND NOT F) OR (A AND NOT B AND C AND D AND NOT E AND NOT F) OR (NOT A AND NOT B AND C AND D AND E AND NOT F) OR (A AND B AND NOT C AND NOT D AND NOT E) OR (NOT A
     AND B AND NOT C AND NOT D AND E) OR (A AND B AND C AND NOT D AND E) OR (A AND NOT C AND NOT D AND NOT E AND F) OR (A AND B AND NOT C AND NOT E AND F) OR (NOT A AND NOT C
     AND NOT D AND E AND F) OR (A AND C AND NOT D AND E AND F) OR (NOT A AND B AND NOT C AND E AND F) OR (A AND B AND C AND E AND F) OR (A AND NOT B AND NOT C AND E AND NOT F) OR (
    A AND NOT C AND D AND E AND NOT F) OR (A AND NOT B AND NOT C AND D AND E);

U3 <= (NOT A AND B AND C AND NOT D AND NOT E AND NOT F AND G) OR (NOT A AND NOT B AND C AND NOT D AND NOT E AND F AND G) OR (NOT A AND B AND C AND D AND NOT E AND F AND G) OR (NOT A
     AND B AND NOT C AND NOT D AND NOT E AND F AND NOT G) OR (A AND B AND C AND NOT D AND NOT E AND F AND NOT G) OR (NOT A AND B AND C AND NOT D AND E AND F AND NOT G) OR (A AND B AND NOT C
     AND NOT D AND NOT E AND F AND G) OR (NOT A AND B AND NOT C AND NOT D AND E AND F AND G) OR (A AND B AND C AND NOT D AND E AND F AND G) OR (NOT A AND NOT B AND C AND D AND NOT E AND NOT F
     AND NOT G) OR (NOT A AND NOT B AND NOT C AND D AND NOT E AND NOT F AND G) OR (A AND NOT B AND C AND D AND NOT E AND NOT F AND G) OR (NOT A AND NOT B AND C AND D AND E AND NOT F AND G) OR (
    A AND NOT B AND NOT C AND NOT D AND NOT E AND NOT F AND NOT G) OR (A AND B AND NOT C AND D AND NOT E AND NOT F AND NOT G) OR (NOT A AND NOT B AND NOT C AND NOT D AND E AND NOT F AND NOT G) OR (
    A AND NOT B AND C AND NOT D AND E AND NOT F AND NOT G) OR (NOT A AND B AND NOT C AND D AND E AND NOT F AND NOT G) OR (A AND B AND C AND D AND E AND NOT F AND NOT G) OR (A AND NOT B
     AND NOT C AND D AND NOT E AND F AND NOT G) OR (NOT A AND NOT B AND NOT C AND D AND E AND F AND NOT G) OR (A AND NOT B AND C AND D AND E AND F AND NOT G) OR (A AND NOT B AND NOT C AND NOT D
     AND E AND NOT F AND G) OR (A AND B AND NOT C AND D AND E AND NOT F AND G) OR (A AND NOT B AND NOT C AND D AND E AND F AND G);

U2 <= (NOT A AND B AND NOT D AND E AND NOT F AND G) OR (B AND C AND NOT D AND E AND NOT F AND G) OR (NOT B AND NOT C AND D AND E AND NOT F AND G) OR (A AND NOT B AND D AND E AND NOT F
     AND G) OR (NOT A AND NOT B AND NOT D AND E AND F AND G) OR (NOT B AND C AND NOT D AND E AND F AND G) OR (NOT A AND B AND D AND E AND F AND G) OR (B AND C AND D AND E
     AND F AND G) OR (NOT B AND NOT C AND D AND NOT E AND NOT F AND NOT G) OR (A AND NOT B AND C AND D AND NOT F AND NOT G) OR (NOT A AND B AND NOT D AND NOT E AND NOT F AND NOT G) OR (
    NOT A AND NOT B AND NOT D AND NOT E AND F AND NOT G) OR (NOT A AND B AND D AND NOT E AND F AND NOT G) OR (NOT A AND NOT B AND D AND E AND NOT F AND NOT G) OR (A AND NOT B AND NOT C AND D
     AND NOT F AND G) OR (A AND B AND C AND NOT D AND NOT E AND NOT F) OR (A AND NOT B AND C AND NOT D AND NOT E AND F) OR (A AND B AND C AND D AND NOT E AND F) OR (B AND NOT C
     AND NOT D AND NOT E AND NOT F AND G) OR (NOT B AND NOT C AND NOT D AND NOT E AND F AND G) OR (B AND NOT C AND D AND NOT E AND F AND G) OR (NOT A AND B AND C AND NOT D AND E AND NOT F) OR (
    NOT A AND NOT B AND C AND NOT D AND E AND F) OR (NOT A AND B AND C AND D AND E AND F) OR (A AND NOT B AND NOT C AND NOT D AND E AND NOT F AND NOT G) OR (A AND B AND NOT C AND D AND E
     AND NOT F AND NOT G) OR (A AND NOT B AND NOT C AND D AND E AND F AND NOT G) OR (NOT A AND NOT B AND C AND NOT D AND NOT E AND NOT F AND G) OR (NOT A AND B AND C AND D AND NOT E AND NOT F
     AND G) OR (NOT A AND NOT B AND C AND D AND NOT E AND F AND G) OR (A AND B AND NOT C AND NOT D AND F AND NOT G) OR (B AND NOT C AND NOT D AND E AND F AND NOT G) OR (A AND B
     AND NOT D AND E AND F AND NOT G) OR (A AND B AND NOT C AND NOT D AND E AND F);

U1 <= (NOT A AND C AND NOT D AND NOT E AND NOT F AND NOT G) OR (NOT A AND NOT B AND C AND NOT E AND F AND NOT G) OR (NOT A AND B AND C AND D AND NOT E AND NOT G) OR (NOT A AND NOT C AND NOT D
     AND NOT E AND NOT F AND G) OR (A AND C AND NOT D AND NOT E AND NOT F AND G) OR (NOT A AND C AND NOT D AND E AND NOT F AND G) OR (NOT A AND NOT B AND NOT C AND NOT E AND F AND G) OR (
    A AND NOT B AND C AND NOT E AND F AND G) OR (NOT A AND NOT B AND C AND E AND F AND G) OR (NOT A AND B AND NOT C AND D AND NOT E AND G) OR (A AND B AND C AND D AND NOT E AND G) OR (
    NOT A AND B AND C AND D AND E AND G) OR (A AND NOT B AND NOT C AND E AND NOT F AND NOT G) OR (A AND NOT C AND D AND E AND NOT F AND NOT G) OR (A AND NOT B AND NOT C AND D AND E AND NOT G) OR (
    NOT A AND NOT B AND NOT C AND D AND NOT E AND NOT F AND NOT G) OR (A AND NOT B AND C AND D AND NOT E AND NOT F AND NOT G) OR (NOT A AND NOT B AND C AND D AND E AND NOT F AND NOT G) OR (
    A AND NOT B AND NOT C AND D AND NOT E AND NOT F AND G) OR (NOT A AND NOT B AND NOT C AND D AND E AND NOT F AND G) OR (A AND NOT B AND C AND D AND E AND NOT F AND G) OR (A AND B AND NOT C
     AND NOT D AND NOT E AND NOT G) OR (NOT A AND B AND NOT C AND NOT D AND E AND NOT G) OR (A AND B AND C AND NOT D AND E AND NOT G) OR (A AND NOT C AND NOT D AND NOT E AND F AND NOT G) OR (
    A AND B AND NOT C AND NOT E AND F AND NOT G) OR (NOT A AND NOT C AND NOT D AND E AND F AND NOT G) OR (A AND C AND NOT D AND E AND F AND NOT G) OR (NOT A AND B AND NOT C AND E AND F
     AND NOT G) OR (A AND B AND C AND E AND F AND NOT G) OR (A AND B AND NOT C AND NOT D AND E AND G) OR (A AND NOT C AND NOT D AND E AND F AND G) OR (A AND B AND NOT C AND E
     AND F AND G) OR (NOT A AND B AND C AND NOT D AND NOT E AND F AND G);

U0 <= H;

END data_flow;

