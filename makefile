update_launcher_icon:
	dart run flutter_launcher_icons

update_splash:
	dart run flutter_native_splash:create

remove_splash:
	dart run flutter_native_splash:remove

build_all:
	dart run build_runner build --delete-conflicting-outputs

clean_all:
	dart run build_runner build

build_apk_dev:
	flutter build apk --debug

build_apk_release:
	flutter build apk --release

	
	