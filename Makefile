# GO is the name of the 'go' binary used to compile.
GO ?= go

# BUILTIN_LD_FLAGS are the internal flags used to pass to the linker. By default
# DWARF-stripping is enabled unless DWARF=YesPlease.
BUILTIN_LD_FLAGS =
ifneq ("$(DWARF)","YesPlease")
BUILTIN_LD_FLAGS += -s
BUILTIN_LD_FLAGS += -w
endif
# EXTRA_LD_FLAGS are given by the caller, and are passed to the Go linker after
# BUILTIN_LD_FLAGS are processed. By default the system LDFLAGS are passed.
ifdef LDFLAGS
EXTRA_LD_FLAGS ?= -extldflags ${LDFLAGS}
endif
# LD_FLAGS is the union of the above two BUILTIN_LD_FLAGS and EXTRA_LD_FLAGS.
LD_FLAGS = $(BUILTIN_LD_FLAGS) $(EXTRA_LD_FLAGS)

# BUILTIN_GC_FLAGS are the internal flags used to pass compiler.
BUILTIN_GC_FLAGS ?= all=-trimpath="$$HOME"
# EXTRA_GC_FLAGS are the caller-provided flags to pass to the compiler.
EXTRA_GC_FLAGS =
# GC_FLAGS are the union of the above two BUILTIN_GC_FLAGS and EXTRA_GC_FLAGS.
GC_FLAGS = $(BUILTIN_GC_FLAGS) $(EXTRA_GC_FLAGS)

ASM_FLAGS ?= all=-trimpath="$$HOME"

# TRIMPATH contains arguments to be passed to go to strip paths on Go 1.13 and
# newer.
TRIMPATH ?= $(shell [ "$$($(GO) version | awk '{print $$3}' | sed -e 's/^[^.]*\.//;s/\..*$$//;')" -ge 13 ] && echo -trimpath)

# BUILD is a macro used to build a single binary using the above
# LD_FLAGS and GC_FLAGS.
#
# It takes three arguments:
#
# 	$(1) - a valid GOOS value, or empty-string
# 	$(2) - a valid GOARCH value, or empty-string
BUILD = GOOS=$(1) GOARCH=$(2) \
	$(GO) build \
	-ldflags="$(LD_FLAGS)" \
	-gcflags="$(GC_FLAGS)" \
	-asmflags="$(ASM_FLAGS)" \
	$(TRIMPATH) \
	humanize-test.go

.PHONY : all build
all build : humanize-test

humanize-test : humanize-test.go
	$(call BUILD,linux,amd64,-linux-amd64)
