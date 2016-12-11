require './lib/initialize'

$app = Shoes.app(height: 700, width: 1100)
$app.font './fonts/inconsolata.otf'
Test.run_all
