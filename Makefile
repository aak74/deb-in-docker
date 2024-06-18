SUFFIX=$(shell date "+%s")
WORKDIR=$(shell pwd)

build-image:
	docker build -t s3fs_fuse_builder .

build-package:
	docker run \
    -v $(WORKDIR)/build:/build \
    -v $(WORKDIR)/release:/release \
	--name s3fs_build_$(SUFFIX) \
    s3fs_fuse_builder

all: build-image build-package