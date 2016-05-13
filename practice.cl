;; ----------------------------------------------------
;; Luis Manuel Román García
;; 000117077
;;
;;
;; ooooo     o        ooooooo   ooooo   ooooo
;; 8    8    8           8     8     o  8    8
;; 8         8           8     8        8    8
;; 8         8           8      ooooo   8oooo
;; 8    o    8           8     o     8  8
;; ooooo     8oooooo  ooo8ooo   ooooo   8
;;
;; ----------------------------------------------------

;; ----------------------------------------------------
;; MOTIVACIÓN
;; ¿Para que aprender LISP?
;; ----------------------------------------------------

;; LISP
(defun sum (n)
  (let ((s 0))
    (dotimes (i n s)
      (incf s i))))
(sum 5)

;; C
;; Ejercicio al lector...

;; Cosas tan sencillas en realidad no importa en que
;; lenguaje las hagas.

;; Función que regrese una función
;; que le sume n a su argumento?

;; LISP
(defun addn (n)
  #' (lambda (x)
       (+ x n)))

;; C
;; IMPOSIBLE

;; ----------------------------------------------------
;; Breve Introducción
;; ----------------------------------------------------

;;;;;;;;;;;;;;;; Evaluación
;; Notación prefija, primer argumento de la lista espera
;; una función, o una primitiva, la evaluación es de
;; izquierda a derecha.
()
(+)
(+ 1 2)
(+ 1 2 3 4 5 7 8)
(+ (/ 6 3) (* 3 3))
'(+ 3 3)
(expt 432 233)
4/6
;;;;;;;;;;;;;;;; Datos
;; Enteros
2
33243
;; Cadenas de caracteres
"Hola"
;; Símbolos (notar que son evaluados a mayúsculas)
'symbol1
'symbol2
;; Listas
'(la lista (a b c) tiene 3 elementos)
(list '"2 + 2 =" (+ 2 2))
;; Notar la importancia de esto!!! Los programas en
;; LISP son expresados cómo estructuras de datos LISTAS
(second (list '(+ 2 1) (+ 2 1)))
;;;Operaciones con listas
(cons 'a (cons 'b nil))
(list 'a 'b)
(car '(a b c))
(cdr '(a b c))
(car (cdr (cdr '(a b c d))))

;;;;;;;;;;;;;;;; Funciones
;; Extrae el tercer elemento
(defun tercero (x)
  (car (cdr (cdr x))))
(tercero '(1 2 3 4))
;; Función sin nombre
;; ¿Qué es lo que hace?
(defun anonym (obj lst)
  (if (null lst)
      nil
      (if (eql (car lst) obj)
          lst
          (anonym obj (cdr lst)))))

(anonym 3 '(1 2 3 4))
;; I/O
(defun edad (string)
  (format t "hola ~A" string)
  (read))
(edad "Cuantos años tienes?")
;; Notar que esta función tiene más de una
;; expresión. Además de esto contiene efectos
;; secundarios, no sólo lleva a cabo la transformación
;; de una entrada en una salida.
;; Para definir funciones locales: flet
(flet ((f (n)
         (+ n 10)))
  (f 5))
;; más de una declaración
(flet ((f (n)
         (+ n 10))
       (g (n)
         (- n 3)))
  (g (f 5)))

;; Funciones cómo objetos
(function +)
#' +
;; podemos pasar funciones a funciones que reciben
;; funciones, por ejemplo: apply
(apply #' + '(1 2 3 4))

;;;;;;;;;;;;;;;; Variables
;; Operador let para asignación
(let ((x 1) (y 2))
  (+ x y))

;; I/O
(defun pregunta-numero ()
  (format t "Ingrese un número par: ")
  (let ((val (read)))
    (if (oddp val)
        val
        (pregunta-numero))))
(pregunta-numero)
;; Notar que todas estas variables son locales
;; Variables globales
(defparameter *global* "hola")
*global*

;; Un pequeño juego, adivina mi numero
(defparameter *grande* 100)
(defparameter *pequeño* 1)
;; adivina número
(defun adivina-mi-numero ()
  (ash (+ *pequeño* *grande*) -1))
;; pequeño
(defun peque ()
  (setf *grande* (1- (adivina-mi-numero)))
  (adivina-mi-numero))
;; grande
(defun grand ()
  (setf *pequeño* (1+ (adivina-mi-numero)))
  (adivina-mi-numero))
;; empieza de nuevo
(defun empieza ()
  (defparameter *grande* 100)
  (defparameter *pequeño* 1)
  (adivina-mi-numero))
;; Supongamos que nuestro número es 83
(empieza)
(grand)
(grand)
(peque)
(grand)
;; En common LISP, el asignador más general
;; es setf. Nos sirve para dar valor a ambos
;; tipos de variables
(setf *glob* 90)
(let ((n 10))
  (setf n 2)
  n)
;;;;;;;;;;;;;;;; Programación funcional
;; Los pogramas regresan valores, no modifican cosas
;; las funciones son llamadas por los valores que
;; generan, no por los efectos secundarios
(setf lst '(u n a l i s t a))
(remove 'a lst)
lst

;;;;;;;;;;;;;;;; Control
;; Ramas
;; .......................................
;; comparadores
;; eq, eql, equal, =, equalp, string-equal
;; como se imaginarán, las comparaciones son
;; importantes en LISP
;; Regla de dedo: usa eq con símbolos,
;; equal con todo lo demás.
;; .......................................
;; La manera clásica de hacer branching en
;; LISP es con cond
(defun dia-semana (dia)
  (cond ((eq dia '1) '(Lunes))
        ((eq dia '2) '(Martes))
        ((eq dia '3) '(Miércoles))
        ((eq dia '4) '(Jueves))
        ((eq dia '5) '(Viernes))
        ((eq dia '6) '(Sábado))
        ((eq dia '7) '(Domingo))
        (t '(No es un día))))
(dia-semana 4)
(dia-semana 8)
;; Aunque también existen
;; if, when, unless, case
(if (oddp 5)
    'impar
    'par)

(when (oddp 5)
  'impar
  )

(unless (oddp 4)
  'impar
  )
(unless (oddp 5)
  'impar
  )

;; When y unless son más limitados
;; en el sentido de que no pueden hacer nada si
;; la condición evalúa lo contrario de lo esperado.

;; Iteraciones
(defun cuadrados (comienzo fin)
  (do ((i comienzo (+ i 1)))
      ((> i fin) i)
    (format t "~A ~A ~%" i (* i i))))
(cuadrados 2 5)
;; Una forma de hacer loops  menos Lispy
;; Iteración normal
(loop for i
   below 5
   sum i)
;; Iteración con límites superior
;; he inferior
(loop for i
   from 5
   to 10
   sum i)
;; Iterar sobre los miembros de una lista
(loop for i
   in '(100 20 30)
   sum i)
;; Iterar más condiciones
(loop for i
   below 10
   when (oddp i)
   sum i)
;; Recolectar valores
(loop for i
   in '(2 3 4 5 6)
   when (oddp i)
   collect (* i i))
;;;;;;;;;;;;;;;; Macros
(defun suma (a b)
  (let ((x (+ a b)))
    (format t "La suma es ~A" x)
    x))
(suma 3 4)
;; Por qué tantos paréntesis??
;; hagamos una mejora
(defmacro let1 (var val &body body)
  `(let ((,var, val))
     ,@body))

;; Let normal
(let ((foo (+ 2 3)))
  (* foo foo))

;; Con nuestra recién creada macro
(let1 foo (+ 2 3)
  (* foo foo))
