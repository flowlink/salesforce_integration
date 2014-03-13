require_relative 'app'
require App.root.join("config/environments", App.env)
$: << App.root.join('lib')
