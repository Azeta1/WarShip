.data     // NOMBRES: Sebastian Lombardo // Pablo Contreras // Alexis Zamora  PARALELO-2
tablerovacio: .string " +---------+A|         |B|         |C|         |D|         |E|         |F|         |G|         |H|         |I|         | +---------+  123456789"
.align 0
.data     
barcos1: .string  "H2A1, H2B6, V2C3, H1D8, H1E5, H1F2, V3F7, H3H2, H1I6"
.align 0  // En "H2A1" para la primera cifra solo las letras H y V, para la segunda cifra solo numeros como 1 2 3, para la tercera cifra solo letras de la A a I y para la cuarta cifra solo numeros del 1 al 9. 
.data
barcos2: .string  "H1A3, H3B6, V3D1, V2D4, H1D8, H2F5, V2G9, H1H3, V1I1"
.align 0
.data
jugadas: .string "A1, B8, C7, H9, A3, A1, I2, E4, C3, D3, G7, I6"  // PRIMERA JUGADA VA AL TABLERO2, SEGUNDA AL TABLERO1
.align 0
.text                    //
.global _start
_start:
//Resumen de como funciona el codigo:
// Observando barcos1 o barcos2 en "H2A1" la "H" corresponde a que es un barco horizontal.... 
//si no se ingresa una H o V en la primera letra, el codigo salta a la funcion ERROR: y arroja ERROR BARC arriba del tablero 1 que esta en la direccion 0x00002000 y se detiene.
// ademas se escribe ERRO en r0 de manera hexadecimal como se pide en los enunciados de la tarea.
//Para "H2A1" el tamaño del barco es representado en la segunda cifra "2" de tamaño 2..
//si no se ingresan valores como "1 2 o 3", el codigo arroja ERROR BARC al igual como se menciona anteriormente y se detiene.
//la "A" corresponde a la fila donde se posicionara el barco y en donde se permite el ingreso de letras desde el A al I sino salta a la funcion ERROR
//el "1" corresponde a la columna donde se posicionara el barco y en donde se permite el ingreso de numeros desde el 1 al 9 sino salta a la funcion ERROR
// Al ingresar "H2A1" se inserta un barco horizontal de tamaño dos que se dibujara de izquierda a derecha partiendo desde A1 hasta A2.
// si se ingresa un barco que sobrepasa los limites del tablero, el codigo salta a la funcion ERROR.
// Por la regla de batalla naval el juego se inicia solamente si hay 9 barcos en total para cada tablero
// y con las siguientes caracteristicas: "2 barcos de 3 casillas, 3 barcos de 2 casillas y 4 barcos de 1 casilla."
//si no se cumple esto, el codigo se va a la funcion ERROR.

//Al observar el string de jugadas, la primera jugada "A1" va hacia el tablero 2 en donde se inserta una "X" en esa posicion.
//la segunda jugada "B8" va hacia el tablero 1 en donde se inserta una X en esa posicion.
//Para las jugadas, solo se permiten letras desde A a I y numeros del 1 al 9, sino salta a la funcion ERRORJ correspondiente al error de jugadas.
//El jugador puede ingresar la cantidad de jugadas que quiera mientras este en los limites del tablero, sino arroja error.

//Abajo de los tableros se puede ver un cementerio de los barcos para cada tablero, para ver las letras de los barcos destruidos y si se repiten.

//Si gana el jugador 1, se muestra en r0 "JUG1" en hexadecimal y arriba del tablero "GANA JUG1"
//Si gana el jugador 2, se muestra en r0 "JUG2" en hexadecimal y arriba del tablero "GANA JUG2"
//Si hay un empate, se muestra en r0 "EMPA" en hexadecimal y arriba del tablero "EMPA TE"

bl dibujartablerovacio //funcion para dibujar el tablero 1 y tablero 2 al mismo tiempo
mov r4,#1
mov r5,#1
ldr r3,=barcos1         //se carga la direccion en donde esta barcos1 en r3
ldr r2,=barcos2         // se carga la direccion en donde esta barcos2 en r2
bl contbarcos1y2        //funcion para contar la cantidad de barcos totales para tablero 1 y tablero 2
mov r8,#0
mov r5,#0
mov r4,#0
bl canttiposdebarcos   //funcion para contar la cantidad de tipos de barcos ingresados:"2 barcos de 3 casillas, 3 barcos de 2 casillas y 4 barcos de 1 casilla."
ldr r12,=0x61  
	dbarcos:  // funcion para extraer la palabra correspodiente a cada barco ej "H2A1"
	ldr r3,=barcos1 //se carga la direccion en donde esta barcos1 en r3
	ldr r2,=barcos2 // se carga la direccion en donde esta barcos2 en r2
	mov r1,#0
	mov r0,#0
	mov r6,#0
	mov r8,#0
	mov r11,#0
	  fory:         //for para extraer cada byte 
	  ldrb r5,[r3,r9]
	  ldrb r4,[r2,r9]
	  lsl r5,r8
	  lsl r4,r8
	  add r0,r5
	  add r1,r4
      add r9,#1
	  add r8,#8
	  add r11,#1
	  cmp r11,#4
	  bne fory
	add r9,#2
	mov r8,#0
	mov r11,#0
	mov r4,#0
	mov r5,#0
	bl dibujarbarcos // una vez extraida la palabra de barcos1 guardada en r0 o barcos2 guardada en r1 ej "H2A1" y "H1A3" salta a una funcion para traspasarlo al tablero
    cmp r9,#54      // cuando se llegue al total de jugadas sale de la funcion dbarcos y sigue el codigo.
	bne dbarcos
	mov r1,#0
	mov r3,#0
	mov r4,#0
	mov r5,#0
	mov r9,#0	
	mov r10,#0	        
	mov r11,#0
	mov r8,#0
	ldr r3,=jugadas         //se carga la direccion en donde estan las jugadas en r3
contarjugadas:   //funcion para contar la cantidad de jugadas totales
  ldrb r2,[r3],#1   // funcion para extraer del string jugadas en r2, se guarda en r2 lo de r3=jugadas de un solo valor, usando Post-index
  cmp r2,#0x2C	//se compara r2 con el valor de "," en ASCII, si es igual se levanta stack
  addeq r8,#1	//si se levanta stack en la linea anterior se le suma 1 al r8, con el fin de contar el numero de jugadas
  cmp r2,#0x00	//comparador si r2 es igual a 0, se levanta stack
  bne contarjugadas	//si en la linea anterior se lavanto stack no se devuelve a la etiqueta "jugadasbarcos1"
  mov r0,#2 //se escribe en r0 el valor 2
  mul r8,r0 //multiplicacion entre r8 y r0 para saber cuantos caracteres hay en una jugada
  mov r9,#0 //se limpia r9
  mov r10,#0 //se limpia r10
  add r8,#2 //se le suma a r8+4, para compensar la ultima jugada no contada por las comas
  mov r11,#0
  mov r2,#0
  mov r12,#0
	jugadasd://funcion para realizar los disparos "X" en las posiciones ingresadas en las jugadas
	ldr r3,=jugadas
	ldr r0,=0x00000000
	ldrb r1,[r3,r9]
	add r0,r1
    add r9,#1
	add r10,#1
	ldrb r1,[r3,r9]
	add r9,#3
	add r10,#1
	lsl r1,#8
	add r11,#1
	add r0,r1
	and r11,#1
	cmp r11,#1  // si la jugada es impar dispara al tablero 2 "jugadas 1 3 5 7 9 11 13 15....etc"
	bleq disparotablero2 // funcion para disparar al tablero 2
	cmp r11,#0  // si la jugada es par es "par" dispara al tablero 1  "jugadas 2 4 6 8 10 12 14 16 .....etc"
    bleq disparotablero1 // funcion para disparar al tablero 1
	cmp r10,r8  
	bne jugadasd  // Si r10 = r8, se llego al total de jugadas ingresadas y se sale de la funcion jugadasd
	ldr r0, =0x61 // letra "a"	
	mov r3, #0 // contador de barcos hundidos tablero 1
	mov r12, #0//contador de barcos hundidos tablero 2
	bl cementerio//se dirije a la funcion cementerio
    GANADOR:
	cmp r3, r12 // compara la cantidad de barcos hundidos de JUG1 (r3) con JUG2 (r12)
	bhi JUG2
	cmp r3, r12
	blt JUG1
	cmp r3, r12
	beq EMPATE
    bl FINJUEGO // en ascii
FINJUEGO:
1:b 1b

dibujartablerovacio:   //funcion para dibujar el tableros
  ldr r1,=0x2014        //direccion donde colocar JUG1
  ldr r12,=0x2104        //direccion donde colocar JUG2
  ldr r3,=0x3147554A    //JUG1 en hexadecimal
  ldr r5,=0x3247554A    //JUG2 en hexadecimal
  str r3,[r1]           //guardar r3=JUG1 en la direccion 0x2014
  str r5,[r12]           //guardar r5=JUG2 en la direccion 0x2104
  ldr r1,=0x21f0        //direccion donde colocar el cementerio del tablero1
  ldr r12,=0x2270        //direccion donde colocar el cementerio del tablero2
  ldr r3,=0x31424154    //TAB1 en hexadecimal
  ldr r5,=0x32424154    //TAB2 en hexadecimal
  str r3,[r1]           //guardar r3=JUG1 en la direccion 0x2014
  str r5,[r12]           //guardar r5=JUG2 en la direccion 0x2104
  ldr r0,=tablerovacio	//leer lo del string tablerovacio	
  ldr r1,=0x2020        //direccion del tablero1
  mov r3,#0             //i=0 contador del ciclo for
  ldr r6,=tablerovacio	//leer lo del string tablerovacio	 
  ldr r12,=0x2110        //direccion del tablero 2
  ldr r7,=0x10
   forx:
	for:               
    ldrb r2,[r0],#1  //guardar de un valor a la vez de r0=tablerovacio, y guardarlo en r2, con un Post-index
    ldrb r5,[r6],#1  //guardar de un valo a la vez de r6=tablerovacio, y guardarlo en r5, con un Post-index
    strb r2,[r1,r3]  //guardar en memoria lo de r2 en la direccion r1 con desface de r3
    strb r5,[r12,r3]  //guardar en memoria lo de r5 en la direccion r4 con desface de r3
    add r3,#1
    cmp r3,#12
    bne for 
 mov r3,#0
 add r1,r7
 add r12,r7
 cmp r5,#0
 bne forx
 mov r6,#0
 mov r7,#0
mov pc, lr   // TERMINA LA FUNCION DE DIBUJAR Y SE DEVUELVE

contbarcos1y2: 
  cmp r4,#0x00   // si lo que se extrajo anteriormente en r2 es 00, no extrae otro valo ya que llego al limite para no seguir contando.
  ldrneb r4,[r3],#1   // funcion para guardar lo del string barcos1 en r2, se guarda en r2 lo de r3=barcos1 de un solo valor, usando Post-index
  cmp r5,#0x00   // si lo que se extrajo anteriormente en r5 es 00, no extrae otro valo ya que llego al limite para no seguir contando.
  ldrneb r5,[r2],#1  // funcion para guardar lo del string barcos2 en r5, se guarda en r2 lo de r3=barcos1 de un solo valor, usando Post-index
  cmp r4,#0x2C	 //se compara r2 con el valor de "," en ASCII, si es igual se levanta stack
  addeq r7,#1	 //si se levanta stack en la linea anterior se le suma 1 al r7, con el fin de contar el numero de jugadas
  cmp r5,#0x2C   //se compara r5 con el valor de "," en ASCII, si es igual se levanta stack
  addeq r8,#1    //si se levanta stack en la linea anterior se le suma 1 al r8, con el fin de contar el numero de jugadas
  cmp r5,#0x00   //comparador si r5 es igual a 0, se levanta stack
  bne contbarcos1y2 //si en la linea anterior se lavanto stack no se devuelve a la etiqueta "jugadasbarcos1"
  cmp r4,#0x00	 //comparador si r2 es igual a 0, se levanta stack
  bne contbarcos1y2	//si en la linea anterior se lavanto stack no se devuelve a la etiqueta "jugadasbarcos1"
  add r8,r7      // se suma la cantidad de barcos ingresados en string barcos1 y 2 y se guarda en r8
  add r8,#2      // como se cuentan solo las comas, siempre se cuenta una jugada menos entonces se le agrega las faltantes
  lsl r8,#2     // se multiplica la cant de jugadas totales para determinar la cantidad de caracteres totales
  cmp r8,#72      // si hay 9 barcos, se multiplica por 4 y queda 36 decimal que en hexa es 24, como se sumaron los barcos queda 48 en hexa,si en r8 no hay 48 en hexa es porque ingresaron un barco menos o un barco de mas.
  blne ERROR     // si r8 y r1 no son iguales, salta a funcion ERROR mostrando arriba de los tableros "ERRO BARC" deteniendose el juego.
  mov r2,#0      // si los jugadores ingresaron los 9 barcos como regla del juego, el codigo continua, sino no.
  mov r4,#1
  mov r5,#1
  mov r7,#0
  mov r9,#0  //se limpia r9
  mov r10,#0 //se limpia r10
  mov r11,#0
  mov r8,#0
  mov pc,lr

canttiposdebarcos:
	mov r0,#0
	mov r1,#0
	mov r3,#0
	mov r4,#0
	mov r5,#0
	ldr r11,=barcos1 //
	ldr r12,=barcos2
	mov r10,#1
	  forv:
	  ldrb r8,[r11,r10] // se extrae el tamaño desde barcos1
	   cmp r8,#49 // si r4<0x31 arroja error
       blt ERROR
       cmp r8,#51 // si r4>0x33 arroja error
       bhi ERROR
	  and r8,#15
	  ldrb r9,[r12,r10] // se extrae el tamaño desde barcos2
	  cmp r9,#49 // si r4<0x31 arroja error
       blt ERROR
       cmp r9,#51 // si r4>0x33 arroja error
       bhi ERROR
	  and r9,#15
	 cmp r8,#1 // si lo que se extraño de r8 es 1
	  addeq r1,#1   // se guarda en r1 un barco de tamaño 1
	  cmp r8,#2 // si lo que se extraño de r8 es 2
	  addeq r2,#1 // se guarda en r2 un barco de tamaño 2
	  cmp r8,#3  // si lo que se extraño de r8 es 3
	  addeq r3,#1 // se guarda en r3 un barco de tamaño 3
	  cmp r9,#1 // si lo que se extraño de r9 es 1
	  addeq r4,#1   // se guarda en r4 un barco de tamaño 1
	  cmp r9,#2  // si lo que se extraño de r9 es 2
	  addeq r5,#1 // se guarda en r5 un barco de tamaño 2
	  cmp r9,#3  // si lo que se extraño de r9 es 3
	  addeq r6,#1 // se guarda en r6 un barco de tamaño 3
	  add r10,#6
	  add r0,#1
	  cmp r0,#9
	  bne forv    
	  cmp r1,#4   //Tablero1: se pide que 4 barcos de 1 casilla
	  bne ERROR   // si no se cumple esto arroja error
	  cmp r2,#3   // se pide que 3 barcos de 2 casillas
	  bne ERROR   // si no se cumple esto arroja error
	  cmp r3,#2   // se pide que 2 barcos de 3 casillas
	  bne ERROR   // si no se cumple esto arroja error
	  cmp r4,#4   //Tablero2: se pide que 4 barcos de 1 casilla
	  bne ERROR   // si no se cumple esto arroja error
	  cmp r5,#3   // se pide que 3 barcos de 2 casillas
	  bne ERROR   // si no se cumple esto arroja error
	  cmp r6,#2   // se pide que 2 barcos de 3 casillas
	  bne ERROR   // si no se cumple esto arroja error
	  mov r4,#0
	  mov r5,#0
	  mov r6,#0
	  mov r7,#0
	  mov r8,#0
	  mov r9,#0
	  mov r10,#0
	  mov r11,#0
	  mov pc,lr

dibujarbarcos:  //        r8 cont de barcos   // r9 contador para desplazarse en las jugadas 
  lsr r2,r0,#16 //
  lsr r3,r1,#16 // 
  and r4,r2,#255 // ej: extrae de "H2A1" la letra "A" y la guarda en r4        // 0xff  #255   
  and r5,r3,#255 // ej: extrae de "H1A3" la letra "A" y la guarda en r5        // 0xff  #255  
  cmp r4,#65 // 0x41  #65
  blt ERROR  // si r4<0x41 salta a error, si r4 < "A"
  cmp r4,#73 // 0x49   #73
  bhi ERROR  // si r4>0x49 salta a error, si r4 < "I"
  cmp r5,#65
  blt ERROR   // si r5<0x41 salta a error, si r5 < "A"
  cmp r5,#73
  bhi ERROR   // si r5>0x49 salta a error, si r5 < "I"
  and r4,r2,#15 //ej: si es "A" extrae del 0x41 el 1 y guarda en r4 // 0xf  #15
  and r5,r3,#15 //ej: si es "A" extrae del 0x41 el 1 y guarda en r5 // 0xf  #15
  ldr r2,=0x00002020 // direccion correspondiente al tablero 1
  mov r6,#0
  address1:          //funcion para extraer la direccion o fila correspondiente al "H2A1"
  add r2,#16
  add r6,#1
  cmp r4,r6
  bne address1  
  ldr r3,=0x00002110 // direccion correspondiente al tablero 2
  mov r6,#0 
  address2:        //funcion para extraer la direccion o fila correspondiente al "H1A3"
  add r3,#16
  add r6,#1
  cmp r5,r6
  bne address2 
  lsr r4,r0,#24
  lsr r5,r1,#24
  and r4,r4,#255  // ej: extrae de "H2A1" el "1" y la guarda en r4        // 0xff  #255
  and r5,r5,#255  // ej: extrae de "H1A3" el "3" y la guarda en r5        // 0xff  #255
  cmp r4,#49 // si r4<0x31 salta a funcion error 
  blt ERROR
  cmp r4,#57 // si r4>0x39 salta a funcion error
  bhi ERROR
  cmp r5,#49  // si r5<0x31 salta a funcion error 
  blt ERROR
  cmp r5,#57  // si r5>0x39 salta a funcion error
  bhi ERROR
  and r4,r4,#15 //ej: si es "1" extrae del 0x41 el 1 y guarda en r4 // 0xf  #15
  and r5,r5,#15 //ej: si es "3" extrae del 0x43 el 3 y guarda en r5 // 0xf  #15
  add r4,#1     // se le suma uno ya que en la memoria parte de 0123... 4567...
  add r5,#1     // se le suma uno ya que en la memoria parte de 0123... 4567...
  lsr r6,r0,#8
  lsr r7,r1,#8
  and r6,#15 // ej: extrae de "H2A1" el tamaño "2" y la guarda en r6        // 0xf  #15
  and r7,#15 // ej: extrae de "H1A3" el tamaño "1" y la guarda en r7       // 0xf  #15
  mov r8,#0   
  and r0,#255// ej: extrae de "H2A1" la orientacion "H" y la guarda en r0        // 0xff  #255
  and r1,#255// ej: extrae de "H1A3" la orientacion "H" y la guarda en r0        // 0xff  #255
  cmp r0,#72 // Si r0 = "H"
  addeq r8,#1 // se suma +1 a r8
  cmp r0,#86 //si r0 = "V"
  addeq r8,#1 // se suma +1 a r8
  cmp r1,#72 // si r1 = "H" 
  addeq r8,#1 // se suma +1 a r8
  cmp r1,#86  // si r1 = "V"
  addeq r8,#1 //se suma +1 a r8
  cmp r8,#2
  beq loop1
  bne ERROR  // si  "H2A1" y "H1A3" tienen cualquier letra que no sea H o V salta a la funcion error
	loop1: //pensando que tenemos "H2A1" y "H1A3"
	cmp r6,#0         // comparacion para ver si  ya se termino de dibujar el barco dependiendo del tamaño
	ldrneb r8,[r2,r4] // extrae de la posicion A1 del tablero 1 lo que hay en ese lugar, si r6 es 0 significa que ya se termino de dibujar el barco, por lo tanto no se sigue extrayendo
	cmp r8,#32
	bne ERROR         // salta a la funcion error, ya que hay un barco en ese lugar.
	cmp r7,#0         
	ldrneb r8,[r3,r5] //Si r7 es 0 significa que ya se termino de dibujar el barco, por lo tanto no se sigue extrayendo
	cmp r8,#32        // si r7 no es 0 se extrae un valor y se compara con r8, si es un espacio en blanco el codigo continua sino arroja error
	bne ERROR
	cmp r6,#0         // si r6 no es igual a 0
	strneb r12,[r2,r4]// se dibuja en el tablero 1 lo correspondiente a "H2A1"
	cmp r7,#0         // si r7 no es igual a 0
	strneb r12,[r3,r5] // se dibuja en el tablero 1 lo correspondiente a "H1A3"
	cmp r0,#86      // si r0 es "V"
	addeq r4,#16    //al valor de r4 correspondiente a la columna, se desplaza 16 bytes quedando abajo
	addne r4,#1     // si r0 no es "V", entonces es "H" y se desplaza 1 byte a la derecha
	cmp r1,#86      // si r1 es "V"
	addeq r5,#16    //al valor de r5 correspondiente a la columna, se desplaza 16 bytes quedando abajo
	addne r5,#1     // si r0 no es "V", entonces es "H" y se desplaza 1 byte a la derecha
	cmp r6,#0       // si r6 correspondiente al tamaño  de "H2A1"es 0 
	subne r6,#1     // no se le resta 1
	cmp r7,#0      // si r7 correspondiente al tamaño de "H1A3" es 0
	subne r7,#1    // no se le resta 1
	add r11,r6,r7  // una vez que los dos sean 0 se termina de dibujar los barcos dependiendo del tamaño
	mov r8,#32
	cmp r11,#0 
	bne loop1
	mov r4,#0
	mov r5,#0
	mov r8,#0
	mov r10,#0
    add r12,#1
    mov pc,lr
 
disparotablero2:    //3141    A1
  mov r7,r0
  and r1,r7,#255     // guardo la letra "A B D C D..." en donde va el disparo  //0xff  #255
  cmp r1,#65         // se fija limite inferior posible y se compara r1 con r3 // 0x41  #65
  blt ERRORJ         // r1<r3, si es asi salta a error   40>41 @<41
  cmp r1,#73         //  se fija limite superior posible y compara r1 con r3
  bhi ERRORJ         // r1>r3, si es asi salta a error   4B>49  k>I
  and r1,r7,#15      // se obtiene numero del 1 al 9 para comparar // 0xf  #15
 ldr r7,=0x00002110
 mov r3,#0
 address3:
 add r7,#16
 add r3,#1
  cmp r1,r3
  bne address3
  lsr r4,r0,#8    //extraigo el 1 correspondiente a ej "A1"
  and r4,r4,#255  // 0xff  #255
  cmp r4,#49 // si r4<0x31 arroja error
  blt ERRORJ
  cmp r4,#57 // si r4>0x39 arroja error
  bhi ERRORJ
  and r4,r4,#15    // 0xf  #15
  add r4,r4,#1
  mov r0,r12
  add r0,#1
  ldr r3,=0x58   // SIMBOLO X
  ldr r1,=0x00002280
  ldrb r6,[r7,r4] // extraer un valor en la posicion ejemplo de "A1"
  cmp r6,r3
  moveq r6,#32
  cmp r6,#32
  strneb r6,[r1,r12]   //si no es 0x20, guarda la una letra del barco en la direccion 2200 // 0x20  #32
  cmp r6,#32
  subeq r12,#1
  mov r6,#0
  strb r6,[r1,r0]
  strb r3,[r7,r4]
  mov r4,#0
  add r12,#1
  mov r5,#0
  mov r6,#0
  mov r7,#0
  mov pc,lr
	
disparotablero1:
   mov r7,r0
  and r1,r7,#255     // guardo la letra "A B D C D..." en donde va el disparo  //0xff  #255
  cmp r1,#65         // se fija limite inferior posible y se compara r1 con r3 // 0x41  #65
  blt ERRORJ         // r1<r3, si es asi salta a error   40>41 @<41
  cmp r1,#73         //  se fija limite superior posible y compara r1 con r3
  bhi ERRORJ         // r1>r3, si es asi salta a error   4B>49  k>I
  and r1,r7,#15      // se obtiene numero del 1 al 9 para comparar // 0xf  #15
 ldr r7,=0x00002020
 mov r3,#0
  address4:
  add r7,#16
  add r3,#1
  cmp r1,r3
  bne address4
  lsr r4,r0,#8    //extraigo el 1 correspondiente a ej "A1"
  and r4,r4,#255  // 0xff  #255
  cmp r4,#49 // si r4<0x31 arroja error
  blt ERRORJ
  cmp r4,#57 // si r4>0x39 arroja error
  bhi ERRORJ
  and r4,r4,#15  // 0xf  #15
  add r4,r4,#1
  mov r0,r2
  add r0,#1
  ldr r3,=0x58   // SIMBOLO X
  ldr r1,=0x00002200
  ldrb r6,[r7,r4] // extraer un valor en la posicion ejemplo de "A1"
  cmp r6,r3
  moveq r6,#32
  cmp r6,#32
  strneb r6,[r1,r2]   //si no es 0x20, guarda la una letra del barco en la direccion 2200
  cmp r6,#32
  subeq r2,#1
  mov r6,#0
  strb r6,[r1,r0]
  strb r3,[r7,r4]
  mov r4,#0
  mov r5,#0
  add r2,#1
  mov r6,#0
  mov r7,#0
  mov pc,lr

  cementerio: //funcion cementerio
  ldr r4, =0x6A // letra (j) para terminar el bucle
  mov r5, #0// contador
  encontre1://funcion para encontrar hundidos tablero 1
  ldr r1, =0x2200 // empieza cementerio 1
  ldrb r2, [r1, r5] // trae a r2 lo que esta en r1 con offset de r5
  cmp r2, #0 // si no encuentra igual se sale del bucle con un 0 de referencia al final de los datos de la direccio r1
  add r5, #1 // se suma 1 al contador r5
  beq chao1//si no se encuetra iguales en el bucle se salta a chao1 para la siguiente letra a comparar
  cmp r2, r0 // si r2 es igual a r0 se encontro barco hundido
  bne encontre1// si r2 y r0 no son iguales se devuelve a encontre1
  add r3, #1 // contador de barcos hundidos +1
  chao1:
  mov r5, #0//se resetea r5 para encontrar barcos hundidos en el tablero 2
  encontre2:
  ldr r6, =0x2250//empieza cementerio 2
  ldrb r7, [r6, r5]//trae a r7 lo que esta en r6 con offset de r5
  cmp r7, #0//si no encuentra igual se sale del bucle con un 0 de referencia al final de los datos de la direccion r6
  add r5, #1//se suma 1 al contador r5
  beq chao2//si no se encuentra iguales en el bucle se salta a chao2 para la siguiente letra a comparar
  cmp r7, r0//si r7 es igual a r0 se encontro barco hundido
  bne encontre2//si r7 y r0 no son iguales se devuelve a encontre2
  add r12, #1//contador de barcos hundidos +1
  chao2:
  add r0, #1 // ahora es la siguiente letra
  cmp r0, r4 // si r0 es igual a r4(j) termina la busqueda
  bne cementerio // si r0 no es igual a r4 se devuelve a cementerio
  mov r4,#0
  mov r5,#0
  mov r6,#0
  mov pc, lr
  
  JUG1:  // GANA = 0x414E4147     JUG1 = 0x3147554A
  ldr r4, =0x1FE0
  ldr r1, =0x414E4147 // GANA
  ldr r2, =0x1FE4
  ldr r0, =0x3147554A // JUG1
  str r1, [r4]
  str r0, [r2]
  b FINJUEGO
    
  JUG2:  // GANA = 0x414E4147     JUG2 = 0x3247554A
  ldr r4, =0x1FE0
  ldr r1, =0x414E4147 // GANA
  ldr r2, =0x1FE4
  ldr r0, =0x3247554A // JUG2
  str r1, [r4]
  str r0, [r2]
  b FINJUEGO
   
  EMPATE:  // EMPATE = 0x45544150 00004D45 
  ldr r4, =0x1FE0     //direccion donde escribir "EMPA"     
  ldr r0, =0x41504D45 // mensaje "EMPA"
  ldr r2, =0x1FE4     //direccion donde escribir "TE"     
  ldr r1, =0x00004554 // mensaje "TE"
  str r0, [r4]        //muestro "EMPA" en la esquina sup de mi area de juego
  str r1, [r2]        //muestro "TE" en la esquina sup de mi area de juego
  b FINJUEGO

ERROR:
ldr r0,=0x4f525245  // mensaje "ERRO"
ldr r2,=0x1FE0      //direccion donde escribir "ERRO"     
ldr r1,=0x43524142  //mensaje "BARC"
ldr r3,=0x1FE4      // direccion donde escribir "BARC"
str r0,[r2]  //muestro "ERRO" en la esquina sup de mi area de juego
str r1,[r3]  //muestro "BARC" en la esquina sup de mi area de juego
b FINJUEGO

ERRORJ:
ldr r0,=0x4f525245  //mensaje "ERRO"
ldr r2,=0x1FE0      //direccion donde escribir "ERRO"
ldr r1,=0x5347554A  //mensaje "JUGS"
ldr r3,=0x1FE4      // direccion donde escribir "JUGS"
str r0,[r2]  //muestro "ERRO" en la esquina sup de mi area de juego
str r1,[r3]  //muestro "JUGS" en la esquina sup de mi area de juego
b FINJUEGO