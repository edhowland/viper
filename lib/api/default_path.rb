# default_path.rb: method: default_path(path_or_name, default: '/v/path')

# default_path with a name and  a default:, will append to  default
# with a fully qualified name,  will just return it


def default_path(path_or_name, default:)
  rx = /\/[a-zA-Z_]+\/.*/
  if rx.match(path_or_name)
    path_or_name
  else
    default + '/' + path_or_name
  end
end