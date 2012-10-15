# SERMEPA FAKER ;D
Un script en NodeJS que simula ser un TPV de SERMEPA para pequeños cambios que se puedan necesitar una vez pasamos nuestra web a producción y no podemos usar el entorno de pruebas anymore.

Está creado principalmente **para aprender Node**, lo que viene a ser, cualquier mejora o demás que se le pueda hacer ya sabéis ;D

# Funcionamiento
Ejecutáis como cualquier otro script

    node server.js
    
Se puede usar la validación de la firma o no, hay unas variables que podéis configurar.

	VALIDATE = 
		do: true
		# Secret Key
		secret_key: 'qwertyasdf0123456789'
		terminal: '001'

Si tenéis `do: false` no creará ni comprobará las firmas, pero si lo activáis tenéis que poner los parámetros `secret_key` y `terminal` correctos, aunque no creo que os haga falta cambiarlos porque no estáis trabajando en producción… ¿verdad? ;)

Compilar el coffeescript con vuestra app favorita y a rular.

# NO WARRANTY
THE PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY. IT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW THE AUTHOR WILL BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
