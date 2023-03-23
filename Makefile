gen:
	flutter packages pub run build_runner build --delete-conflicting-outputs

rel:
	flutter build appbundle

clean:
	flutter clean

pub:
	flutter pub get
