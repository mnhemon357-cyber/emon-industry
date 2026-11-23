test:
	$(MAKE) -C divisions/emontron test
	python3 divisions/esecurity/src/ssh_bruteforce_detect.py /dev/null
	python3 divisions/eprinter/src/price.py
	python3 divisions/motior-pharma/src/telemetry_check.py
lint:
	command -v shellcheck >/dev/null && shellcheck divisions/eos-inhealer/src/audit.sh builder_blueprint.sh || true
	python3 -m compileall -q divisions
