.PHONY: nightly clean refresh

date = $(shell date +%Y-%m-%d)

builds = love/platform/macosx/build/Release
framework = love/platform/macosx/build/Release/love.framework
app = love/platform/macosx/build/Release/love.app

app_zip = builds/$(date)/$(date)-osx-app.zip
framework_zip = builds/$(date)/$(date)-osx-framework.zip

releases: $(app_zip) $(framework_zip)

$(app_zip): $(app)
	rm -f $@
	mkdir -p builds/$(date)
	cd $(builds) && zip -q ../../../../../$@ love.app

$(framework_zip): $(framework)
	rm -f $@
	mkdir -p builds/$(date)
	cd $(builds) && zip -q ../../../../../$@ love.framework

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


