# Catch all targets and forward them to .mk
.PHONY: % default

default:
	@$(MAKE) -f zlib.mk $(MAKECMDGOALS)

%:
	@$(MAKE) -f zlib.mk $(MAKECMDGOALS)