# flutter drive \
#   --driver=driver_test/integration_test.dart \
#   --target=integration_test/menu_float_test.dart \
#   -d chrome

# flutter drive \
#   --driver=driver_test/integration_test.dart \
#   --target=integration_test/menu_float_test.dart \
#   -d chrome --browser-name=chrome --profile

flutter test \
	&& fswatch -e ".*" -i "\\.dart$" . | xargs -n1 -I {} sh -c "echo $'\e[1;31m'{}$'\e[0m'; flutter test -j 2 ./test"