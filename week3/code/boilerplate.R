MyFunc = function(Arg1, Arg2) {
	print( paste("Argument", as.character(Arg1), "is a", class(Arg1)))
	print( paste("Argument", as.character(Arg2), "is a", class(Arg2)))

	return (c(Arg1, Arg2))
}

MyFunc(1,2)
MyFunc("Riki", 'Tiki')

