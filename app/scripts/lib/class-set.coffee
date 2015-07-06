classSet = (klasses)->
  truthy = for klass of klasses
    klass if klasses[klass]
  truthy.join ' '

module.exports = classSet
