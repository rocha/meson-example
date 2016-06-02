project('demo', 'cpp',
  default_options: ['cpp_std=c++11'])

config = configuration_data()
version = run_command('git', 'describe', '--tags')
config.set('version', version.stdout().strip())
configure_file(input: 'src/main.h.in', output: 'main.h', configuration: config)

threads = dependency('threads')

src = ['src/main.cpp']

demo = executable('demo', src, dependencies: threads)
test('simple test', demo)