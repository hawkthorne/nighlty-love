.PHONY: nightly clean refresh

builds = love/platform/macosx/build/Release
framework = love/platform/macosx/build/Release/love.framework
app = love/platform/macosx/build/Release/love.app

app_zip = builds/love-nightly-macosx-ub.zip
framework_zip = builds/liblove-nightly-macosx-ub.zip
win32_zip = builds/love-nightly-win-x86.zip
win64_zip = builds/love-nightly-win-x64.zip

releases: refresh $(app_zip) $(framework_zip)

$(app_zip): $(app)
	rm -f $@
	mkdir -p builds
	cd $(builds) && zip --symlinks -r -q ../../../../../$@ love.app

$(framework_zip): $(framework)
	rm -f $@
	mkdir -p builds
	cd $(builds) && zip --symlinks -r -q ../../../../../$@ love.framework

$(win32_zip): $(framework)
	rm -f $@
	mkdir -p builds
	cd $(builds) && zip --symlinks -r -q ../../../../../$@ love.framework


clean:
	rm -rf love/platform/macosx/build/Release/love.framework
	rm -rf love/platform/macosx/build/Release/love.app

refresh: love/src
	cd love && hg pull && hg update

$(framework): love/src
	xcodebuild -project love/platform/macosx/love-framework.xcodeproj/ \
		-target Framework -configuration Release > /dev/null


$(app): $(framework) love/src
	xcodebuild -project love/platform/macosx/love.xcodeproj/ \
		-target love -configuration Release > /dev/null

love/src:
	hg clone ssh://hg@bitbucket.org/rude/love
