validate:
	@echo "Executing terraform validate"
	terraform validate

lint:
	@echo "Executing tflint"
	docker run --rm -v $(shell pwd):/data -t ghcr.io/terraform-linters/tflint

doc:
	@echo "Executing tfdocs"
	docker run \
		--rm \
		-v $(shell pwd):/terraform-docs \
		-u $(shell id -u) \
		-t quay.io/terraform-docs/terraform-docs:0.16.0 \
			markdown table \
				--output-file README.md \
				--output-mode inject \
				/terraform-docs
