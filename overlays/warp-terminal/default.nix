{
  channels,
  my-inputs,
  ...
}: final: prev: let 
		pkgs = channels.nixpkgs;
in {
	wrap-terminal = pkgs.wrap-terminal.override (old: {
			waylandSupport = true;
		})
	}
