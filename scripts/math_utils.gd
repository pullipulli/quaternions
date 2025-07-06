extends Node


# it uses BBCode encoding
func decimal_to_string(decimal: float, tolerance: float = 0.0000001):
	var fraction = decimal_to_fraction(decimal, tolerance)
	
	if fraction[0] == 0:
		return "+ 0"
		
	if fraction[1] == fraction[0]:
		return "1"
		
	if fraction[0] > 0:
		return "+" + str(fraction[0]) + "/" + str(fraction[1])
	
	return str(fraction[0]) + "/" + str(fraction[1])
	

func decimal_to_fraction(decimal: float, tolerance: float = 0.000001) -> Array:
	# Gestione del segno e casi speciali
	if decimal == 0:
		return [0, 1]
	
	var is_negative = decimal < 0
	var x = abs(decimal)
	
	# Parte intera e frazionaria
	var integer_part = int(x)
	var fractional = x - integer_part
	
	# Algoritmo frazioni continue
	var a0 = 0
	var a1 = 1
	var b0 = 1
	var b1 = 0
	
	var remainder = fractional
	var iter = 0
	var max_iter = 100  # Prevenzione loop infinito
	
	while iter < max_iter:
		iter += 1
		var whole = floor(remainder)
		var temp = a1
		a1 = whole * a1 + a0
		a0 = temp
		
		temp = b1
		b1 = whole * b1 + b0
		b0 = temp
		
		var error = abs(fractional - float(a1) / float(b1))
		if error < tolerance:
			break
		
		remainder = 1.0 / (remainder - whole) if remainder != whole else 0
	
	# Frazione finale con parte intera
	var num = a1 + integer_part * b1
	var den = b1
	
	# Applica segno
	if is_negative:
		num = -num
	
	# Riduci la frazione
	return reduce_fraction(num, den)

func reduce_fraction(numerator: int, denominator: int) -> Array:
	# Calcola MCD con algoritmo di Euclide
	var a = abs(numerator)
	var b = abs(denominator)
	while b != 0:
		var temp = b
		b = a % b
		a = temp
	
	var gcd = a
	if gcd == 0:
		gcd = 1
	
	# Riduci e gestisci segno
	var reduced_num = numerator / gcd
	var reduced_den = denominator / gcd
	
	# Assicura denominatore positivo
	if reduced_den < 0:
		reduced_num = -reduced_num
		reduced_den = -reduced_den
	
	return [reduced_num, reduced_den]
