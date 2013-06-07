.PHONY: nightly clean refresh

builds = love/platform/macosx/build/Release
framework = love/platform/macosx/build/Release/love.framework
app = love/platform/macosx/build/Release/love.app
win32 = love/platform/msvc2010/bin/x86/Release/MT/love.exe
win64 = love/platform/msvc2010/bin/amd64/Release/MT/love.exe

app_zip = builds/love-nightly-macosx-ub.zip
win32_zip = builds/love-nightly-win-x86.zip
win64_zip = builds/love-nightly-win-x64.zip

releases: refresh $(app_zip) $(win32_zip) $(win64_zip)

$(app_zip): $(app)
	rm -f $@
	ditto -c -k --sequesterRsrc --keepParent $< $@

$(win32_zip): $(win32)
	rm -rf $@ win32
	mkdir -p win32
	cp -r love/platform/msvc2010/bin/x86/Release/MT win32/love
	cd win32 && zip -r -q ../$@ love -x "*.pdb" -x "*.lib" -x "*.exp"

$(win64_zip): $(win64)
	rm -rf $@ win64
	mkdir -p win64
	cp -r love/platform/msvc2010/bin/amd64/Release/MT win64/love
	cd win64 && zip -r -q ../$@ love -x "*.pdb" -x "*.lib" -x "*.exp"

clean:
	rm -rf $(app_zip)
	rm -rf $(win32_zip)
	rm -rf $(win64_zip)

refresh: love/src/*
	cd love && hg pull && hg update

$(framework): love/src/*
	xcodebuild -project love/platform/macosx/love-framework.xcodeproj/ \
		-target Framework -configuration Release > /dev/null


$(app): $(framework) love/src/*
	xcodebuild -project love/platform/macosx/love.xcodeproj/ \
		-target love -configuration Release > /dev/null

love/src:
	hg clone ssh://hg@bitbucket.org/rude/love
