require './lib/initialize'

system('git check-pull') || abort('please pull')
system('git acpe') || abort('save failed')
system('clear')
Test.run_all!
