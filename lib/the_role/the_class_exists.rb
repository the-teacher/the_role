# the_class_exists? :User => true | flase
# the_class_exists? :Role => true | flase
def the_class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end