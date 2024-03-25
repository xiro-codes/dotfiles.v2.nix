{lib,...}: with lib; {
	reduce =  f: list: (foldl f (head list)(tail list));
}
