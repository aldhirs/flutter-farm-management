update_launcher_icon:
	dart run flutter_launcher_icons

update_splash:
	flutter pub run flutter_native_splash:create --path=splash/splash.yaml

remove_splash:
	flutter pub run flutter_native_splash:remove --path=splash/splash.yaml

build_all:
	dart run build_runner build --delete-conflicting-outputs

clean_all:
	dart run build_runner build