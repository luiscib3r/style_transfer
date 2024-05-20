#!/bin/sh

baseUrl=$1
echo "Building web workers with base URL: $baseUrl"
flutter_path=$(which flutter)
flutter_web_sdk=$(dirname $flutter_path)/cache/flutter_web_sdk
echo "Using Flutter Web SDK at: $flutter_web_sdk"
dart compile js -O2 --libraries-spec=$flutter_web_sdk/libraries.json --define=baseUrl=$baseUrl -o web/styler_worker.dart.js lib/styler_worker.dart
dart compile js -O2 --libraries-spec=$flutter_web_sdk/libraries.json --define=baseUrl=$baseUrl -o web/filter_worker.dart.js lib/filter_worker.dart