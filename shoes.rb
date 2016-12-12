require './lib/initialize'

$app = Shoes.app(height: 700, width: 1100)
$app.font './fonts/inconsolata.otf'
$left = $app.flow(width: 700)
$right = $app.flow(width: 400)
Test.run_all
