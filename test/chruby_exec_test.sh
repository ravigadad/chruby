. ./test/helper.sh

PROJECT_DIR="$PWD/test/project"

function test_chruby_exec_no_arguments()
{
	chruby-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec_no_command()
{
	chruby-exec "$test_ruby_version" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec_no_ruby_or_ruby_version_file()
{
	local command="ruby -e 'print RUBY_VERSION'"
	chruby-exec -- '$command' 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chruby_exec_no_ruby_but_with_ruby_version_file()
{
	local command="echo \$RUBY_ROOT"
	local ruby_root=$(cd $PROJECT_DIR && chruby-exec -- $command)

	assertEquals "did not use ruby specified in file" "$test_ruby_root" "$ruby_root"
}

function test_chruby_exec()
{
	local command="echo \$RUBY_ROOT"
	local ruby_root=$(chruby-exec "$test_ruby_version-p$test_ruby_patchlevel" -- $command)

	assertEquals "did not change the ruby" "$test_ruby_root" "$ruby_root"
}

SHUNIT_PARENT=$0 . $SHUNIT2
