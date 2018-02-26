project ('com.github.cjfloss.sshconf', 'c', 'vala')

executable (
  meson.project_name (),
  'glue.vapi',
  'sshconf.vala',
  'sshconf-entry.vala',
  'sshconf-entry-model.vala',
  'sshconf-editor.vala',
  'sshconf-properties.vala',

  dependencies : [
      dependency('glib-2.0', version :'>=2.28.0'),
      dependency('gtk+-3.0', version :'>=3'),
      dependency('gee-0.8', version :'>=0.6'),
      meson.get_compiler('vala').find_library('posix'),
      meson.get_compiler('c').find_library('m', required : false)
  ],
  install : true
)
