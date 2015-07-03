Rails.application.assets.register_engine '.slim', Slim::Template

Slim::Engine.set_options format: :html5
Slim::Engine.set_options attr_list_delims: {'(' => ')', '[' => ']'}
Slim::Engine.set_options code_attr_delims: {'(' => ')', '[' => ']'}
# Slim::Engine.set_options shortcut: {'.' => {:attr => 'class'}, '#' => {:attr => 'id'}, '@' => { attr: 'role' }}
