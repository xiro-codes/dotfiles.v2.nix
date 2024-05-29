{mkShell, just, ...}: mkShell {
		packages = [just];
		shellHook = ''
			just -l
		'';
}
